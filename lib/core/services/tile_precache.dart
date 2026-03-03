/// Utilities to precache OpenStreetMap tiles for favourite locations.
library;

import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class TilePrecache {
  static const List<int> _zoomLevels = <int>[13, 14, 15, 16];
  static const String _userAgent = 'BuszMobile/0.1.0 (tile-precache)';

  static Future<void> precacheForLocations(
    List<({double lat, double lng})> locations,
  ) async {
    if (kIsWeb || locations.isEmpty) return;

    final cacheDir = await getApplicationCacheDirectory();
    final tilesRoot = Directory('${cacheDir.path}/tiles');
    await tilesRoot.create(recursive: true);

    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 10);
    try {
      for (final location in locations) {
        for (final zoom in _zoomLevels) {
          final tile = _latLngToTile(location.lat, location.lng, zoom);

          for (var dx = -1; dx <= 1; dx++) {
            for (var dy = -1; dy <= 1; dy++) {
              final x = tile.x + dx;
              final y = tile.y + dy;

              if (!_isValidTile(x, y, zoom)) continue;

              final tileFile = File('${tilesRoot.path}/$zoom/$x/$y.png');
              if (await tileFile.exists()) continue;

              await tileFile.parent.create(recursive: true);
              await _downloadTile(client, zoom, x, y, tileFile);
            }
          }
        }
      }
    } finally {
      client.close(force: true);
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

  static Future<void> _downloadTile(
    HttpClient client,
    int zoom,
    int x,
    int y,
    File target,
  ) async {
    final uri = Uri.parse('https://tile.openstreetmap.org/$zoom/$x/$y.png');

    try {
      final request = await client.getUrl(uri);
      request.headers.set(HttpHeaders.userAgentHeader, _userAgent);

      final response = await request.close();
      if (response.statusCode != HttpStatus.ok) {
        await response.drain<void>();
        return;
      }

      final bytes = await response.fold<List<int>>(<int>[], (buffer, chunk) {
        buffer.addAll(chunk);
        return buffer;
      });

      await target.writeAsBytes(bytes, flush: true);
    } catch (_) {}
  }
}
