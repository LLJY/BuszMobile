/// Providers for the stop detail feature.
///
/// Fetches stop arrivals in streaming or polling mode based on user settings.
/// Both modes include automatic retry with exponential backoff for transient
/// connection errors (e.g. HTTP/2 forceful termination).
///
/// All providers are autoDispose to stop the stream/polling when the screen
/// is left.
library;

import 'dart:async';
import 'dart:math' show min;

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/local/settings_providers.dart';
import '../../../data/local/settings_store.dart';
import '../../../data/models/models.dart';
import '../../search/providers/search_providers.dart';

part 'stop_detail_providers.g.dart';

// =============================================================================
// Constants
// =============================================================================

/// Maximum backoff between retries.
const _maxBackoff = Duration(seconds: 30);

/// Maximum consecutive retries before surfacing the error.
const _maxRetries = 5;

/// Delay before reconnecting after a clean stream end (server closed normally).
const _cleanEndDelay = Duration(seconds: 2);

/// Maximum consecutive clean-end reconnects before falling back to polling.
/// Prevents tight reconnect loops if the server keeps closing immediately.
const _maxCleanEnds = 10;

// =============================================================================
// Stop Arrivals Provider
// =============================================================================

/// Streams stop arrivals based on the current [AppSettings.dataMode].
///
/// - **Streaming**: Uses server-streaming RPC with auto-retry on connection
///   errors. Falls back to polling if retries are exhausted.
/// - **Polling**: Periodic unary RPC at the configured interval.
///
/// Auto-disposes when the stop detail screen is left.
@riverpod
Stream<StopArrivalsData> stopArrivals(Ref ref, String busStopCode) async* {
  final settings = ref.watch(appSettingsProvider);
  final service = ref.watch(frontlineServiceProvider);

  final pollInterval = Duration(seconds: settings.pollingIntervalSeconds);

  if (settings.dataMode == DataMode.streaming) {
    yield* _streamWithRetry(
      stream: () =>
          service.streamStopArrivals(busStopCode, includeBusLocations: true),
      fallbackFetch: () =>
          service.getStopArrivals(busStopCode, includeBusLocations: true),
      fallbackInterval: pollInterval,
    );
  } else {
    yield* _pollingWithRetry(
      interval: pollInterval,
      fetch: () =>
          service.getStopArrivals(busStopCode, includeBusLocations: true),
    );
  }
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
// Private: Streaming with Retry
// =============================================================================

/// Streams data with automatic reconnection on transient errors.
///
/// On error the stream waits with exponential backoff (1s → 2s → 4s → ...
/// capped at [_maxBackoff]), then retries. After [_maxRetries] consecutive
/// failures the stream falls back to polling.
///
/// Successful data resets the retry counter.
Stream<T> _streamWithRetry<T>({
  required Stream<T> Function() stream,
  required Future<T> Function() fallbackFetch,
  required Duration fallbackInterval,
}) async* {
  var retries = 0;
  var cleanEnds = 0;

  while (retries < _maxRetries && cleanEnds < _maxCleanEnds) {
    try {
      await for (final data in stream()) {
        retries = 0; // Reset on success
        cleanEnds = 0;
        yield data;
      }
      // Stream ended cleanly (server closed) — wait before reconnecting.
      cleanEnds++;
      debugPrint(
        '[StopArrivals] Stream ended cleanly ($cleanEnds/$_maxCleanEnds), '
        'reconnecting in ${_cleanEndDelay.inSeconds}s...',
      );
      await Future<void>.delayed(_cleanEndDelay);
    } catch (e) {
      retries++;
      final backoff = _exponentialBackoff(retries);
      debugPrint(
        '[StopArrivals] Stream error (attempt $retries/$_maxRetries), '
        'retrying in ${backoff.inSeconds}s: $e',
      );
      await Future<void>.delayed(backoff);
    }
  }

  // Retries exhausted — fall back to polling
  debugPrint('[StopArrivals] Retries exhausted, falling back to polling');
  yield* _pollingWithRetry(interval: fallbackInterval, fetch: fallbackFetch);
}

// =============================================================================
// Private: Polling with Retry
// =============================================================================

/// Polls [fetch] at [interval], retrying transient errors with backoff.
///
/// The first fetch is attempted immediately. On error the poll backs off
/// (capped at [_maxBackoff]) then resumes the normal interval on success.
/// Subsequent fetch errors do NOT terminate the stream — the last
/// successful value stays visible to the UI.
Stream<T> _pollingWithRetry<T>({
  required Duration interval,
  required Future<T> Function() fetch,
}) async* {
  var consecutiveErrors = 0;

  // Initial fetch with retry
  while (true) {
    try {
      yield await fetch();
      consecutiveErrors = 0;
      break;
    } catch (e) {
      consecutiveErrors++;
      if (consecutiveErrors >= _maxRetries) {
        debugPrint(
          '[Polling] Initial fetch failed after $_maxRetries attempts',
        );
        rethrow; // Surface to UI as error state
      }
      final backoff = _exponentialBackoff(consecutiveErrors);
      debugPrint(
        '[Polling] Initial fetch error (attempt $consecutiveErrors), '
        'retrying in ${backoff.inSeconds}s: $e',
      );
      await Future<void>.delayed(backoff);
    }
  }

  // Steady-state polling
  while (true) {
    await Future<void>.delayed(interval);

    try {
      yield await fetch();
      consecutiveErrors = 0;
    } catch (e) {
      consecutiveErrors++;
      final backoff = _exponentialBackoff(consecutiveErrors);
      debugPrint(
        '[Polling] Fetch error ($consecutiveErrors consecutive), '
        'next retry in ${backoff.inSeconds}s: $e',
      );
      // Don't rethrow — keep polling. Previous value stays visible.
      // Use backoff instead of normal interval for next attempt.
      await Future<void>.delayed(backoff - interval);
    }
  }
}

// =============================================================================
// Private: Backoff
// =============================================================================

/// Exponential backoff: 1s, 2s, 4s, 8s, 16s, capped at [_maxBackoff].
Duration _exponentialBackoff(int attempt) {
  final seconds = min(1 << (attempt - 1), _maxBackoff.inSeconds);
  return Duration(seconds: seconds);
}
