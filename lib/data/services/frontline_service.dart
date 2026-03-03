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

import '../../core/error/app_exception.dart';
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
/// - [streamStopArrivals] for real-time push updates via server-streaming
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
        try {
          await _authService.forceRefresh();
          final retryHeaders = await _getAuthHeaders();
          response = await client.searchBusStops(
            request,
            headers: retryHeaders,
          );
        } catch (retryError) {
          throw AppException.from(retryError);
        }
      } else {
        throw AppException.from(e);
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
        try {
          await _authService.forceRefresh();
          final retryHeaders = await _getAuthHeaders();
          response = await client.getStopArrivals(
            request,
            headers: retryHeaders,
          );
        } catch (retryError) {
          throw AppException.from(retryError);
        }
      } else {
        throw AppException.from(e);
      }
    }

    return _mapStopArrivalsData(response.data);
  }

  // ===========================================================================
  // Stream Stop Arrivals (real-time push)
  // ===========================================================================

  /// Streams real-time stop arrival updates via server-streaming RPC.
  ///
  /// The server sends an initial [fullUpdate] followed by incremental
  /// [deltaUpdate] messages. This method maps protos to domain models
  /// and applies deltas to maintain a consistent snapshot.
  ///
  /// [busStopCode] - The unique code identifying the bus stop
  /// [includeBusLocations] - Whether to include live GPS positions
  Stream<StopArrivalsData> streamStopArrivals(
    String busStopCode, {
    bool includeBusLocations = true,
  }) async* {
    final headers = await _getAuthHeaders();
    final client = _getClient();

    final request = pb.StreamStopArrivalsRequest()
      ..busStopCode = busStopCode
      ..includeBusLocations = includeBusLocations;

    StopArrivalsData? lastData;

    await for (final update in client.streamStopArrivals(
      request,
      headers: headers,
    )) {
      if (update.hasFullUpdate()) {
        lastData = _mapStopArrivalsData(update.fullUpdate);
        yield lastData;
      } else if (update.hasDeltaUpdate() && lastData != null) {
        final current = lastData;
        lastData = applyArrivalsDelta(
          current: current,
          updatedArrivals: update.deltaUpdate.updated
              .map(_mapBusArrival)
              .toList(),
          removedServiceNos: update.deltaUpdate.removedServiceNos.toList(),
          updatedAt: update.hasTimestamp()
              ? _timestampToDateTime(update.timestamp)
              : null,
        );
        yield lastData;
      }
    }
  }

  // ===========================================================================
  // Find Nearby Stops
  // ===========================================================================

  /// Finds bus stops near the given GPS coordinates.
  ///
  /// [lat] / [lng] - The user's current GPS position
  /// [radiusMeters] - Search radius in metres (default: 500)
  /// [limit] - Maximum number of results (default: 10)
  Future<List<NearbyStop>> findNearbyStops(
    double lat,
    double lng, {
    double radiusMeters = 500,
    int limit = 10,
  }) async {
    final client = _getClient();
    final request = pb.FindNearbyStopsRequest()
      ..ensureLocation().latitude = lat
      ..ensureLocation().longitude = lng
      ..radiusMeters = radiusMeters
      ..limit = limit;
    final headers = await _getAuthHeaders();

    late final pb.FindNearbyStopsResponse response;
    try {
      response = await client.findNearbyStops(request, headers: headers);
    } catch (e) {
      if (_isAuthError(e)) {
        debugPrint('[Frontline] Auth error on findNearbyStops, refreshing...');
        try {
          await _authService.forceRefresh();
          final retryHeaders = await _getAuthHeaders();
          response = await client.findNearbyStops(
            request,
            headers: retryHeaders,
          );
        } catch (retryError) {
          throw AppException.from(retryError);
        }
      } else {
        throw AppException.from(e);
      }
    }

    return response.stops.map(_mapNearbyStop).toList();
  }

  // ===========================================================================
  // Get Service Details (Route View)
  // ===========================================================================

  /// Fetches full route details for a bus service.
  ///
  /// [serviceNo] - The bus service number (e.g. "J10")
  /// Returns route polyline, stop sequence, origin/destination.
  Future<ServiceRouteData> getServiceDetails(String serviceNo) async {
    final client = _getClient();
    final request = pb.GetServiceDetailsRequest()..serviceNo = serviceNo;
    final headers = await _getAuthHeaders();

    late final pb.GetServiceDetailsResponse response;
    try {
      response = await client.getServiceDetails(request, headers: headers);
    } catch (e) {
      if (_isAuthError(e)) {
        debugPrint(
          '[Frontline] Auth error on getServiceDetails, refreshing...',
        );
        try {
          await _authService.forceRefresh();
          final retryHeaders = await _getAuthHeaders();
          response = await client.getServiceDetails(
            request,
            headers: retryHeaders,
          );
        } catch (retryError) {
          throw AppException.from(retryError);
        }
      } else {
        throw AppException.from(e);
      }
    }

    return _mapServiceRouteData(response);
  }

  // ===========================================================================
  // Get Services At Stop
  // ===========================================================================

  /// Fetches all bus services available at a stop.
  ///
  /// Returns a complete service directory regardless of current arrivals.
  /// [busStopCode] - The unique code identifying the bus stop
  Future<List<ServiceSummary>> getServicesAtStop(String busStopCode) async {
    final client = _getClient();
    final request = pb.GetServicesAtStopRequest()..busStopCode = busStopCode;
    final headers = await _getAuthHeaders();

    late final pb.GetServicesAtStopResponse response;
    try {
      response = await client.getServicesAtStop(request, headers: headers);
    } catch (e) {
      if (_isAuthError(e)) {
        debugPrint(
          '[Frontline] Auth error on getServicesAtStop, refreshing...',
        );
        try {
          await _authService.forceRefresh();
          final retryHeaders = await _getAuthHeaders();
          response = await client.getServicesAtStop(
            request,
            headers: retryHeaders,
          );
        } catch (retryError) {
          throw AppException.from(retryError);
        }
      } else {
        throw AppException.from(e);
      }
    }

    return response.services.map(_mapServiceSummary).toList();
  }

  // ===========================================================================
  // Private: Mapping
  // ===========================================================================

  /// Maps protobuf ServiceAtStop to domain model.
  ServiceSummary _mapServiceSummary(pb.ServiceAtStop proto) {
    final info = proto.service;
    return ServiceSummary(
      serviceNo: info.serviceNo,
      color: info.color.isEmpty ? '#666666' : info.color,
      destination: proto.destination,
      isFree: info.isFree,
    );
  }

  /// Maps protobuf GetServiceDetailsResponse to domain model.
  ServiceRouteData _mapServiceRouteData(pb.GetServiceDetailsResponse proto) {
    final service = proto.service;
    return ServiceRouteData(
      serviceNo: service.serviceNo,
      color: service.color.isEmpty ? '#666666' : service.color,
      origin: proto.origin,
      destination: proto.destination,
      encodedPolyline: proto.polyline,
      stops: proto.stops.map(_mapStopOnRoute).toList(),
    );
  }

  /// Maps protobuf ServiceStopInfo to domain model.
  StopOnRoute _mapStopOnRoute(pb.ServiceStopInfo proto) {
    final hasLocation = proto.hasLocation();
    return StopOnRoute(
      busStopCode: proto.busStopCode,
      busStopName: proto.name,
      latitude: hasLocation ? proto.location.latitude : 0,
      longitude: hasLocation ? proto.location.longitude : 0,
      sequenceNo: proto.sequence,
    );
  }

  /// Maps protobuf NearbyStopResult to domain model.
  NearbyStop _mapNearbyStop(pb.NearbyStopResult proto) {
    final hasLocation = proto.busStop.hasLocation();
    return NearbyStop(
      busStopCode: proto.busStop.code,
      busStopName: proto.busStop.name,
      latitude: hasLocation ? proto.busStop.location.latitude : 0,
      longitude: hasLocation ? proto.busStop.location.longitude : 0,
      distanceMeters: proto.distanceMeters,
      serviceNos: proto.serviceNos.toList(),
      nextArrival: proto.hasNextArrival()
          ? _mapArrivalTime(proto.nextArrival)
          : null,
    );
  }

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
  ///
  /// Builds an ordered [arrivals] list from proto fields, filtering nulls.
  /// When the proto expands to N arrivals, only this mapper changes.
  BusArrivalInfo _mapBusArrival(pb.BusArrival proto) {
    final nextArr = proto.hasNextArrival()
        ? _mapArrivalTime(proto.nextArrival)
        : null;
    final laterArr = proto.hasLaterArrival()
        ? _mapArrivalTime(proto.laterArrival)
        : null;

    return BusArrivalInfo(
      serviceNo: proto.serviceNo.split('~')[0],
      direction: proto.direction,
      color: proto.color.isEmpty ? '#666666' : proto.color,
      isFree: proto.isFree,
      destination: proto.destination,
      arrivals: [?nextArr, ?laterArr],
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

  /// Check if an error is an authentication/authorization error.
  ///
  /// Uses the same classification as [AppException.from] for consistency.
  bool _isAuthError(Object error) {
    return AppException.from(error) is AuthException;
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

// =============================================================================
// Delta Merge (top-level for testability)
// =============================================================================

/// Applies a delta update to existing [StopArrivalsData].
///
/// Exposed as a top-level function for direct unit testing.
///
/// - [updatedArrivals]: Services to add or replace (matched by serviceNo).
/// - [removedServiceNos]: Service numbers to remove from the list.
/// - [busLocations]: If non-null and non-empty, replaces current locations.
///   If null or empty, preserves previous locations.
/// - [updatedAt]: Timestamp from the delta. If non-null, replaces current.
StopArrivalsData applyArrivalsDelta({
  required StopArrivalsData current,
  required List<BusArrivalInfo> updatedArrivals,
  required List<String> removedServiceNos,
  List<BusLocationInfo>? busLocations,
  DateTime? updatedAt,
}) {
  // Build map from current buses for O(1) lookup by serviceNo
  final busMap = <String, BusArrivalInfo>{
    for (final bus in current.buses) bus.serviceNo: bus,
  };

  // Remove services listed in the delta
  for (final serviceNo in removedServiceNos) {
    busMap.remove(serviceNo);
  }

  // Upsert updated arrivals (adds new services, replaces existing)
  for (final arrival in updatedArrivals) {
    busMap[arrival.serviceNo] = arrival;
  }

  return StopArrivalsData(
    busStopCode: current.busStopCode,
    busStopName: current.busStopName,
    buses: busMap.values.toList(),
    busLocations: (busLocations != null && busLocations.isNotEmpty)
        ? busLocations
        : current.busLocations,
    updatedAt: updatedAt ?? current.updatedAt,
  );
}
