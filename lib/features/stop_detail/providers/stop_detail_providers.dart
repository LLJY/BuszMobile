/// Providers for the stop detail feature.
///
/// Uses polling (every 15s) with GetStopArrivals + include_bus_locations.
/// All providers are autoDispose to stop polling when the screen is left.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../data/models/models.dart';
import '../../search/providers/search_providers.dart';

// =============================================================================
// Stop Arrivals Provider (polling every 15s)
// =============================================================================

/// Polls stop arrivals with bus locations every 15 seconds.
///
/// Auto-disposes when the stop detail screen is left, stopping the polling
/// loop and freeing network/battery resources.
final stopArrivalsProvider = StreamProvider.autoDispose
    .family<StopArrivalsData, String>((ref, busStopCode) {
      final service = ref.watch(frontlineServiceProvider);

      return _pollingStream(
        interval: const Duration(seconds: 15),
        fetch: () =>
            service.getStopArrivals(busStopCode, includeBusLocations: true),
      );
    });

/// The currently selected service number filter on the stop detail screen.
/// null = show all services (no map, full list).
/// Auto-disposes when no longer watched (resets on screen re-entry).
final selectedServiceProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);

/// Filtered bus locations for the selected service.
///
/// When a service is selected, returns only bus locations matching that
/// service. When null, returns empty (map not shown).
final filteredBusLocationsProvider = Provider.autoDispose
    .family<List<BusLocationInfo>, String>((ref, busStopCode) {
      final selectedService = ref.watch(selectedServiceProvider);
      if (selectedService == null) return [];

      final arrivalsAsync = ref.watch(stopArrivalsProvider(busStopCode));
      return arrivalsAsync.when(
        data: (data) => data.busLocations
            .where((loc) => loc.serviceNo == selectedService)
            .toList(),
        loading: () => [],
        error: (_, st) => [],
      );
    });

// =============================================================================
// Private: Polling Helper
// =============================================================================

/// Creates a stream that polls [fetch] at [interval], yielding each result.
///
/// Both initial and subsequent fetch errors are yielded as stream errors
/// but do not terminate the stream - polling continues regardless.
Stream<T> _pollingStream<T>({
  required Duration interval,
  required Future<T> Function() fetch,
}) async* {
  // Fetch immediately on first subscribe
  yield await fetch();

  // Then poll at interval
  while (true) {
    await Future.delayed(interval);

    try {
      yield await fetch();
    } catch (e) {
      debugPrint('[Polling] Fetch error: $e');
      // Don't rethrow on subsequent errors - keep polling.
      // The previous value stays visible to the UI.
    }
  }
}
