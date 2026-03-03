/// Demo implementation of frontline service methods.
library;

import 'dart:async';
import 'dart:math';

import '../models/models.dart';
import 'frontline_service_base.dart';

// =============================================================================
// Demo Frontline Service
// =============================================================================

class DemoFrontlineService implements FrontlineServiceBase {
  static const List<_DemoStop> _stops = <_DemoStop>[
    _DemoStop(code: 'JB001', name: 'JB Sentral', lat: 1.4639, lng: 103.7647),
    _DemoStop(code: 'JB002', name: 'City Square', lat: 1.4627, lng: 103.7641),
    _DemoStop(code: 'JB003', name: 'Komtar JBCC', lat: 1.4648, lng: 103.7649),
    _DemoStop(code: 'JB004', name: 'KSL City Mall', lat: 1.4850, lng: 103.7746),
    _DemoStop(code: 'JB005', name: 'Danga Bay', lat: 1.4785, lng: 103.7270),
  ];

  static const List<String> _services = <String>[
    'P101',
    'P102',
    'P211',
    'P301',
    'P401',
  ];

  static const List<String> _destinations = <String>[
    'JB Sentral',
    'Larkin Terminal',
    'Masai Terminal',
    'Danga Bay',
    'Bukit Indah',
  ];

  static const List<String> _colors = <String>[
    '#4CAF50',
    '#2196F3',
    '#FF9800',
    '#9C27B0',
    '#F44336',
  ];

  static const Map<String, List<String>> _stopServices = <String, List<String>>{
    'JB001': <String>['P101', 'P102', 'P211'],
    'JB002': <String>['P101', 'P301', 'P401'],
    'JB003': <String>['P102', 'P211', 'P301'],
    'JB004': <String>['P211', 'P301', 'P401'],
    'JB005': <String>['P101', 'P401'],
  };

  static const Map<String, List<String>> _serviceRoutes =
      <String, List<String>>{
        'P101': <String>['JB001', 'JB002', 'JB004'],
        'P102': <String>['JB001', 'JB003', 'JB005'],
        'P211': <String>['JB002', 'JB003', 'JB004'],
        'P301': <String>['JB003', 'JB004', 'JB005'],
        'P401': <String>['JB005', 'JB002', 'JB001'],
      };

  static const String _demoPolyline =
      'm{cAq~qiR?eBB{@@k@Bi@Dk@@Q?QAQCOGQIMEICKr@gAHM';

  @override
  Future<List<BusStopSearchResult>> searchBusStops(
    String query, {
    int limit = 20,
  }) async {
    final normalized = query.trim().toLowerCase();
    final safeLimit = limit < 0 ? 0 : limit;

    final results =
        _stops
            .where((stop) {
              if (normalized.isEmpty) return true;
              final searchable = '${stop.code} ${stop.name}'.toLowerCase();
              return searchable.contains(normalized);
            })
            .map((stop) {
              final stopCode = stop.code.toLowerCase();
              final stopName = stop.name.toLowerCase();

              final relevance = normalized.isEmpty
                  ? 0.5
                  : (stopCode == normalized || stopName == normalized)
                  ? 1.0
                  : (stopCode.startsWith(normalized) ||
                        stopName.startsWith(normalized))
                  ? 0.9
                  : 0.75;

              return BusStopSearchResult(
                busStopCode: stop.code,
                busStopName: stop.name,
                serviceNos: _servicesForStop(stop.code),
                relevanceScore: relevance,
                latitude: stop.lat,
                longitude: stop.lng,
              );
            })
            .toList()
          ..sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));

    if (results.length <= safeLimit) return results;
    return results.sublist(0, safeLimit);
  }

  @override
  Future<StopArrivalsData> getStopArrivals(
    String busStopCode, {
    bool includeBusLocations = true,
  }) async {
    final stop = _stopByCode(busStopCode);
    final serviceNos = _servicesForStop(stop.code);
    final now = DateTime.now();

    return StopArrivalsData(
      busStopCode: stop.code,
      busStopName: stop.name,
      buses: serviceNos
          .map((serviceNo) => _buildBusArrival(serviceNo, now))
          .toList(growable: false),
      busLocations: includeBusLocations
          ? _buildBusLocations(stop, serviceNos, now)
          : const <BusLocationInfo>[],
      updatedAt: now,
    );
  }

  @override
  Stream<StopArrivalsData> streamStopArrivals(
    String busStopCode, {
    bool includeBusLocations = true,
  }) async* {
    yield await getStopArrivals(
      busStopCode,
      includeBusLocations: includeBusLocations,
    );

    while (true) {
      await Future<void>.delayed(const Duration(seconds: 5));
      yield await getStopArrivals(
        busStopCode,
        includeBusLocations: includeBusLocations,
      );
    }
  }

  @override
  Future<List<NearbyStop>> findNearbyStops(
    double lat,
    double lng, {
    double radiusMeters = 500,
    int limit = 10,
  }) async {
    final now = DateTime.now();

    final stops = _stops.map((stop) {
      return NearbyStop(
        busStopCode: stop.code,
        busStopName: stop.name,
        latitude: stop.lat,
        longitude: stop.lng,
        distanceMeters: _distanceMeters(lat, lng, stop.lat, stop.lng),
        serviceNos: _servicesForStop(stop.code),
        nextArrival: ArrivalTime(
          time: now.add(const Duration(minutes: 3)),
          isLive: true,
        ),
      );
    }).toList()..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));

    return stops;
  }

  @override
  Future<ServiceRouteData> getServiceDetails(String serviceNo) async {
    final routeCodes =
        _serviceRoutes[serviceNo] ??
        _stops.map((stop) => stop.code).toList(growable: false);

    final routeStops = routeCodes
        .asMap()
        .entries
        .map((entry) {
          final stop = _stopByCode(entry.value);
          return StopOnRoute(
            busStopCode: stop.code,
            busStopName: stop.name,
            latitude: stop.lat,
            longitude: stop.lng,
            sequenceNo: entry.key + 1,
          );
        })
        .toList(growable: false);

    final origin = routeStops.isNotEmpty
        ? routeStops.first.busStopName
        : 'JB Sentral';

    return ServiceRouteData(
      serviceNo: serviceNo,
      color: _colorForService(serviceNo),
      origin: origin,
      destination: _destinationForService(serviceNo),
      encodedPolyline: _demoPolyline,
      stops: routeStops,
    );
  }

  @override
  Future<List<ServiceSummary>> getServicesAtStop(String busStopCode) async {
    final serviceNos = _servicesForStop(busStopCode);

    return serviceNos
        .map((serviceNo) {
          return ServiceSummary(
            serviceNo: serviceNo,
            color: _colorForService(serviceNo),
            destination: _destinationForService(serviceNo),
            isFree: serviceNo == 'P401',
          );
        })
        .toList(growable: false);
  }

  @override
  void dispose() {}

  BusArrivalInfo _buildBusArrival(String serviceNo, DateTime now) {
    final serviceIndex = _serviceIndex(serviceNo);

    return BusArrivalInfo(
      serviceNo: serviceNo,
      direction: 1,
      color: _colorForService(serviceNo),
      isFree: serviceNo == 'P401',
      destination: _destinationForService(serviceNo),
      arrivals: <ArrivalTime>[
        ArrivalTime(time: now.add(const Duration(minutes: 3)), isLive: true),
        ArrivalTime(time: now.add(const Duration(minutes: 8)), isLive: true),
        ArrivalTime(time: now.add(const Duration(minutes: 15)), isLive: false),
      ],
      plateNo: 'JMB${1000 + serviceIndex}',
      laterPlateNo: 'JMB${2000 + serviceIndex}',
      isDeparting: false,
      etaSource: 'demo',
      delayStatus: 'onTime',
      delayMinutes: 0,
    );
  }

  List<BusLocationInfo> _buildBusLocations(
    _DemoStop stop,
    List<String> serviceNos,
    DateTime now,
  ) {
    return serviceNos
        .asMap()
        .entries
        .map((entry) {
          final index = entry.key;
          final serviceNo = entry.value;
          final offset = (index - 1) * 0.0012;
          final nextStop = _nextStopForService(serviceNo, stop.code);

          return BusLocationInfo(
            plateNo: 'JMB${1000 + _serviceIndex(serviceNo)}',
            serviceNo: serviceNo,
            direction: 1,
            latitude: stop.lat + offset,
            longitude: stop.lng - (offset * 0.8),
            speedKmh: 30 + (index * 4),
            heading: 45 + (index * 25),
            timestamp: now,
            nextStopCode: nextStop.code,
            nextStopName: nextStop.name,
            etaToNextStopMinutes: 3 + index,
          );
        })
        .toList(growable: false);
  }

  _DemoStop _nextStopForService(String serviceNo, String currentStopCode) {
    final route = _serviceRoutes[serviceNo] ?? const <String>['JB001'];
    if (route.isEmpty) return _stops.first;

    final currentIndex = route.indexOf(currentStopCode);
    final nextIndex = (currentIndex >= 0 && currentIndex < route.length - 1)
        ? currentIndex + 1
        : 0;

    return _stopByCode(route[nextIndex]);
  }

  _DemoStop _stopByCode(String code) {
    return _stops.firstWhere(
      (stop) => stop.code == code,
      orElse: () => _stops.first,
    );
  }

  List<String> _servicesForStop(String stopCode) {
    return List<String>.from(_stopServices[stopCode] ?? _services);
  }

  int _serviceIndex(String serviceNo) {
    final index = _services.indexOf(serviceNo);
    return index >= 0 ? index : 0;
  }

  String _destinationForService(String serviceNo) {
    return _destinations[_serviceIndex(serviceNo)];
  }

  String _colorForService(String serviceNo) {
    return _colors[_serviceIndex(serviceNo)];
  }

  double _distanceMeters(double lat1, double lng1, double lat2, double lng2) {
    const earthRadiusMeters = 6371000.0;

    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);
    final lat1Rad = _toRadians(lat1);
    final lat2Rad = _toRadians(lat2);

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(dLng / 2) * sin(dLng / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusMeters * c;
  }

  double _toRadians(double degrees) {
    return degrees * (pi / 180.0);
  }
}

class _DemoStop {
  final String code;
  final String name;
  final double lat;
  final double lng;

  const _DemoStop({
    required this.code,
    required this.name,
    required this.lat,
    required this.lng,
  });
}
