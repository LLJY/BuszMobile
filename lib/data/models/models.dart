/// Domain models for BuszMobile.
///
/// Lightweight models mapped from protobuf types by FrontlineService.
library;

// =============================================================================
// Bus Stop Search Result
// =============================================================================

/// Result from a bus stop search query.
class BusStopSearchResult {
  final String busStopCode;
  final String busStopName;
  final List<String> serviceNos;
  final double relevanceScore;
  final double? latitude;
  final double? longitude;

  const BusStopSearchResult({
    required this.busStopCode,
    required this.busStopName,
    required this.serviceNos,
    required this.relevanceScore,
    this.latitude,
    this.longitude,
  });

  @override
  String toString() => 'BusStopSearchResult($busStopCode: $busStopName)';
}

// =============================================================================
// Stop Arrivals Data
// =============================================================================

/// Full arrival data for a bus stop, including optional bus GPS positions.
class StopArrivalsData {
  final String busStopCode;
  final String busStopName;
  final List<BusArrivalInfo> buses;
  final List<BusLocationInfo> busLocations;
  final DateTime? updatedAt;

  const StopArrivalsData({
    required this.busStopCode,
    required this.busStopName,
    required this.buses,
    required this.busLocations,
    this.updatedAt,
  });

  @override
  String toString() =>
      'StopArrivalsData($busStopCode, ${buses.length} buses, '
      '${busLocations.length} locations)';
}

// =============================================================================
// Bus Arrival Info
// =============================================================================

/// A single bus service arrival at a stop.
///
/// Contains an ordered [arrivals] list for N upcoming buses.
/// Convenience getters [nextArrival] and [laterArrival] provide
/// backward compatibility with the original two-arrival model.
class BusArrivalInfo {
  final String serviceNo;
  final int direction;
  final String color;
  final bool isFree;
  final String destination;
  final List<ArrivalTime> arrivals;
  final String plateNo;
  final String laterPlateNo;
  final bool isDeparting;
  final String etaSource;
  final String delayStatus;
  final int delayMinutes;

  const BusArrivalInfo({
    required this.serviceNo,
    required this.direction,
    required this.color,
    required this.isFree,
    required this.destination,
    this.arrivals = const [],
    required this.plateNo,
    required this.laterPlateNo,
    required this.isDeparting,
    required this.etaSource,
    required this.delayStatus,
    required this.delayMinutes,
  });

  /// First upcoming arrival (convenience getter, backward compatible).
  ArrivalTime? get nextArrival => arrivals.isNotEmpty ? arrivals[0] : null;

  /// Second upcoming arrival (convenience getter, backward compatible).
  ArrivalTime? get laterArrival => arrivals.length > 1 ? arrivals[1] : null;

  /// Minutes until next arrival from now.
  int? get nextArrivalMinutes {
    if (nextArrival == null) return null;
    return nextArrival!.time.difference(DateTime.now()).inMinutes;
  }

  /// Minutes until later arrival from now.
  int? get laterArrivalMinutes {
    if (laterArrival == null) return null;
    return laterArrival!.time.difference(DateTime.now()).inMinutes;
  }

  @override
  String toString() => 'BusArrivalInfo($serviceNo -> $destination)';
}

// =============================================================================
// Arrival Time
// =============================================================================

/// An arrival time with live/scheduled indicator.
class ArrivalTime {
  final DateTime time;
  final bool isLive;

  const ArrivalTime({required this.time, required this.isLive});

  @override
  String toString() => 'ArrivalTime($time, live=$isLive)';
}

// =============================================================================
// Nearby Stop
// =============================================================================

/// A bus stop near the user's current GPS location.
///
/// Returned by [FrontlineService.findNearbyStops], sorted by distance.
class NearbyStop {
  /// The unique bus stop code identifier.
  final String busStopCode;

  /// The display name of the bus stop.
  final String busStopName;

  /// Latitude of the bus stop.
  final double latitude;

  /// Longitude of the bus stop.
  final double longitude;

  /// Distance from the user's location in metres.
  final double distanceMeters;

  /// Bus service numbers that serve this stop.
  final List<String> serviceNos;

  /// The next arrival at this stop, if available.
  final ArrivalTime? nextArrival;

  const NearbyStop({
    required this.busStopCode,
    required this.busStopName,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    required this.serviceNos,
    this.nextArrival,
  });

  @override
  String toString() =>
      'NearbyStop($busStopCode: $busStopName, ${distanceMeters.round()}m)';
}

// =============================================================================
// Service Route Data
// =============================================================================

/// Full route details for a bus service, including polyline and stop sequence.
///
/// Mapped from [GetServiceDetailsResponse] by [FrontlineService].
class ServiceRouteData {
  /// The bus service number (e.g. "J10").
  final String serviceNo;

  /// Hex colour string for the service (e.g. "#FF6600").
  final String color;

  /// Name of the origin stop.
  final String origin;

  /// Name of the destination stop.
  final String destination;

  /// Google-encoded polyline string for the route shape.
  final String encodedPolyline;

  /// Ordered list of stops along this route direction.
  final List<StopOnRoute> stops;

  const ServiceRouteData({
    required this.serviceNo,
    required this.color,
    required this.origin,
    required this.destination,
    required this.encodedPolyline,
    required this.stops,
  });

  @override
  String toString() =>
      'ServiceRouteData($serviceNo, $origin → $destination, '
      '${stops.length} stops)';
}

// =============================================================================
// Stop On Route
// =============================================================================

/// A single stop along a bus route, with sequence ordering.
class StopOnRoute {
  final String busStopCode;
  final String busStopName;
  final double latitude;
  final double longitude;
  final int sequenceNo;

  const StopOnRoute({
    required this.busStopCode,
    required this.busStopName,
    required this.latitude,
    required this.longitude,
    required this.sequenceNo,
  });

  @override
  String toString() =>
      'StopOnRoute($busStopCode: $busStopName, seq=$sequenceNo)';
}

// =============================================================================
// Service Summary
// =============================================================================

/// Summary of a bus service available at a stop.
///
/// Returned by [FrontlineService.getServicesAtStop], providing a complete
/// directory of all services regardless of current arrivals.
class ServiceSummary {
  /// The bus service number (e.g., "10", "77A").
  final String serviceNo;

  /// Hex color code for the service (e.g., "#FF5722").
  final String color;

  /// The destination name for this service at this stop.
  final String destination;

  /// Whether this is a free (no-fare) service.
  final bool isFree;

  const ServiceSummary({
    required this.serviceNo,
    required this.color,
    required this.destination,
    required this.isFree,
  });

  @override
  String toString() => 'ServiceSummary($serviceNo -> $destination)';
}

// =============================================================================
// Bus Location Info
// =============================================================================

/// Live GPS position of a bus.
class BusLocationInfo {
  final String plateNo;
  final String serviceNo;
  final int direction;
  final double latitude;
  final double longitude;
  final double speedKmh;
  final double heading;
  final DateTime? timestamp;
  final String nextStopCode;
  final String nextStopName;
  final int etaToNextStopMinutes;

  const BusLocationInfo({
    required this.plateNo,
    required this.serviceNo,
    required this.direction,
    required this.latitude,
    required this.longitude,
    required this.speedKmh,
    required this.heading,
    this.timestamp,
    required this.nextStopCode,
    required this.nextStopName,
    required this.etaToNextStopMinutes,
  });

  @override
  String toString() =>
      'BusLocationInfo($plateNo, $serviceNo, '
      '($latitude, $longitude))';
}
