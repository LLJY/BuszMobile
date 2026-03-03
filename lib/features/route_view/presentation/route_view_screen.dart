/// Route view screen showing a bus service's full route on a map.
///
/// Displays:
/// - Encoded polyline decoded and drawn in the service colour
/// - Stop markers along the route (small dots, name on tap)
/// - Optional highlighted stop (when navigated from stop detail)
/// - Draggable bottom sheet with ordered stop sequence list
library;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/error/error_boundary.dart';
import '../../../data/models/models.dart';
import '../providers/route_providers.dart';

// =============================================================================
// Route View Screen
// =============================================================================

class RouteViewScreen extends ConsumerWidget {
  final String serviceNo;
  final String? highlightStopCode;

  const RouteViewScreen({
    super.key,
    required this.serviceNo,
    this.highlightStopCode,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routeAsync = ref.watch(serviceRouteProvider(serviceNo));

    return Scaffold(
      appBar: AppBar(
        title: routeAsync.when(
          data: (data) => Row(
            children: [
              _ServiceBadge(serviceNo: data.serviceNo, color: data.color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '${data.origin} → ${data.destination}',
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          loading: () => Text('Service $serviceNo'),
          error: (_, _) => Text('Service $serviceNo'),
        ),
      ),
      body: routeAsync.when(
        data: (data) =>
            _RouteViewBody(data: data, highlightStopCode: highlightStopCode),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorBoundary(
          error: error,
          onRetry: () => ref.invalidate(serviceRouteProvider(serviceNo)),
        ),
      ),
    );
  }
}

// =============================================================================
// Service Badge
// =============================================================================

class _ServiceBadge extends StatelessWidget {
  final String serviceNo;
  final String color;

  const _ServiceBadge({required this.serviceNo, required this.color});

  @override
  Widget build(BuildContext context) {
    final badgeColor = _parseHexColor(color);
    final isDark =
        ThemeData.estimateBrightnessForColor(badgeColor) == Brightness.dark;
    final textColor = isDark ? Colors.white : Colors.black87;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: badgeColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        serviceNo,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }
}

// =============================================================================
// Route View Body: Map + Draggable Sheet
// =============================================================================

class _RouteViewBody extends StatefulWidget {
  final ServiceRouteData data;
  final String? highlightStopCode;

  const _RouteViewBody({required this.data, this.highlightStopCode});

  @override
  State<_RouteViewBody> createState() => _RouteViewBodyState();
}

class _RouteViewBodyState extends State<_RouteViewBody> {
  final _mapController = MapController();
  bool _hasFitted = false;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  void _fitBounds(List<LatLng> points) {
    if (points.isEmpty) return;
    final bounds = LatLngBounds.fromPoints(points);
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final routeColor = _parseHexColor(widget.data.color);
    final polylinePoints = _decodePolyline(widget.data.encodedPolyline);
    final stopPoints = widget.data.stops
        .where((s) => s.latitude != 0 && s.longitude != 0)
        .map((s) => LatLng(s.latitude, s.longitude))
        .toList();

    // Collect all points for bounds fitting
    final allPoints = <LatLng>[...polylinePoints, ...stopPoints];

    // Default center: First point of route or JB
    final initialCenter = allPoints.isNotEmpty
        ? allPoints.first
        : const LatLng(1.4927, 103.7414);

    // Fit bounds on first render
    if (allPoints.isNotEmpty && !_hasFitted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _fitBounds(allPoints);
        _hasFitted = true;
      });
    }

    return Stack(
      children: [
        // Full-screen map
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: initialCenter,
            initialZoom: 13,
            onMapReady: () {
              if (allPoints.isNotEmpty) {
                _fitBounds(allPoints);
              }
            },
          ),
          children: [
            // OSM tile layer
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'dev.floatpoint.busz_mobile',
            ),

            // Route polyline
            if (polylinePoints.isNotEmpty)
              PolylineLayer(
                polylines: [
                  Polyline(
                    points: polylinePoints,
                    strokeWidth: 4.0,
                    color: routeColor,
                  ),
                ],
              ),

            // Stop markers along route
            MarkerLayer(
              markers: widget.data.stops
                  .where((s) => s.latitude != 0 && s.longitude != 0)
                  .map((stop) {
                    final isHighlighted =
                        stop.busStopCode == widget.highlightStopCode;
                    return Marker(
                      point: LatLng(stop.latitude, stop.longitude),
                      width: isHighlighted ? 36 : 24,
                      height: isHighlighted ? 36 : 24,
                      child: _StopDot(
                        stopName: stop.busStopName,
                        isHighlighted: isHighlighted,
                        routeColor: routeColor,
                      ),
                    );
                  })
                  .toList(),
            ),
          ],
        ),

        // Draggable bottom sheet with stop sequence
        _StopSequenceSheet(
          stops: widget.data.stops,
          highlightStopCode: widget.highlightStopCode,
          routeColor: routeColor,
          onStopTap: (stopCode) {
            // Navigate to stop detail
            context.push('/stop/$stopCode');
          },
          onStopFocus: (stop) {
            // Pan map to focused stop
            if (stop.latitude != 0 && stop.longitude != 0) {
              _mapController.move(LatLng(stop.latitude, stop.longitude), 16);
            }
          },
        ),
      ],
    );
  }
}

// =============================================================================
// Stop Dot Marker
// =============================================================================

class _StopDot extends StatelessWidget {
  final String stopName;
  final bool isHighlighted;
  final Color routeColor;

  const _StopDot({
    required this.stopName,
    required this.isHighlighted,
    required this.routeColor,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: stopName,
      child: Container(
        decoration: BoxDecoration(
          color: isHighlighted ? Colors.red : routeColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: isHighlighted ? 3 : 2),
          boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 3)],
        ),
        child: isHighlighted
            ? const Icon(Icons.location_on, color: Colors.white, size: 18)
            : null,
      ),
    );
  }
}

// =============================================================================
// Stop Sequence Draggable Sheet
// =============================================================================

class _StopSequenceSheet extends StatefulWidget {
  final List<StopOnRoute> stops;
  final String? highlightStopCode;
  final Color routeColor;
  final ValueChanged<String> onStopTap;
  final ValueChanged<StopOnRoute> onStopFocus;

  const _StopSequenceSheet({
    required this.stops,
    this.highlightStopCode,
    required this.routeColor,
    required this.onStopTap,
    required this.onStopFocus,
  });

  @override
  State<_StopSequenceSheet> createState() => _StopSequenceSheetState();
}

class _StopSequenceSheetState extends State<_StopSequenceSheet> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();
  bool _hasScrolled = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sortedStops = List<StopOnRoute>.from(widget.stops)
      ..sort((a, b) => a.sequenceNo.compareTo(b.sequenceNo));

    return DraggableScrollableSheet(
      controller: _sheetController,
      initialChildSize: 0.3,
      minChildSize: 0.08,
      maxChildSize: 0.7,
      snap: true,
      builder: (context, scrollController) {
        // Auto-scroll logic when sheet is ready
        if (widget.highlightStopCode != null && !_hasScrolled) {
          final index = sortedStops.indexWhere(
            (s) => s.busStopCode == widget.highlightStopCode,
          );
          if (index != -1) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (scrollController.hasClients) {
                // Item height is roughly 44 pixels
                scrollController.jumpTo(index * 44.0);
                _hasScrolled = true;
              }
            });
          }
        }

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: Column(
            children: [
              // Drag handle
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colorScheme.outline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Icon(Icons.route, color: widget.routeColor, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      '${sortedStops.length} stops',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),

              // Stop list
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  itemCount: sortedStops.length,
                  itemBuilder: (context, index) {
                    final stop = sortedStops[index];
                    final isHighlighted =
                        stop.busStopCode == widget.highlightStopCode;
                    final isFirst = index == 0;
                    final isLast = index == sortedStops.length - 1;

                    return _StopSequenceTile(
                      stop: stop,
                      isHighlighted: isHighlighted,
                      isFirst: isFirst,
                      isLast: isLast,
                      routeColor: widget.routeColor,
                      onTap: () => widget.onStopTap(stop.busStopCode),
                      onFocus: () => widget.onStopFocus(stop),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// =============================================================================
// Stop Sequence Tile
// =============================================================================

class _StopSequenceTile extends StatelessWidget {
  final StopOnRoute stop;
  final bool isHighlighted;
  final bool isFirst;
  final bool isLast;
  final Color routeColor;
  final VoidCallback onTap;
  final VoidCallback onFocus;

  const _StopSequenceTile({
    required this.stop,
    required this.isHighlighted,
    required this.isFirst,
    required this.isLast,
    required this.routeColor,
    required this.onTap,
    required this.onFocus,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      onLongPress: onFocus,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Row(
          children: [
            // Timeline indicator
            SizedBox(
              width: 32,
              height: 40,
              child: CustomPaint(
                painter: _TimelinePainter(
                  color: routeColor,
                  isFirst: isFirst,
                  isLast: isLast,
                  isHighlighted: isHighlighted,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // Stop info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stop.busStopName,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isHighlighted
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isHighlighted ? Colors.red : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    stop.busStopCode,
                    style: TextStyle(
                      fontSize: 11,
                      color: colorScheme.outline,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),

            // Sequence number
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '#${stop.sequenceNo}',
                style: TextStyle(
                  fontSize: 10,
                  color: colorScheme.onSurfaceVariant,
                  fontFamily: 'monospace',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Timeline Painter (vertical line + dot for stop sequence)
// =============================================================================

class _TimelinePainter extends CustomPainter {
  final Color color;
  final bool isFirst;
  final bool isLast;
  final bool isHighlighted;

  _TimelinePainter({
    required this.color,
    required this.isFirst,
    required this.isLast,
    required this.isHighlighted,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 2;
    final dotPaint = Paint()..color = isHighlighted ? Colors.red : color;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final dotRadius = isHighlighted ? 6.0 : 4.0;

    // Top line
    if (!isFirst) {
      canvas.drawLine(
        Offset(centerX, 0),
        Offset(centerX, centerY - dotRadius),
        linePaint,
      );
    }

    // Bottom line
    if (!isLast) {
      canvas.drawLine(
        Offset(centerX, centerY + dotRadius),
        Offset(centerX, size.height),
        linePaint,
      );
    }

    // Dot
    canvas.drawCircle(Offset(centerX, centerY), dotRadius, dotPaint);

    // White inner dot for highlighted
    if (isHighlighted) {
      canvas.drawCircle(
        Offset(centerX, centerY),
        3,
        Paint()..color = Colors.white,
      );
    }
  }

  @override
  bool shouldRepaint(_TimelinePainter oldDelegate) =>
      color != oldDelegate.color ||
      isFirst != oldDelegate.isFirst ||
      isLast != oldDelegate.isLast ||
      isHighlighted != oldDelegate.isHighlighted;
}

// =============================================================================
// Utilities
// =============================================================================

/// Parses a hex colour string (e.g. "#FF6600") to a Flutter [Color].
///
/// Falls back to grey if the string is invalid.
Color _parseHexColor(String hex) {
  try {
    final cleaned = hex.replaceFirst('#', '');
    if (cleaned.length == 6) {
      return Color(int.parse('FF$cleaned', radix: 16));
    }
    if (cleaned.length == 8) {
      return Color(int.parse(cleaned, radix: 16));
    }
  } catch (_) {
    // Fall through to default
  }
  return Colors.grey;
}

/// Decodes a Google encoded polyline string into a list of [LatLng] points.
///
/// Implements Google's Encoded Polyline Algorithm:
/// https://developers.google.com/maps/documentation/utilities/polylinealgorithm
List<LatLng> _decodePolyline(String encoded) {
  if (encoded.isEmpty) return [];

  final points = <LatLng>[];
  var index = 0;
  var lat = 0;
  var lng = 0;

  while (index < encoded.length) {
    // Decode latitude
    var shift = 0;
    var result = 0;
    int b;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

    // Decode longitude
    shift = 0;
    result = 0;
    do {
      b = encoded.codeUnitAt(index++) - 63;
      result |= (b & 0x1f) << shift;
      shift += 5;
    } while (b >= 0x20);
    lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

    points.add(LatLng(lat / 1e5, lng / 1e5));
  }

  return points;
}
