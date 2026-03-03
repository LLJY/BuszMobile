/// Connect-RPC client service for the Frontline API.
///
/// Uses gRPC-Web protocol for Cloudflare compatibility.
/// Authentication: nonce-challenge flow (ECDSA P-256) via [AuthService].
library;

import 'package:connectrpc/connect.dart';
import 'package:connectrpc/http2.dart';
import 'package:connectrpc/protobuf.dart';
import 'package:connectrpc/protocol/grpc_web.dart' as protocol;
import 'package:flutter/foundation.dart';

import '../../core/services/auth_service.dart';
import '../../gen/common/types.pb.dart' as common_pb;
import '../../gen/frontline/frontline_service.pb.dart' as pb;
import '../../gen/frontline/frontline_service.connect.client.dart';
import '../../gen/google/protobuf/timestamp.pb.dart' as ts_pb;
import '../models/models.dart';

// =============================================================================
// Frontline Service
// =============================================================================

/// Service for interacting with the Frontline gRPC API via Connect-RPC.
///
/// Exposes only the RPCs needed by the debug app:
/// - [searchBusStops] for the search screen
/// - [getStopArrivals] for the stop detail screen (with bus locations)
class FrontlineService {
  Transport? _transport;
  final AuthService _authService = AuthService();

  /// Endpoint configuration.
  /// Override with --dart-define=GRPC_URL=http://...
  static const String _baseUrl = String.fromEnvironment(
    'GRPC_URL',
    defaultValue: 'https://pidsapi.floatpoint.dev',
  );

  /// Creates the Connect-RPC transport if not already created.
  Transport _getTransport() {
    if (_transport != null) return _transport!;

    _transport = protocol.Transport(
      baseUrl: _baseUrl,
      codec: const ProtoCodec(),
      httpClient: createHttpClient(),
      statusParser: const StatusParser(),
    );
    return _transport!;
  }

  /// Gets the FrontlineService client.
  FrontlineServiceClient _getClient() {
    return FrontlineServiceClient(_getTransport());
  }

  /// Get auth headers for gRPC calls.
  Future<Headers> _getAuthHeaders() async {
    final headerMap = await _authService.getAuthHeaders();
    final headers = Headers();
    headerMap.forEach((key, value) {
      headers[key] = value;
    });
    return headers;
  }

  /// Closes the transport.
  void dispose() {
    _transport = null;
    _authService.dispose();
  }

  // ===========================================================================
  // Search Bus Stops
  // ===========================================================================

  /// Searches for bus stops by name or code.
  ///
  /// [query] - Search query (stop name or code)
  /// [limit] - Maximum number of results (default: 20)
  Future<List<BusStopSearchResult>> searchBusStops(
    String query, {
    int limit = 20,
  }) async {
    final client = _getClient();
    final request = pb.SearchBusStopsRequest()
      ..query = query
      ..limit = limit;
    final headers = await _getAuthHeaders();

    late final pb.SearchBusStopsResponse response;
    try {
      response = await client.searchBusStops(request, headers: headers);
    } catch (e) {
      if (_isAuthError(e)) {
        debugPrint('[Frontline] Auth error on search, refreshing...');
        await _authService.forceRefresh();
        final retryHeaders = await _getAuthHeaders();
        response = await client.searchBusStops(request, headers: retryHeaders);
      } else {
        rethrow;
      }
    }

    return response.results.map((r) {
      final hasLocation = r.busStop.hasLocation();
      return BusStopSearchResult(
        busStopCode: r.busStop.code,
        busStopName: r.busStop.name,
        serviceNos: r.serviceNos.toList(),
        relevanceScore: r.relevanceScore,
        latitude: hasLocation ? r.busStop.location.latitude : null,
        longitude: hasLocation ? r.busStop.location.longitude : null,
      );
    }).toList();
  }

  // ===========================================================================
  // Get Stop Arrivals (with bus locations)
  // ===========================================================================

  /// Fetches stop arrivals with optional live bus GPS positions.
  ///
  /// [busStopCode] - The unique code identifying the bus stop
  /// [includeBusLocations] - Whether to include live GPS positions
  Future<StopArrivalsData> getStopArrivals(
    String busStopCode, {
    bool includeBusLocations = true,
  }) async {
    final client = _getClient();
    final request = pb.GetStopArrivalsRequest()
      ..busStopCode = busStopCode
      ..includeBusLocations = includeBusLocations;
    final headers = await _getAuthHeaders();

    late final pb.GetStopArrivalsResponse response;
    try {
      response = await client.getStopArrivals(request, headers: headers);
    } catch (e) {
      if (_isAuthError(e)) {
        debugPrint('[Frontline] Auth error on getStopArrivals, refreshing...');
        await _authService.forceRefresh();
        final retryHeaders = await _getAuthHeaders();
        response = await client.getStopArrivals(request, headers: retryHeaders);
      } else {
        rethrow;
      }
    }

    return _mapStopArrivalsData(response.data);
  }

  // ===========================================================================
  // Private: Mapping
  // ===========================================================================

  /// Maps protobuf StopArrivalsData to domain model.
  StopArrivalsData _mapStopArrivalsData(pb.StopArrivalsData proto) {
    return StopArrivalsData(
      busStopCode: proto.busStopCode,
      busStopName: proto.busStopName,
      buses: proto.buses.map(_mapBusArrival).toList(),
      busLocations: proto.busLocations.map(_mapBusLocation).toList(),
      updatedAt: proto.hasUpdatedAt()
          ? _timestampToDateTime(proto.updatedAt)
          : null,
    );
  }

  /// Maps protobuf BusArrival to domain model.
  BusArrivalInfo _mapBusArrival(pb.BusArrival proto) {
    return BusArrivalInfo(
      serviceNo: proto.serviceNo.split('~')[0],
      direction: proto.direction,
      color: proto.color.isEmpty ? '#666666' : proto.color,
      isFree: proto.isFree,
      destination: proto.destination,
      nextArrival: proto.hasNextArrival()
          ? _mapArrivalTime(proto.nextArrival)
          : null,
      laterArrival: proto.hasLaterArrival()
          ? _mapArrivalTime(proto.laterArrival)
          : null,
      plateNo: proto.plateNo,
      laterPlateNo: proto.laterPlateNo,
      isDeparting: proto.isDeparting,
      etaSource: proto.etaSource.name,
      delayStatus: proto.delayStatus.name,
      delayMinutes: proto.delayMinutes,
    );
  }

  /// Maps protobuf ArrivalTime to domain model.
  ArrivalTime? _mapArrivalTime(common_pb.ArrivalTime proto) {
    if (!proto.hasTime()) return null;
    return ArrivalTime(
      time: _timestampToDateTime(proto.time),
      isLive: proto.isLive,
    );
  }

  /// Maps protobuf BusPosition to domain model.
  BusLocationInfo _mapBusLocation(pb.BusPosition proto) {
    return BusLocationInfo(
      plateNo: proto.plateNo,
      serviceNo: proto.serviceNo.split('~')[0],
      direction: proto.direction,
      latitude: proto.location.latitude,
      longitude: proto.location.longitude,
      speedKmh: proto.speedKmh,
      heading: proto.heading,
      timestamp: proto.hasTimestamp()
          ? _timestampToDateTime(proto.timestamp)
          : null,
      nextStopCode: proto.nextStopCode,
      nextStopName: proto.nextStopName,
      etaToNextStopMinutes: proto.etaToNextStopMinutes,
    );
  }

  /// Check if an error is a Connect-RPC unauthenticated error.
  bool _isAuthError(Object error) {
    if (error is ConnectException) {
      return error.code == Code.unauthenticated ||
          error.code == Code.permissionDenied;
    }
    // Fallback for non-typed errors
    final msg = error.toString().toLowerCase();
    return msg.contains('unauthenticated') || msg.contains('401');
  }

  /// Converts protobuf Timestamp to local DateTime.
  DateTime _timestampToDateTime(ts_pb.Timestamp timestamp) {
    final seconds = timestamp.seconds.toInt();
    final nanos = timestamp.nanos;
    return DateTime.fromMillisecondsSinceEpoch(
      seconds * 1000 + nanos ~/ 1000000,
      isUtc: true,
    ).toLocal();
  }
}
