/// Local persistence layer for favourite bus stops.
library;

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/favourite.dart';

/// Persists favourite bus stops to local storage via [SharedPreferences].
///
/// Favourites are stored as a JSON string list under [_key].
class FavouritesStore {
  static const _key = 'favourite_stops';

  /// Returns all saved favourite stops, ordered by [FavouriteStop.sortOrder].
  Future<List<FavouriteStop>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_key);
    if (jsonList == null || jsonList.isEmpty) return [];

    final favourites = jsonList
        .map(
          (json) =>
              FavouriteStop.fromJson(jsonDecode(json) as Map<String, dynamic>),
        )
        .toList();

    favourites.sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return favourites;
  }

  /// Adds a favourite stop.
  ///
  /// If a stop with the same [FavouriteStop.busStopCode] already exists,
  /// this is a no-op (duplicate prevention).
  Future<void> add(FavouriteStop stop) async {
    final favourites = await getAll();

    // Duplicate prevention: skip if already exists
    if (favourites.any((f) => f.busStopCode == stop.busStopCode)) return;

    favourites.add(stop);
    await _save(favourites);
  }

  /// Removes the favourite with the given [busStopCode].
  Future<void> remove(String busStopCode) async {
    final favourites = await getAll();
    favourites.removeWhere((f) => f.busStopCode == busStopCode);

    // Re-index sort orders to keep them contiguous
    final reindexed = <FavouriteStop>[
      for (var i = 0; i < favourites.length; i++)
        favourites[i].copyWith(sortOrder: i),
    ];

    await _save(reindexed);
  }

  /// Reorders favourites according to [busStopCodes].
  ///
  /// The new order is determined by the position in [busStopCodes].
  /// Stops not in the list retain their relative order at the end.
  Future<void> reorder(List<String> busStopCodes) async {
    final favourites = await getAll();
    final byCode = {for (final f in favourites) f.busStopCode: f};

    final ordered = <FavouriteStop>[];
    for (final code in busStopCodes) {
      final stop = byCode.remove(code);
      if (stop != null) ordered.add(stop);
    }
    // Append any remaining stops not in the reorder list
    ordered.addAll(byCode.values);

    // Re-index sort orders
    final reindexed = <FavouriteStop>[
      for (var i = 0; i < ordered.length; i++)
        ordered[i].copyWith(sortOrder: i),
    ];

    await _save(reindexed);
  }

  /// Renames a favourite stop with a custom alias.
  ///
  /// Pass `null` to clear the alias.
  Future<void> rename(String busStopCode, String? alias) async {
    final favourites = await getAll();
    final updated = favourites.map((f) {
      if (f.busStopCode == busStopCode) {
        return f.copyWith(customAlias: () => alias);
      }
      return f;
    }).toList();

    await _save(updated);
  }

  /// Returns whether the given [busStopCode] is a favourite.
  Future<bool> isFavourite(String busStopCode) async {
    final favourites = await getAll();
    return favourites.any((f) => f.busStopCode == busStopCode);
  }

  /// Persists the list to [SharedPreferences].
  Future<void> _save(List<FavouriteStop> favourites) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = favourites.map((f) => jsonEncode(f.toJson())).toList();
    await prefs.setStringList(_key, jsonList);
  }
}
