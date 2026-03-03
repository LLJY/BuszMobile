/// Bus map widget showing live GPS positions on OpenStreetMap.
///
/// Uses flutter_map + latlong2 for OSM tile rendering.
/// Shows bus markers with service number labels and heading arrows.
/// Shows the bus stop itself with a red marker.
library;

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

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

  const BusMap({
    super.key,
    required this.busLocations,
    this.stopLocation,
    this.stopName,
    this.plateEtaMinutes = const {},
  });

  @override
  State<BusMap> createState() => _BusMapState();
}

class _BusMapState extends State<BusMap> {
  final _mapController = MapController();
  bool _hasFitted = false;

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(BusMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-fit bounds when locations change significantly
    if (widget.busLocations.length != oldWidget.busLocations.length) {
      _hasFitted = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Calculate bounds to fit all markers
    final points = <LatLng>[
      if (widget.stopLocation != null) widget.stopLocation!,
      ...widget.busLocations.map((loc) => LatLng(loc.latitude, loc.longitude)),
    ];

    // Default center: Johor Bahru if no points
    const defaultCenter = LatLng(1.4927, 103.7414);

    // Fit bounds on first render with data
    if (points.isNotEmpty && !_hasFitted) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (points.length == 1) {
          _mapController.move(points.first, 15);
        } else {
          final bounds = LatLngBounds.fromPoints(points);
          _mapController.fitCamera(
            CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(50)),
          );
        }
        _hasFitted = true;
      });
    }

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: points.isNotEmpty ? points.first : defaultCenter,
        initialZoom: 14,
      ),
      children: [
        // OSM tile layer
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'dev.floatpoint.busz_mobile',
        ),

        // Bus stop marker
        if (widget.stopLocation != null)
          MarkerLayer(
            markers: [
              Marker(
                point: widget.stopLocation!,
                width: 40,
                height: 40,
                child: const _StopMarker(),
              ),
            ],
          ),

        // Bus markers
        MarkerLayer(
          markers: widget.busLocations.map((loc) {
            final etaMinutes = widget.plateEtaMinutes[loc.plateNo];
            return Marker(
              point: LatLng(loc.latitude, loc.longitude),
              width: 90,
              height: 56,
              child: _BusMarker(location: loc, etaMinutesToStop: etaMinutes),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// =============================================================================
// Stop Marker
// =============================================================================

class _StopMarker extends StatelessWidget {
  const _StopMarker();

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
      child: const Icon(Icons.directions_bus, color: Colors.white, size: 20),
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
            color: Colors.black87,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${location.serviceNo}$etaText',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (location.speedKmh > 0) ...[
                const SizedBox(width: 4),
                Text(
                  '${location.speedKmh.toStringAsFixed(0)}km/h',
                  style: TextStyle(color: Colors.grey[400], fontSize: 9),
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
              size: 22,
              shadows: [Shadow(color: Colors.black54, blurRadius: 3)],
            ),
          )
        else
          Container(
            width: 16,
            height: 16,
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
