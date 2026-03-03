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
class BusArrivalInfo {
  final String serviceNo;
  final int direction;
  final String color;
  final bool isFree;
  final String destination;
  final ArrivalTime? nextArrival;
  final ArrivalTime? laterArrival;
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
    this.nextArrival,
    this.laterArrival,
    required this.plateNo,
    required this.laterPlateNo,
    required this.isDeparting,
    required this.etaSource,
    required this.delayStatus,
    required this.delayMinutes,
  });

  /// Minutes until next arrival from now.
  int? get nextArrivalMinutes {
    if (nextArrival == null) return null;
    final diff = nextArrival!.time.difference(DateTime.now());
    return diff.inMinutes;
  }

  /// Minutes until later arrival from now.
  int? get laterArrivalMinutes {
    if (laterArrival == null) return null;
    final diff = laterArrival!.time.difference(DateTime.now());
    return diff.inMinutes;
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
