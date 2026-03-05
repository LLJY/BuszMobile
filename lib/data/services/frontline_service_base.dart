/// Shared interface for frontline data services.
library;

import '../models/models.dart';

abstract class FrontlineServiceBase {
  Future<List<BusStopSearchResult>> searchBusStops(
    String query, {
    int limit = 20,
  });

  Future<StopArrivalsData> getStopArrivals(
    String busStopCode, {
    bool includeBusLocations = true,
  });

  Stream<StopArrivalsData> streamStopArrivals(
    String busStopCode, {
    bool includeBusLocations = true,
  });

  Future<List<NearbyStop>> findNearbyStops(
    double lat,
    double lng, {
    double radiusMeters = 500,
    int limit = 10,
  });

  Future<ServiceRouteData> getServiceDetails(
    String serviceNo, {
    int direction = 1,
  });

  Future<List<ServiceSummary>> getServicesAtStop(String busStopCode);

  void dispose();
}
