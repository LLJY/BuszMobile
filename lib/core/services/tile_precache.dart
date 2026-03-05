/// Utilities to precache map tiles for favourite locations.
///
/// Downloads CartoDB Voyager tiles ahead of time into the same
/// [CacheStore] used by [CachedTileProvider], so they are served
/// from disk when [flutter_map_cache] requests them later.
library;

import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';

import '../map/map_tile_layer.dart' show getMapCacheStore, precacheTileUrlBase;

class TilePrecache {
  static const List<int> _zoomLevels = <int>[13, 14, 15, 16];
  static const String _userAgent = 'BuszMobile/0.1.0 (tile-precache)';

  static Future<void> precacheForLocations(
    List<({double lat, double lng})> locations,
  ) async {
    if (kIsWeb || locations.isEmpty) return;

    // Use the same CacheStore as the map tile provider so precached
    // responses are found by CachedTileProvider at render time.
    final store = await getMapCacheStore();
    final dio = Dio()
      ..options.headers['User-Agent'] = _userAgent
      ..options.responseType = ResponseType.bytes
      ..options.connectTimeout = const Duration(seconds: 10)
      ..options.receiveTimeout = const Duration(seconds: 10);

    dio.interceptors.add(
      DioCacheInterceptor(
        options: CacheOptions(
          store: store,
          policy: CachePolicy.forceCache,
          maxStale: const Duration(days: 30),
          hitCacheOnNetworkFailure: true,
        ),
      ),
    );

    try {
      for (final location in locations) {
        for (final zoom in _zoomLevels) {
          final tile = _latLngToTile(location.lat, location.lng, zoom);

          for (var dx = -1; dx <= 1; dx++) {
            for (var dy = -1; dy <= 1; dy++) {
              final x = tile.x + dx;
              final y = tile.y + dy;

              if (!_isValidTile(x, y, zoom)) continue;

              // Use the same URL pattern as flutter_map's TileLayer with
              // retina (@2x) suffix, matching CachedTileProvider requests.
              final url = '$precacheTileUrlBase/$zoom/$x/$y@2x.png';

              try {
                await dio.get<void>(url);
              } catch (e) {
                debugPrint(
                  '[TilePrecache] Failed to download tile $zoom/$x/$y: $e',
                );
              }
            }
          }
        }
      }
    } finally {
      dio.close();
    }
  }

  static ({int x, int y}) _latLngToTile(double lat, double lng, int zoom) {
    final n = 1 << zoom;
    final latRad = lat * pi / 180.0;

    var x = ((lng + 180.0) / 360.0 * n).floor();
    var y = ((1 - (log(tan(latRad) + (1 / cos(latRad))) / pi)) / 2 * n).floor();

    if (x < 0) x = 0;
    if (x >= n) x = n - 1;
    if (y < 0) y = 0;
    if (y >= n) y = n - 1;

    return (x: x, y: y);
  }

  static bool _isValidTile(int x, int y, int zoom) {
    final n = 1 << zoom;
    return x >= 0 && y >= 0 && x < n && y < n;
  }
}
