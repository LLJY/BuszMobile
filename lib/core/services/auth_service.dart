/// Authentication service for the Frontline nonce-challenge flow.
///
/// Handles ECDSA P-256 signing of nonces to obtain Bearer tokens from the
/// Identity Service. Tokens are refreshed proactively every 50 minutes
/// and reactively on 401 responses.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:pointycastle/export.dart';
import 'package:pointycastle/asn1/asn1_parser.dart';
import 'package:pointycastle/asn1/primitives/asn1_sequence.dart';
import 'package:pointycastle/asn1/primitives/asn1_octet_string.dart';

// =============================================================================
// Configuration
// =============================================================================

const String _defaultAuthBaseUrl = 'https://pidsauth.floatpoint.dev';
const String _defaultClientId = '317f7bd6-306c-49b3-95cc-8e29d687fe61';

/// How early to refresh before expiry (10 minutes buffer on a 60-min token)
const Duration _refreshBuffer = Duration(minutes: 10);

// =============================================================================
// Auth Service
// =============================================================================

/// Singleton authentication service that manages the frontline Bearer token.
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  AuthService._internal();

  String _authBaseUrl = _defaultAuthBaseUrl;
  String _clientId = _defaultClientId;
  ECPrivateKey? _privateKey;

  String? _accessToken;
  DateTime _expiresAt = DateTime.fromMillisecondsSinceEpoch(0);
  Completer<String>? _refreshCompleter;
  Timer? _proactiveRefreshTimer;

  bool get isInitialized => _privateKey != null;

  /// Initialize with configuration from environment.
  ///
  /// [privateKeyPem] - PEM-encoded ECDSA P-256 private key
  /// [authBaseUrl] - Override auth server URL (optional)
  /// [clientId] - Override client ID (optional)
  void initialize({
    required String privateKeyPem,
    String? authBaseUrl,
    String? clientId,
  }) {
    if (authBaseUrl != null) _authBaseUrl = authBaseUrl;
    if (clientId != null) _clientId = clientId;
    _privateKey = _parsePemPrivateKey(privateKeyPem);
    debugPrint('[Auth] Initialized with ECDSA P-256 key');
  }

  /// Get a valid Bearer token. Returns cached token if still valid,
  /// otherwise performs the challenge-sign-token flow.
  Future<String> getToken() async {
    if (_privateKey == null) {
      throw StateError('AuthService not initialized. Call initialize() first.');
    }

    // Return cached token if still valid (with buffer)
    if (_accessToken != null &&
        DateTime.now().isBefore(_expiresAt.subtract(_refreshBuffer))) {
      return _accessToken!;
    }

    // Coalesce concurrent refresh requests
    if (_refreshCompleter != null) {
      return _refreshCompleter!.future;
    }

    _refreshCompleter = Completer<String>();
    try {
      final token = await _authenticate();
      _refreshCompleter!.complete(token);
      return token;
    } catch (e) {
      _refreshCompleter!.completeError(e);
      rethrow;
    } finally {
      _refreshCompleter = null;
    }
  }

  /// Force a token refresh (e.g., on 401 response).
  Future<String> forceRefresh() async {
    _accessToken = null;
    _expiresAt = DateTime.fromMillisecondsSinceEpoch(0);
    return getToken();
  }

  /// Get headers map for gRPC calls.
  Future<Map<String, String>> getAuthHeaders() async {
    final token = await getToken();
    return {'authorization': 'Bearer $token'};
  }

  /// Dispose resources.
  void dispose() {
    _proactiveRefreshTimer?.cancel();
    _proactiveRefreshTimer = null;
  }

  // ===========================================================================
  // Private: Authentication Flow
  // ===========================================================================

  /// Perform the full nonce-challenge authentication:
  /// 1. POST /connect/challenge -> nonce
  /// 2. Sign nonce with ECDSA-SHA256 (raw R||S, base64)
  /// 3. POST /connect/token -> access_token
  Future<String> _authenticate() async {
    debugPrint('[Auth] Authenticating via nonce-challenge...');

    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);

    try {
      // Step 1: Get challenge nonce
      final challengeReq = await client.postUrl(
        Uri.parse('$_authBaseUrl/connect/challenge'),
      );
      challengeReq.headers.contentType = ContentType(
        'application',
        'x-www-form-urlencoded',
      );
      challengeReq.write('clientId=${Uri.encodeComponent(_clientId)}');
      final challengeRes = await challengeReq.close();

      if (challengeRes.statusCode != 200) {
        final body = await challengeRes.transform(utf8.decoder).join();
        throw Exception('Challenge failed (${challengeRes.statusCode}): $body');
      }

      final challengeBody = await challengeRes.transform(utf8.decoder).join();
      final nonce =
          (jsonDecode(challengeBody) as Map<String, dynamic>)['nonce']
              as String;

      // Step 2: Sign nonce with ECDSA-SHA256 (raw R||S format)
      final signedNonce = _signNonce(nonce);

      // Step 3: Exchange signed nonce for access token
      final tokenReq = await client.postUrl(
        Uri.parse('$_authBaseUrl/connect/token'),
      );
      tokenReq.headers.contentType = ContentType(
        'application',
        'x-www-form-urlencoded',
      );
      tokenReq.write(
        'grant_type=${Uri.encodeComponent("urn:custom:nonce-challenge")}'
        '&client_id=${Uri.encodeComponent(_clientId)}'
        '&signed_nonce=${Uri.encodeComponent(signedNonce)}',
      );
      final tokenRes = await tokenReq.close();

      if (tokenRes.statusCode != 200) {
        final body = await tokenRes.transform(utf8.decoder).join();
        throw Exception(
          'Token exchange failed (${tokenRes.statusCode}): $body',
        );
      }

      final tokenBody = await tokenRes.transform(utf8.decoder).join();
      final tokenData = jsonDecode(tokenBody) as Map<String, dynamic>;

      _accessToken = tokenData['access_token'] as String;
      final expiresIn = tokenData['expires_in'] as int;
      _expiresAt = DateTime.now().add(Duration(seconds: expiresIn));

      debugPrint('[Auth] Token acquired, expires in ${expiresIn ~/ 60}m');

      // Schedule proactive refresh
      _scheduleProactiveRefresh(expiresIn);

      return _accessToken!;
    } finally {
      client.close();
    }
  }

  /// Schedule proactive token refresh 50 minutes into the token lifecycle.
  void _scheduleProactiveRefresh(int expiresInSeconds) {
    _proactiveRefreshTimer?.cancel();

    // Refresh 10 minutes before expiry
    final refreshInSeconds = expiresInSeconds - _refreshBuffer.inSeconds;
    if (refreshInSeconds <= 0) return;

    _proactiveRefreshTimer = Timer(
      Duration(seconds: refreshInSeconds),
      () async {
        try {
          debugPrint('[Auth] Proactive token refresh...');
          await forceRefresh();
        } catch (e) {
          debugPrint('[Auth] Proactive refresh failed: $e');
          // Retry in 30 seconds
          _proactiveRefreshTimer = Timer(const Duration(seconds: 30), () async {
            try {
              await forceRefresh();
            } catch (e) {
              debugPrint('[Auth] Retry refresh failed: $e');
            }
          });
        }
      },
    );
  }

  // ===========================================================================
  // Private: ECDSA Signing
  // ===========================================================================

  /// Sign a nonce with ECDSA-SHA256, producing raw R||S (IEEE P1363) base64.
  String _signNonce(String nonce) {
    final nonceBytes = Uint8List.fromList(utf8.encode(nonce));

    // Hash with SHA-256 first
    final sha256 = SHA256Digest();
    final hash = sha256.process(nonceBytes);

    // Sign with ECDSA
    final signer = ECDSASigner(null, HMac(SHA256Digest(), 64));
    signer.init(true, PrivateKeyParameter<ECPrivateKey>(_privateKey!));
    final sig = signer.generateSignature(hash) as ECSignature;

    // Encode as raw R||S (32 bytes each for P-256), base64
    final rBytes = _bigIntToFixedBytes(sig.r, 32);
    final sBytes = _bigIntToFixedBytes(sig.s, 32);
    final rawSig = Uint8List(64);
    rawSig.setRange(0, 32, rBytes);
    rawSig.setRange(32, 64, sBytes);

    return base64Encode(rawSig);
  }

  /// Convert a BigInt to a fixed-length byte array (big-endian, zero-padded).
  Uint8List _bigIntToFixedBytes(BigInt value, int length) {
    final bytes = _bigIntToBytes(value);
    if (bytes.length == length) return bytes;
    if (bytes.length > length) {
      // Trim leading bytes (shouldn't happen with P-256)
      return Uint8List.fromList(bytes.sublist(bytes.length - length));
    }
    // Pad with leading zeros
    final padded = Uint8List(length);
    padded.setRange(length - bytes.length, length, bytes);
    return padded;
  }

  /// Convert BigInt to unsigned big-endian bytes.
  Uint8List _bigIntToBytes(BigInt value) {
    final hex = value.toRadixString(16);
    final paddedHex = hex.length.isOdd ? '0$hex' : hex;
    final bytes = Uint8List(paddedHex.length ~/ 2);
    for (var i = 0; i < bytes.length; i++) {
      bytes[i] = int.parse(paddedHex.substring(i * 2, i * 2 + 2), radix: 16);
    }
    return bytes;
  }

  // ===========================================================================
  // Private: PEM Parsing
  // ===========================================================================

  /// Parse a PEM-encoded EC private key into a PointyCastle ECPrivateKey.
  ECPrivateKey _parsePemPrivateKey(String pem) {
    // Normalize escaped newlines
    final normalized = pem.replaceAll('\\n', '\n');
    final lines = normalized
        .split('\n')
        .where((l) => !l.startsWith('-----') && l.trim().isNotEmpty)
        .join('');
    final derBytes = base64Decode(lines);

    // Parse ASN.1 DER structure for EC private key (SEC 1 format)
    final asn1Parser = ASN1Parser(Uint8List.fromList(derBytes));
    final sequence = asn1Parser.nextObject() as ASN1Sequence;

    // Extract private key bytes (second element in sequence)
    final privateKeyOctet = sequence.elements![1] as ASN1OctetString;
    final d = _bytesToBigInt(privateKeyOctet.valueBytes!);

    // Use P-256 curve parameters
    final params = ECCurve_secp256r1();
    return ECPrivateKey(d, params);
  }

  /// Convert big-endian bytes to BigInt.
  BigInt _bytesToBigInt(Uint8List bytes) {
    var result = BigInt.zero;
    for (final byte in bytes) {
      result = (result << 8) | BigInt.from(byte);
    }
    return result;
  }
}
