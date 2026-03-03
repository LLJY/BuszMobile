/// Tests for the stop detail providers (codegen migration).
///
/// Verifies:
/// - filteredBusLocationsProvider returns empty when no service selected
/// - filteredBusLocationsProvider filters by the selected service correctly
/// - stopArrivalsProvider emits data from the service
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busz_mobile/data/models/models.dart';
import 'package:busz_mobile/data/services/frontline_service.dart';
import 'package:busz_mobile/features/search/providers/search_providers.dart';
import 'package:busz_mobile/features/stop_detail/providers/stop_detail_providers.dart';

// =============================================================================
// Manual Mock
// =============================================================================

class MockFrontlineService implements FrontlineService {
  StopArrivalsData? arrivalsData;
  int arrivalsCallCount = 0;
  int streamCallCount = 0;

  @override
  Future<List<BusStopSearchResult>> searchBusStops(
    String query, {
    int limit = 20,
  }) async {
    throw UnimplementedError('Not used in stop detail tests');
  }

  @override
  Future<StopArrivalsData> getStopArrivals(
    String busStopCode, {
    bool includeBusLocations = true,
  }) async {
    arrivalsCallCount++;
    return arrivalsData!;
  }

  @override
  Stream<StopArrivalsData> streamStopArrivals(
    String busStopCode, {
    bool includeBusLocations = true,
  }) async* {
    streamCallCount++;
    yield arrivalsData!;
  }

  @override
  Future<List<NearbyStop>> findNearbyStops(
    double lat,
    double lng, {
    double radiusMeters = 500,
    int limit = 10,
  }) async {
    throw UnimplementedError('Not used in stop detail tests');
  }

  @override
  Future<ServiceRouteData> getServiceDetails(String serviceNo) async {
    throw UnimplementedError('Not used in stop detail tests');
  }

  @override
  Future<List<ServiceSummary>> getServicesAtStop(String busStopCode) async {
    throw UnimplementedError('Not used in stop detail tests');
  }

  @override
  void dispose() {}
}

// =============================================================================
// Test Data
// =============================================================================

const _testData = StopArrivalsData(
  busStopCode: '12345',
  busStopName: 'Test Stop',
  buses: [
    BusArrivalInfo(
      serviceNo: '100',
      direction: 1,
      color: '#FF0000',
      isFree: false,
      destination: 'Terminal A',
      plateNo: 'ABC1234',
      laterPlateNo: '',
      isDeparting: false,
      etaSource: 'ETA_SOURCE_REALTIME',
      delayStatus: 'DELAY_STATUS_ON_TIME',
      delayMinutes: 0,
    ),
  ],
  busLocations: [
    BusLocationInfo(
      plateNo: 'ABC1234',
      serviceNo: '100',
      direction: 1,
      latitude: 1.4927,
      longitude: 103.7414,
      speedKmh: 30.0,
      heading: 90.0,
      nextStopCode: '12346',
      nextStopName: 'Next Stop',
      etaToNextStopMinutes: 5,
    ),
    BusLocationInfo(
      plateNo: 'DEF5678',
      serviceNo: '200',
      direction: 1,
      latitude: 1.5000,
      longitude: 103.7500,
      speedKmh: 40.0,
      heading: 180.0,
      nextStopCode: '12347',
      nextStopName: 'Another Stop',
      etaToNextStopMinutes: 3,
    ),
    BusLocationInfo(
      plateNo: 'GHI9012',
      serviceNo: '100',
      direction: 2,
      latitude: 1.4800,
      longitude: 103.7300,
      speedKmh: 25.0,
      heading: 270.0,
      nextStopCode: '12348',
      nextStopName: 'Third Stop',
      etaToNextStopMinutes: 8,
    ),
  ],
);

// =============================================================================
// Tests
// =============================================================================

void main() {
  late MockFrontlineService mockService;
  late ProviderContainer container;

  setUp(() {
    mockService = MockFrontlineService();
    mockService.arrivalsData = _testData;
    container = ProviderContainer(
      overrides: [frontlineServiceProvider.overrideWithValue(mockService)],
    );
    addTearDown(container.dispose);
  });

  group('filteredBusLocationsProvider', () {
    test('returns empty list when no service is selected', () async {
      // Subscribe to activate the stream provider (it must have data first)
      container.listen(stopArrivalsProvider('12345'), (_, _) {});
      container.listen(filteredBusLocationsProvider('12345'), (_, _) {});

      // Wait for the stream provider to emit initial data
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // selectedService defaults to null → should return empty
      final result = container.read(filteredBusLocationsProvider('12345'));
      expect(
        result,
        isEmpty,
        reason: 'Should return empty when no service is selected',
      );
    });

    test('filters bus locations by the selected service', () async {
      // Subscribe to activate providers
      container.listen(stopArrivalsProvider('12345'), (_, _) {});
      container.listen(filteredBusLocationsProvider('12345'), (_, _) {});

      // Wait for the stream provider to emit initial data
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Select service '100' — should filter to 2 locations (ABC1234, GHI9012)
      container.read(selectedServiceProvider.notifier).select('100');

      // Allow reactivity to propagate
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final result = container.read(filteredBusLocationsProvider('12345'));
      expect(
        result,
        hasLength(2),
        reason: 'Should return 2 locations for service 100',
      );
      expect(
        result.every((loc) => loc.serviceNo == '100'),
        isTrue,
        reason: 'All returned locations should be for service 100',
      );
      expect(
        result.map((loc) => loc.plateNo).toList(),
        containsAll(['ABC1234', 'GHI9012']),
      );
    });

    test('filters to different service correctly', () async {
      // Subscribe to activate providers
      container.listen(stopArrivalsProvider('12345'), (_, _) {});
      container.listen(filteredBusLocationsProvider('12345'), (_, _) {});

      // Wait for the stream provider to emit initial data
      await Future<void>.delayed(const Duration(milliseconds: 200));

      // Select service '200' — should filter to 1 location (DEF5678)
      container.read(selectedServiceProvider.notifier).select('200');

      await Future<void>.delayed(const Duration(milliseconds: 50));

      final result = container.read(filteredBusLocationsProvider('12345'));
      expect(
        result,
        hasLength(1),
        reason: 'Should return 1 location for service 200',
      );
      expect(result.first.plateNo, 'DEF5678');
      expect(result.first.serviceNo, '200');
    });
  });

  group('stopArrivalsProvider', () {
    test('emits data from the frontline service', () async {
      // Subscribe to the stream provider
      container.listen(stopArrivalsProvider('12345'), (_, _) {});

      // Wait for initial fetch
      await Future<void>.delayed(const Duration(milliseconds: 200));

      final result = container.read(stopArrivalsProvider('12345'));
      expect(
        result.value,
        isNotNull,
        reason: 'Provider should have emitted data',
      );
      expect(result.value!.busStopCode, '12345');
      expect(result.value!.busStopName, 'Test Stop');
      expect(result.value!.busLocations, hasLength(3));
      expect(result.value!.buses, hasLength(1));
      expect(
        mockService.streamCallCount,
        greaterThanOrEqualTo(1),
        reason: 'Stream should have been called at least once',
      );
    });
  });

  group('selectedServiceProvider', () {
    test('defaults to null', () {
      container.listen(selectedServiceProvider, (_, _) {});
      final result = container.read(selectedServiceProvider);
      expect(result, isNull);
    });

    test('can be updated via notifier', () {
      container.listen(selectedServiceProvider, (_, _) {});
      container.read(selectedServiceProvider.notifier).select('J10');
      expect(container.read(selectedServiceProvider), 'J10');

      container.read(selectedServiceProvider.notifier).select(null);
      expect(container.read(selectedServiceProvider), isNull);
    });
  });
}
