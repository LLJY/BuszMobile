/// Providers for the bus stop search feature.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/models/models.dart';
import '../../../data/services/frontline_service.dart';

part 'search_providers.g.dart';

// =============================================================================
// Service Provider
// =============================================================================

/// Singleton FrontlineService instance shared across the app.
@Riverpod(keepAlive: true)
FrontlineService frontlineService(Ref ref) {
  final service = FrontlineService();
  ref.onDispose(service.dispose);
  return service;
}

// =============================================================================
// Search Providers
// =============================================================================

/// The current search query text.
@riverpod
class SearchQuery extends _$SearchQuery {
  @override
  String build() => '';

  /// Update the search query.
  void update(String query) {
    state = query;
  }
}

/// Debounced search results.
///
/// Watches [searchQueryProvider] and fetches results with a 300ms debounce.
/// Auto-disposes when no longer listened to (e.g., screen navigated away).
@riverpod
Future<List<BusStopSearchResult>> searchResults(Ref ref) async {
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
}
