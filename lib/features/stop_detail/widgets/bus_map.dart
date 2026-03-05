/// Bus map widget showing live GPS positions on OpenStreetMap.
///
/// Uses flutter_map + latlong2 for OSM tile rendering.
/// Displays:
/// - Route polyline (when a service is selected)
/// - Route stops as small black dots with white outline
/// - Current stop emphasized with a red marker
/// - Bus markers with service labels and heading arrows
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/map/map_tile_layer.dart';
import '../../../data/models/models.dart';

// =============================================================================
// Bus Map
// =============================================================================

class BusMap extends StatefulWidget {
  /// Bus GPS positions to display as markers.
  final List<BusLocationInfo> busLocations;

  /// The bus stop location (latitude, longitude) for the stop marker.
  final LatLng? stopLocation;

  /// The name of the stop (for tooltip).
  final String? stopName;

  /// Plate number -> ETA minutes to *this* stop (cross-referenced from
  /// arrival data). Used instead of the unpopulated etaToNextStopMinutes.
  final Map<String, int> plateEtaMinutes;

  /// Route polyline points (semicolon-separated format, pre-parsed).
  /// Shown when a service is selected.
  final List<LatLng> polylinePoints;

  /// Color for the route polyline.
  final Color polylineColor;

  /// All stops along the route, shown as small dots.
  final List<StopOnRoute> routeStops;

  /// Bus stop code of the currently viewed stop (for emphasis).
  final String? currentStopCode;

  /// Extra bottom padding (logical pixels) to account for occluding UI
  /// elements like a bottom sheet. Applied when fitting camera bounds so
  /// the route/stops remain visible above the sheet.
  final double bottomInset;

  const BusMap({
    super.key,
    required this.busLocations,
    this.stopLocation,
    this.stopName,
    this.plateEtaMinutes = const {},
    this.polylinePoints = const [],
    this.polylineColor = Colors.blue,
    this.routeStops = const [],
    this.currentStopCode,
    this.bottomInset = 0,
  });

  @override
  State<BusMap> createState() => _BusMapState();
}

class _BusMapState extends State<BusMap> {
  final _mapController = MapController();
  bool _hasFitted = false;
  TileLayer? _cachedTileLayer;

  @override
  void initState() {
    super.initState();
    cachedTileLayer().then((layer) {
      if (mounted) setState(() => _cachedTileLayer = layer);
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BusMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-fit bounds when locations change significantly or content differs
    if (widget.busLocations.length != oldWidget.busLocations.length ||
        widget.polylinePoints.length != oldWidget.polylinePoints.length ||
        widget.currentStopCode != oldWidget.currentStopCode ||
        widget.stopLocation != oldWidget.stopLocation ||
        _polylineEndpointsChanged(oldWidget) ||
        (widget.bottomInset - oldWidget.bottomInset).abs() > 20) {
      _hasFitted = false;
    }
  }

  /// Check if polyline endpoints changed (same length but different route).
  bool _polylineEndpointsChanged(BusMap oldWidget) {
    if (widget.polylinePoints.isEmpty || oldWidget.polylinePoints.isEmpty) {
      return false;
    }
    return widget.polylinePoints.first != oldWidget.polylinePoints.first ||
        widget.polylinePoints.last != oldWidget.polylinePoints.last;
  }

  /// Returns positions of route stops within ±5 of the current stop.
  List<LatLng> _nearbyRouteStopPoints() {
    if (widget.routeStops.isEmpty || widget.currentStopCode == null) return [];
    final idx = widget.routeStops.indexWhere(
      (s) => s.busStopCode == widget.currentStopCode,
    );
    if (idx == -1) return [];
    final start = (idx - 5).clamp(0, widget.routeStops.length);
    final end = (idx + 6).clamp(0, widget.routeStops.length); // exclusive
    return widget.routeStops
        .sublist(start, end)
        .where((s) => s.latitude != 0 && s.longitude != 0)
        .map((s) => LatLng(s.latitude, s.longitude))
        .toList();
  }

  void _fitBounds(List<LatLng> points) {
    if (points.isEmpty) return;

    final padding = EdgeInsets.fromLTRB(50, 50, 50, 50 + widget.bottomInset);

    if (points.length == 1) {
      // Single point: create a small bounding box so fitCamera can
      // apply asymmetric padding (shifting the visible center upward).
      final p = points.first;
      const d = 0.002; // ~220 m
      _mapController.fitCamera(
        CameraFit.bounds(
          bounds: LatLngBounds(
            LatLng(p.latitude - d, p.longitude - d),
            LatLng(p.latitude + d, p.longitude + d),
          ),
          padding: padding,
          maxZoom: 15,
        ),
      );
    } else {
      final bounds = LatLngBounds.fromPoints(points);
      _mapController.fitCamera(
        CameraFit.bounds(bounds: bounds, padding: padding),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Collect points for bounds fitting: current stop ±5 stops + buses.
    // The full polyline is still drawn but the camera focuses on the
    // immediate neighbourhood rather than the entire route.
    final nearbyStopPoints = _nearbyRouteStopPoints();
    final points = <LatLng>[
      if (widget.stopLocation != null) widget.stopLocation!,
      ...widget.busLocations.map((loc) => LatLng(loc.latitude, loc.longitude)),
      ...nearbyStopPoints,
    ];

    // Default center: Johor Bahru if no points
    const defaultCenter = LatLng(1.4927, 103.7414);

    // Fit bounds on first render with data
    if (points.isNotEmpty && !_hasFitted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _fitBounds(points);
        _hasFitted = true;
      });
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: points.isNotEmpty ? points.first : defaultCenter,
        initialZoom: 14,
        onMapReady: () {
          if (points.isNotEmpty) {
            _fitBounds(points);
          }
        },
      ),
      children: [
        // Map tiles (cached CartoDB Voyager)
        _cachedTileLayer ?? uncachedTileLayer(),

        // Route polyline
        if (widget.polylinePoints.isNotEmpty)
          PolylineLayer(
            polylines: [
              Polyline(
                points: widget.polylinePoints,
                strokeWidth: 4.0,
                color: widget.polylineColor,
              ),
            ],
          ),

        // Route stop markers (small black dots, skip current — pin below)
        if (widget.routeStops.isNotEmpty)
          MarkerLayer(
            markers: widget.routeStops
                .where(
                  (s) =>
                      s.latitude != 0 &&
                      s.longitude != 0 &&
                      s.busStopCode != widget.currentStopCode,
                )
                .map(
                  (stop) => Marker(
                    point: LatLng(stop.latitude, stop.longitude),
                    width: 14,
                    height: 14,
                    child: Tooltip(
                      message: stop.busStopName,
                      child: const _RouteStopDot(),
                    ),
                  ),
                )
                .toList(),
          ),

        // Current stop marker — always shown when location is known
        if (widget.stopLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: widget.stopLocation!,
                width: 36,
                height: 36,
                child: const _CurrentStopMarker(),
              ),
            ],
          ),

        // Bus markers
        MarkerLayer(
          markers: widget.busLocations.map((loc) {
            final etaMinutes = widget.plateEtaMinutes[loc.plateNo];
            return Marker(
              point: LatLng(loc.latitude, loc.longitude),
              width: 100,
              height: 64,
              child: _BusMarker(location: loc, etaMinutesToStop: etaMinutes),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// =============================================================================
// Route Stop Dot (small black dot with white outline)
// =============================================================================

class _RouteStopDot extends StatelessWidget {
  const _RouteStopDot();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black87,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
    );
  }
}

// =============================================================================
// Current Stop Marker (emphasized)
// =============================================================================

class _CurrentStopMarker extends StatelessWidget {
  const _CurrentStopMarker();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(color: Colors.black38, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: const Icon(Icons.location_on, color: Colors.white, size: 18),
    );
  }
}

// =============================================================================
// Bus Marker
// =============================================================================

class _BusMarker extends StatelessWidget {
  final BusLocationInfo location;

  /// ETA in minutes to the queried stop (from arrival data).
  /// null if no matching arrival found.
  final int? etaMinutesToStop;

  const _BusMarker({required this.location, this.etaMinutesToStop});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasHeading = location.heading != 0;

    // Build label: "J10 · 5m" or "J10 · ARR" or "J10" (no ETA)
    final etaText = switch (etaMinutesToStop) {
      null => '',
      <= 0 => ' · ARR',
      _ => ' · ${etaMinutesToStop}m',
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Speech bubble with service + ETA
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: colorScheme.inverseSurface,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${location.serviceNo}$etaText',
                style: TextStyle(
                  color: colorScheme.onInverseSurface,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (location.speedKmh > 0) ...[
                const SizedBox(width: 4),
                Text(
                  '${location.speedKmh.toStringAsFixed(0)}km/h',
                  style: TextStyle(
                    color: colorScheme.onInverseSurface.withValues(alpha: 0.75),
                    fontSize: 9,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 2),
        // Bus icon: arrow with heading, or dot if no heading data
        if (hasHeading)
          Transform.rotate(
            angle: location.heading * math.pi / 180,
            child: const Icon(
              Icons.navigation,
              color: Colors.blue,
              size: 32,
              shadows: [Shadow(color: Colors.black54, blurRadius: 4)],
            ),
          )
        else
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: const [
                BoxShadow(color: Colors.black38, blurRadius: 3),
              ],
            ),
          ),
      ],
    );
  }
}
