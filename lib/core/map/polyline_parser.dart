/// Parses semicolon-separated polyline strings off the main thread.
///
/// Backend format: `"lat,lon;lat,lon;..."`.
/// Heavy polylines (thousands of points) are parsed in an isolate
/// via [compute] to avoid jank.
library;

import 'package:flutter/foundation.dart' show compute;
import 'package:latlong2/latlong.dart';

/// Threshold below which we parse synchronously (not worth isolate overhead).
const _kIsolateThreshold = 500;

/// Parse a semicolon-separated polyline string into [LatLng] points.
///
/// Runs in an isolate when the string is large enough to warrant it.
Future<List<LatLng>> parsePolyline(String encoded) async {
  if (encoded.isEmpty) return const [];

  // Small polylines: parse synchronously on the main thread.
  if (encoded.length < _kIsolateThreshold) {
    return _toLatLngs(_parseRaw(encoded));
  }

  // Large polylines: offload string splitting to an isolate.
  final raw = await compute(_parseRaw, encoded);
  return _toLatLngs(raw);
}

/// Synchronous variant for contexts that cannot await.
List<LatLng> parsePolylineSync(String encoded) {
  if (encoded.isEmpty) return const [];
  return _toLatLngs(_parseRaw(encoded));
}

/// Pure function safe for isolates (no Flutter/dart:ui types).
/// Returns pairs of (lat, lng) as a flat Float64List-like structure.
List<(double, double)> _parseRaw(String encoded) {
  final pairs = <(double, double)>[];
  for (final pair in encoded.split(';')) {
    final trimmed = pair.trim();
    if (trimmed.isEmpty) continue;
    final comma = trimmed.indexOf(',');
    if (comma < 0) continue;
    final lat = double.tryParse(trimmed.substring(0, comma));
    final lng = double.tryParse(trimmed.substring(comma + 1));
    if (lat != null && lng != null) {
      pairs.add((lat, lng));
    }
  }
  return pairs;
}

/// Convert raw tuples to [LatLng]. Cheap — runs on the main thread.
List<LatLng> _toLatLngs(List<(double, double)> raw) {
  return raw.map((p) => LatLng(p.$1, p.$2)).toList();
}
