/// Providers for the bus stop search feature.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

import '../../../data/models/models.dart';
import '../../../data/services/frontline_service.dart';

// =============================================================================
// Service Provider
// =============================================================================

/// Singleton FrontlineService instance shared across the app.
final frontlineServiceProvider = Provider<FrontlineService>((ref) {
  final service = FrontlineService();
  ref.onDispose(service.dispose);
  return service;
});

// =============================================================================
// Search Providers
// =============================================================================

/// The current search query text.
final searchQueryProvider = StateProvider<String>((ref) => '');

/// Debounced search results.
///
/// Watches [searchQueryProvider] and fetches results with a 300ms debounce.
/// Auto-disposes when no longer listened to (e.g., screen navigated away).
final searchResultsProvider =
    FutureProvider.autoDispose<List<BusStopSearchResult>>((ref) async {
      final query = ref.watch(searchQueryProvider);

      if (query.trim().length < 2) return [];

      // Debounce: cancel if query changes within 300ms
      final completer = Completer<void>();
      final timer = Timer(const Duration(milliseconds: 300), () {
        if (!completer.isCompleted) completer.complete();
      });
      ref.onDispose(timer.cancel);

      // Wait for debounce or cancellation
      await completer.future;

      // Check if still the current query after debounce
      if (ref.read(searchQueryProvider) != query) return [];

      try {
        final service = ref.read(frontlineServiceProvider);
        return await service.searchBusStops(query, limit: 20);
      } catch (e) {
        debugPrint('[Search] Error: $e');
        rethrow;
      }
    });
