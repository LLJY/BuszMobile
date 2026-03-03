/// Tests for the search providers (codegen migration).
///
/// Verifies:
/// - Short queries return empty without calling the service
/// - Debounce prevents immediate service calls
/// - Service is called with correct arguments after debounce
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:busz_mobile/data/models/models.dart';
import 'package:busz_mobile/data/services/frontline_service.dart';
import 'package:busz_mobile/features/search/providers/search_providers.dart';

// =============================================================================
// Manual Mock
// =============================================================================

class MockFrontlineService implements FrontlineService {
  List<BusStopSearchResult> searchResults = [];
  String? lastSearchQuery;
  int? lastSearchLimit;
  int searchCallCount = 0;

  @override
  Future<List<BusStopSearchResult>> searchBusStops(
    String query, {
    int limit = 20,
  }) async {
    lastSearchQuery = query;
    lastSearchLimit = limit;
    searchCallCount++;
    return searchResults;
  }

  @override
  Future<StopArrivalsData> getStopArrivals(
    String busStopCode, {
    bool includeBusLocations = true,
  }) async {
    throw UnimplementedError('Not used in search tests');
  }

  @override
  void dispose() {}
}

// =============================================================================
// Tests
// =============================================================================

void main() {
  late MockFrontlineService mockService;
  late ProviderContainer container;

  setUp(() {
    mockService = MockFrontlineService();
    container = ProviderContainer(
      overrides: [frontlineServiceProvider.overrideWithValue(mockService)],
    );
    addTearDown(container.dispose);
  });

  group('searchResultsProvider', () {
    test('returns empty list when query is less than 2 characters', () async {
      // Subscribe to keep the autoDispose provider alive
      container.listen(searchResultsProvider, (_, _) {});

      // Set query to a single character
      container.read(searchQueryProvider.notifier).update('a');

      // Wait for the provider to settle (returns immediately for short queries)
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final result = container.read(searchResultsProvider);
      expect(result.value, isEmpty);
      expect(
        mockService.searchCallCount,
        0,
        reason: 'Service should NOT be called for queries < 2 chars',
      );
    });

    test('returns empty list when query is empty', () async {
      container.listen(searchResultsProvider, (_, _) {});

      // Query defaults to '' (empty), so provider should resolve to []
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final result = container.read(searchResultsProvider);
      expect(result.value, isEmpty);
      expect(mockService.searchCallCount, 0);
    });

    test('debounces - does not fire service call immediately', () async {
      mockService.searchResults = [
        const BusStopSearchResult(
          busStopCode: '12345',
          busStopName: 'Test Stop',
          serviceNos: ['100'],
          relevanceScore: 1.0,
        ),
      ];

      // Subscribe to keep the autoDispose provider alive
      container.listen(searchResultsProvider, (_, _) {});

      // Set a valid query (>= 2 chars)
      container.read(searchQueryProvider.notifier).update('test');

      // Immediately after: service should NOT have been called (debounce)
      expect(
        mockService.searchCallCount,
        0,
        reason: 'Service should not be called before debounce period',
      );

      // Wait less than the 300ms debounce period
      await Future<void>.delayed(const Duration(milliseconds: 150));

      expect(
        mockService.searchCallCount,
        0,
        reason: 'Service should still not be called mid-debounce',
      );
    });

    test(
      'calls frontlineService.searchBusStops with correct args after debounce',
      () async {
        mockService.searchResults = [
          const BusStopSearchResult(
            busStopCode: '67890',
            busStopName: 'Bukit Indah',
            serviceNos: ['J10', 'J11'],
            relevanceScore: 0.95,
          ),
        ];

        // Subscribe to keep the autoDispose provider alive
        container.listen(searchResultsProvider, (_, _) {});

        // Set query
        container.read(searchQueryProvider.notifier).update('bukit');

        // Wait past the 300ms debounce + some margin
        await Future<void>.delayed(const Duration(milliseconds: 450));

        expect(
          mockService.searchCallCount,
          1,
          reason: 'Service should be called exactly once after debounce',
        );
        expect(mockService.lastSearchQuery, 'bukit');
        expect(mockService.lastSearchLimit, 20);

        // Verify the provider has the result
        final result = container.read(searchResultsProvider);
        expect(result.value, hasLength(1));
        expect(result.value!.first.busStopCode, '67890');
      },
    );
  });
}
