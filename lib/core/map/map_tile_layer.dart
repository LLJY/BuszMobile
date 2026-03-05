/// Shared map tile configuration with disk caching.
///
/// Uses CartoDB Voyager raster tiles (Google Maps-like appearance)
/// served from CARTO's global CDN with local file-system caching
/// via [flutter_map_cache].
library;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:http_cache_core/http_cache_core.dart';
import 'package:http_cache_file_store/http_cache_file_store.dart';
import 'package:path_provider/path_provider.dart';

// =============================================================================
// Tile URLs
// =============================================================================

/// CartoDB Voyager — clean, Google Maps-like raster tiles.
/// Subdomains: a, b, c, d for parallel downloads.
const _voyagerUrl =
    'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png';

/// CartoDB Dark Matter — dark theme variant.
const _darkMatterUrl =
    'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png';

const _subdomains = ['a', 'b', 'c', 'd'];

const _attribution =
    '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> '
    '&copy; <a href="https://carto.com/attributions">CARTO</a>';

// =============================================================================
// Cached Tile Provider (singleton-ish via static Future)
// =============================================================================

Future<CacheStore>? _cacheStoreFuture;

/// Returns a shared [CacheStore] backed by the app's cache directory.
/// Safe to call multiple times — only initialises once.
///
/// Exposed for [TilePrecache] so it can pre-populate the same cache.
Future<CacheStore> getMapCacheStore() {
  _cacheStoreFuture ??= _initCacheStore();
  return _cacheStoreFuture!;
}

Future<CacheStore> _initCacheStore() async {
  if (kIsWeb) {
    // Web: fall back to in-memory (no file system)
    return MemCacheStore();
  }
  final dir = await getTemporaryDirectory();
  return FileCacheStore('${dir.path}${Platform.pathSeparator}map_tiles');
}

// =============================================================================
// Public API
// =============================================================================

/// Creates a [TileLayer] with cached CartoDB Voyager tiles.
///
/// [darkMode] selects Dark Matter instead of Voyager.
///
/// Wrap in a [FutureBuilder] or resolve the future in [initState]:
/// ```dart
/// FutureBuilder<TileLayer>(
///   future: cachedTileLayer(),
///   builder: (ctx, snap) => snap.data ?? const SizedBox.shrink(),
/// )
/// ```
Future<TileLayer> cachedTileLayer({bool darkMode = false}) async {
  final store = await getMapCacheStore();
  return TileLayer(
    urlTemplate: darkMode ? _darkMatterUrl : _voyagerUrl,
    subdomains: _subdomains,
    tileProvider: CachedTileProvider(
      maxStale: const Duration(days: 30),
      store: store,
    ),
    retinaMode: true,
    userAgentPackageName: 'dev.floatpoint.busz_mobile',
    additionalOptions: const {'attribution': _attribution},
  );
}

/// Synchronous fallback that returns an uncached tile layer.
/// Use when you cannot await (e.g. first frame before cache initialises).
TileLayer uncachedTileLayer({bool darkMode = false}) {
  return TileLayer(
    urlTemplate: darkMode ? _darkMatterUrl : _voyagerUrl,
    subdomains: _subdomains,
    retinaMode: true,
    userAgentPackageName: 'dev.floatpoint.busz_mobile',
  );
}

/// The base URL used for precaching (without subdomains / placeholders).
/// Used by [TilePrecache] to download tiles ahead of time.
const precacheTileUrlBase =
    'https://a.basemaps.cartocdn.com/rastertiles/voyager';
