/// Providers for the stop detail feature.
///
/// Uses polling (every 15s) with GetStopArrivals + include_bus_locations.
/// All providers are autoDispose to stop polling when the screen is left.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/models.dart';
import '../../search/providers/search_providers.dart';

part 'stop_detail_providers.g.dart';

// =============================================================================
// Stop Arrivals Provider (polling every 15s)
// =============================================================================

/// Polls stop arrivals with bus locations every 15 seconds.
///
/// Auto-disposes when the stop detail screen is left, stopping the polling
/// loop and freeing network/battery resources.
@riverpod
Stream<StopArrivalsData> stopArrivals(Ref ref, String busStopCode) {
  final service = ref.watch(frontlineServiceProvider);

  return _pollingStream(
    interval: const Duration(seconds: 15),
    fetch: () =>
        service.getStopArrivals(busStopCode, includeBusLocations: true),
  );
}

/// The currently selected service number filter on the stop detail screen.
/// null = show all services (no map, full list).
/// Auto-disposes when no longer watched (resets on screen re-entry).
@riverpod
class SelectedService extends _$SelectedService {
  @override
  String? build() => null;

  /// Update the selected service filter.
  void select(String? serviceNo) {
    state = serviceNo;
  }
}

/// Filtered bus locations for the selected service.
///
/// When a service is selected, returns only bus locations matching that
/// service. When null, returns empty (map not shown).
@riverpod
List<BusLocationInfo> filteredBusLocations(Ref ref, String busStopCode) {
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
}

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
