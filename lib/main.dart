/// BuszMobile - Reference implementation for MyBusz gRPC endpoints.
///
/// Entry point: loads .env credentials, initializes auth, launches app
/// with go_router and Riverpod.
library;

import 'dart:io' show File, Platform;

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/router.dart';
import 'core/services/auth_service.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize authentication (nonce-challenge with ECDSA P-256)
  await _initializeAuth();

  runApp(const ProviderScope(child: MyBuszDebugApp()));
}

// =============================================================================
// App Widget
// =============================================================================

class MyBuszDebugApp extends StatelessWidget {
  const MyBuszDebugApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'BuszMobile',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
    );
  }
}

// =============================================================================
// Auth Initialization
// =============================================================================

/// Load credentials and initialize the AuthService singleton.
///
/// Resolution order (first wins):
///   1. Compile-time: --dart-define or --dart-define-from-file=.env.json
///   2. Filesystem:   .env file in CWD (desktop only, ignored on mobile)
///
/// Cross-platform build command:
///   flutter run --dart-define-from-file=.env.json
///   flutter build apk --dart-define-from-file=.env.json
Future<void> _initializeAuth() async {
  // 1. Compile-time --dart-define (works on ALL platforms)
  const envPrivateKey = String.fromEnvironment('FRONTLINE_PRIVATE_KEY');
  const envAuthBaseUrl = String.fromEnvironment('AUTH_BASE_URL');
  const envClientId = String.fromEnvironment('FRONTLINE_CLIENT_ID');

  String? privateKey = envPrivateKey.isNotEmpty ? envPrivateKey : null;
  String? authBaseUrl = envAuthBaseUrl.isNotEmpty ? envAuthBaseUrl : null;
  String? clientId = envClientId.isNotEmpty ? envClientId : null;

  // 2. Filesystem .env fallback (desktop dev convenience only)
  if (privateKey == null && !kIsWeb && _isDesktop) {
    final envVars = _loadEnvFile();
    privateKey = envVars['FRONTLINE_PRIVATE_KEY'];
    authBaseUrl ??= envVars['AUTH_BASE_URL'];
    clientId ??= envVars['FRONTLINE_CLIENT_ID'];
  }

  if (privateKey == null || privateKey.isEmpty) {
    debugPrint(
      '[Auth] WARNING: No FRONTLINE_PRIVATE_KEY found.\n'
      '[Auth] Build with: flutter run --dart-define-from-file=.env.json',
    );
    return;
  }

  debugPrint(
    '[Auth] Credentials loaded via '
    '${envPrivateKey.isNotEmpty ? "--dart-define" : ".env file"}',
  );

  AuthService().initialize(
    privateKeyPem: privateKey,
    authBaseUrl: authBaseUrl,
    clientId: clientId,
  );

  // Pre-fetch initial token
  try {
    await AuthService().getToken();
    debugPrint('[Auth] Initial authentication successful');
  } catch (e) {
    debugPrint('[Auth] Initial authentication failed: $e');
    debugPrint('[Auth] Will retry on first API call');
  }
}

/// Whether running on a desktop platform (filesystem .env works).
bool get _isDesktop =>
    Platform.isLinux || Platform.isWindows || Platform.isMacOS;

/// Parse a .env file from CWD or home dir (desktop only).
Map<String, String> _loadEnvFile() {
  final searchPaths = ['.env', '${Platform.environment['HOME']}/.mybusz/.env'];

  for (final path in searchPaths) {
    final envFile = File(path);
    if (envFile.existsSync()) {
      debugPrint('[Auth] Loading .env from: ${envFile.absolute.path}');
      return _parseEnvFile(envFile.readAsStringSync());
    }
  }

  debugPrint('[Auth] No .env file found on disk');
  return {};
}

/// Parse .env file content into key=value pairs.
Map<String, String> _parseEnvFile(String content) {
  final result = <String, String>{};
  for (final line in content.split('\n')) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;

    final eqIndex = trimmed.indexOf('=');
    if (eqIndex < 0) continue;

    final key = trimmed.substring(0, eqIndex).trim();
    var value = trimmed.substring(eqIndex + 1).trim();

    // Strip quotes
    if ((value.startsWith('"') && value.endsWith('"')) ||
        (value.startsWith("'") && value.endsWith("'"))) {
      value = value.substring(1, value.length - 1);
    }

    // Unescape \n
    value = value.replaceAll('\\n', '\n');

    result[key] = value;
  }
  return result;
}
