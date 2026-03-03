/// Stop detail screen showing arrivals and live bus map.
///
/// Layout:
/// - No service selected: full-screen arrival list
/// - Service tapped: split view with map (top) + arrivals (bottom sheet)
///
/// Polls GetStopArrivals every 15s with include_bus_locations=true.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/error/error_boundary.dart';
import '../../../data/local/favourites_providers.dart';
import '../../../data/models/favourite.dart';
import '../../../data/models/models.dart';
import '../providers/stop_detail_providers.dart';
import '../widgets/arrival_tile.dart';
import '../widgets/bus_map.dart';

// =============================================================================
// Stop Detail Screen
// =============================================================================

class StopDetailScreen extends ConsumerWidget {
  final String busStopCode;
  final String busStopName;
  final double? stopLatitude;
  final double? stopLongitude;

  const StopDetailScreen({
    super.key,
    required this.busStopCode,
    required this.busStopName,
    this.stopLatitude,
    this.stopLongitude,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final arrivalsAsync = ref.watch(stopArrivalsProvider(busStopCode));
    final selectedService = ref.watch(selectedServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(busStopName, style: const TextStyle(fontSize: 16)),
            Text(
              busStopCode,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
                fontFamily: 'monospace',
              ),
            ),
          ],
        ),
        actions: [
          // Favourite toggle button
          Consumer(
            builder: (context, ref, _) {
              final favourites = ref.watch(favouritesProvider);
              final isFav =
                  favourites.value?.any((f) => f.busStopCode == busStopCode) ??
                  false;
              return IconButton(
                icon: Icon(isFav ? Icons.star : Icons.star_border),
                color: isFav ? Colors.amber : null,
                tooltip: isFav ? 'Remove from favourites' : 'Add to favourites',
                onPressed: () {
                  final notifier = ref.read(favouritesProvider.notifier);
                  if (isFav) {
                    notifier.remove(busStopCode);
                  } else {
                    notifier.add(
                      FavouriteStop(
                        busStopCode: busStopCode,
                        busStopName: busStopName,
                        latitude: stopLatitude,
                        longitude: stopLongitude,
                        serviceNos: const [],
                        sortOrder: 0,
                        addedAt: DateTime.now(),
                      ),
                    );
                  }
                },
              );
            },
          ),
          // Clear filter button
          if (selectedService != null)
            IconButton(
              icon: const Icon(Icons.clear),
              tooltip: 'Clear filter',
              onPressed: () {
                ref.read(selectedServiceProvider.notifier).select(null);
              },
            ),
          // Refresh indicator
          arrivalsAsync.when(
            data: (data) => _UpdatedAtChip(updatedAt: data.updatedAt),
            loading: () => const Padding(
              padding: EdgeInsets.all(12),
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (_, _) => const Icon(Icons.error_outline, color: Colors.red),
          ),
        ],
      ),
      body: arrivalsAsync.when(
        data: (data) => _StopDetailBody(
          data: data,
          selectedService: selectedService,
          stopLatitude: stopLatitude,
          stopLongitude: stopLongitude,
          onServiceTap: (serviceNo) {
            final current = ref.read(selectedServiceProvider);
            ref
                .read(selectedServiceProvider.notifier)
                .select(current == serviceNo ? null : serviceNo);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorBoundary(
          error: error,
          onRetry: () => ref.invalidate(stopArrivalsProvider(busStopCode)),
        ),
      ),
    );
  }
}

// =============================================================================
// Body: Map + Arrivals List
// =============================================================================

class _StopDetailBody extends StatelessWidget {
  final StopArrivalsData data;
  final String? selectedService;
  final double? stopLatitude;
  final double? stopLongitude;
  final ValueChanged<String> onServiceTap;

  const _StopDetailBody({
    required this.data,
    required this.selectedService,
    this.stopLatitude,
    this.stopLongitude,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    final filteredLocations = selectedService != null
        ? data.busLocations
              .where((loc) => loc.serviceNo == selectedService)
              .toList()
        : <BusLocationInfo>[];

    // Build plate -> ETA lookup from arrival data
    final plateEtaMap = <String, int>{};
    for (final bus in data.buses) {
      if (bus.plateNo.isNotEmpty && bus.nextArrivalMinutes != null) {
        plateEtaMap[bus.plateNo] = bus.nextArrivalMinutes!;
      }
      if (bus.laterPlateNo.isNotEmpty && bus.laterArrivalMinutes != null) {
        plateEtaMap[bus.laterPlateNo] = bus.laterArrivalMinutes!;
      }
    }

    final stopLocation = (stopLatitude != null && stopLongitude != null)
        ? LatLng(stopLatitude!, stopLongitude!)
        : null;

    if (selectedService == null) {
      // Full-screen arrival list
      return _ArrivalsList(
        data: data,
        selectedService: selectedService,
        onServiceTap: onServiceTap,
      );
    }

    // Split view: map + bottom sheet
    return Column(
      children: [
        // Map (top half)
        Expanded(
          flex: 1,
          child: BusMap(
            busLocations: filteredLocations,
            stopLocation: stopLocation,
            plateEtaMinutes: plateEtaMap,
          ),
        ),

        // Arrivals list (bottom half)
        Expanded(
          flex: 1,
          child: _ArrivalsList(
            data: data,
            selectedService: selectedService,
            onServiceTap: onServiceTap,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Arrivals List
// =============================================================================

class _ArrivalsList extends StatelessWidget {
  final StopArrivalsData data;
  final String? selectedService;
  final ValueChanged<String> onServiceTap;

  const _ArrivalsList({
    required this.data,
    required this.selectedService,
    required this.onServiceTap,
  });

  @override
  Widget build(BuildContext context) {
    if (data.buses.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.directions_bus_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No arrivals',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Location count banner
        if (data.busLocations.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: Colors.blue.withValues(alpha: 0.1),
            child: Text(
              '${data.busLocations.length} bus location(s) tracked  '
              '|  Tap a service to view on map',
              style: const TextStyle(fontSize: 12, color: Colors.blue),
            ),
          ),

        // Arrival tiles
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            itemCount: data.buses.length,
            itemBuilder: (context, index) {
              final arrival = data.buses[index];
              return ArrivalTile(
                arrival: arrival,
                isSelected: arrival.serviceNo == selectedService,
                onTap: () => onServiceTap(arrival.serviceNo),
              );
            },
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Updated At Chip
// =============================================================================

class _UpdatedAtChip extends StatelessWidget {
  final DateTime? updatedAt;

  const _UpdatedAtChip({this.updatedAt});

  @override
  Widget build(BuildContext context) {
    if (updatedAt == null) return const SizedBox.shrink();

    final ago = DateTime.now().difference(updatedAt!);
    final label = ago.inSeconds < 60
        ? '${ago.inSeconds}s ago'
        : '${ago.inMinutes}m ago';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Chip(
        label: Text(label, style: const TextStyle(fontSize: 11)),
        avatar: const Icon(Icons.access_time, size: 14),
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
