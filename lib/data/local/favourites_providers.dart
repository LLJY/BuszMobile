/// Riverpod providers for the favourites data layer.
library;

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/favourite.dart';
import 'favourites_store.dart';

part 'favourites_providers.g.dart';

// =============================================================================
// Store Provider
// =============================================================================

/// Singleton [FavouritesStore] instance for local persistence.
@Riverpod(keepAlive: true)
FavouritesStore favouritesStore(Ref ref) => FavouritesStore();

// =============================================================================
// Favourites Notifier
// =============================================================================

/// Async notifier that manages the user's favourite bus stops.
///
/// Provides CRUD operations and reordering, backed by [FavouritesStore].
@riverpod
class Favourites extends _$Favourites {
  @override
  Future<List<FavouriteStop>> build() async {
    final store = ref.watch(favouritesStoreProvider);
    return store.getAll();
  }

  /// Adds a bus stop to favourites.
  Future<void> add(FavouriteStop stop) async {
    final store = ref.read(favouritesStoreProvider);
    await store.add(stop);
    ref.invalidateSelf();
    await future;
  }

  /// Removes a bus stop from favourites by its code.
  Future<void> remove(String busStopCode) async {
    final store = ref.read(favouritesStoreProvider);
    await store.remove(busStopCode);
    ref.invalidateSelf();
    await future;
  }

  /// Reorders favourites to match the given [busStopCodes] order.
  Future<void> reorder(List<String> busStopCodes) async {
    final store = ref.read(favouritesStoreProvider);
    await store.reorder(busStopCodes);
    ref.invalidateSelf();
    await future;
  }

  /// Renames a favourite stop with a custom alias (pass `null` to clear).
  Future<void> rename(String busStopCode, String? alias) async {
    final store = ref.read(favouritesStoreProvider);
    await store.rename(busStopCode, alias);
    ref.invalidateSelf();
    await future;
  }
}
