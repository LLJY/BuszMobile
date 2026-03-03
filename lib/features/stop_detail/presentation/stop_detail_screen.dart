/// Stop detail screen showing arrivals and live bus map.
///
/// Layout:
/// - No service selected: full-screen arrival list
/// - Service tapped: split view with map (top) + arrivals (bottom sheet)
///
/// Polls GetStopArrivals every 15s with include_bus_locations=true.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/error/error_boundary.dart';
import '../../../core/widgets/skeleton_loaders.dart';
import '../../../data/local/favourites_providers.dart';
import '../../../data/models/favourite.dart';
import '../../../data/models/models.dart';
import '../providers/stop_detail_providers.dart';
import '../widgets/arrival_tile.dart';
import '../widgets/bus_map.dart';
import '../widgets/service_chips_bar.dart';

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

  /// Whether the current platform is a desktop-class environment.
  bool get _isDesktop =>
      kIsWeb ||
      defaultTargetPlatform == TargetPlatform.linux ||
      defaultTargetPlatform == TargetPlatform.macOS ||
      defaultTargetPlatform == TargetPlatform.windows;

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
                color: Theme.of(context).colorScheme.outline,
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
            error: (_, _) => Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
      body: Hero(
        tag: 'stop_$busStopCode',
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: Column(
            children: [
              // Service chips bar — only show on desktop
              if (_isDesktop)
                ServiceChipsBar(
                  busStopCode: busStopCode,
                  selectedService: selectedService,
                  onServiceTap: (serviceNo) {
                    final current = ref.read(selectedServiceProvider);
                    ref
                        .read(selectedServiceProvider.notifier)
                        .select(current == serviceNo ? null : serviceNo);
                  },
                ),

              // Arrivals content (map + list)
              Expanded(
                child: arrivalsAsync.when(
                  data: (data) => _StopDetailBody(
                    busStopCode: busStopCode,
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
                  loading: () => ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    itemCount: 4,
                    separatorBuilder: (_, _) => const SizedBox(height: 6),
                    itemBuilder: (context, index) =>
                        const ArrivalTileSkeleton(),
                  ),
                  error: (error, stack) => ErrorBoundary(
                    error: error,
                    onRetry: () =>
                        ref.invalidate(stopArrivalsProvider(busStopCode)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Body: Map + Arrivals List (Draggable Sheet)
// =============================================================================

class _StopDetailBody extends StatefulWidget {
  final String busStopCode;
  final StopArrivalsData data;
  final String? selectedService;
  final double? stopLatitude;
  final double? stopLongitude;
  final ValueChanged<String> onServiceTap;

  const _StopDetailBody({
    required this.busStopCode,
    required this.data,
    required this.selectedService,
    this.stopLatitude,
    this.stopLongitude,
    required this.onServiceTap,
  });

  @override
  State<_StopDetailBody> createState() => _StopDetailBodyState();
}

class _StopDetailBodyState extends State<_StopDetailBody> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void dispose() {
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Show either the selected service buses, or ALL buses for this stop if none selected
    final locations = widget.selectedService != null
        ? widget.data.busLocations
              .where((loc) => loc.serviceNo == widget.selectedService)
              .toList()
        : widget.data.busLocations;

    // Build plate -> ETA lookup from arrival data
    final plateEtaMap = <String, int>{};
    for (final bus in widget.data.buses) {
      if (bus.plateNo.isNotEmpty && bus.nextArrivalMinutes != null) {
        plateEtaMap[bus.plateNo] = bus.nextArrivalMinutes!;
      }
      if (bus.laterPlateNo.isNotEmpty && bus.laterArrivalMinutes != null) {
        plateEtaMap[bus.laterPlateNo] = bus.laterArrivalMinutes!;
      }
    }

    final stopLocation =
        (widget.stopLatitude != null && widget.stopLongitude != null)
        ? LatLng(widget.stopLatitude!, widget.stopLongitude!)
        : null;

    return Stack(
      children: [
        // Map (background, always full)
        BusMap(
          busLocations: locations,
          stopLocation: stopLocation,
          plateEtaMinutes: plateEtaMap,
        ),

        // Draggable arrivals sheet
        _ArrivalsSheet(
          controller: _sheetController,
          busStopCode: widget.busStopCode,
          data: widget.data,
          selectedService: widget.selectedService,
          onServiceTap: widget.onServiceTap,
        ),

        // FAB - moved inside Stack for perfect positioning and reactive visibility
        ListenableBuilder(
          listenable: _sheetController,
          builder: (context, _) {
            final double currentSize = _sheetController.isAttached
                ? _sheetController.size
                : 1.0;

            // Hide FAB when at the bottom (minimized) OR when no service is selected
            final bool visible =
                widget.selectedService != null && currentSize > 0.2;

            return AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              right: 16,
              bottom: visible ? 16 : -80, // Slide off screen when hidden
              child: FloatingActionButton.small(
                heroTag: null, // Fix: Nested Hero crash
                tooltip: 'View full route',
                onPressed: () {
                  context.push(
                    '/route/${widget.selectedService}?highlight=${widget.busStopCode}',
                  );
                },
                child: const Icon(Icons.route),
              ),
            );
          },
        ),
      ],
    );
  }
}

// =============================================================================
// Arrivals Sheet (DraggableScrollableSheet)
// =============================================================================

class _ArrivalsSheet extends StatefulWidget {
  final DraggableScrollableController controller;
  final String busStopCode;
  final StopArrivalsData data;
  final String? selectedService;
  final ValueChanged<String> onServiceTap;

  const _ArrivalsSheet({
    required this.controller,
    required this.busStopCode,
    required this.data,
    required this.selectedService,
    required this.onServiceTap,
  });

  @override
  State<_ArrivalsSheet> createState() => _ArrivalsSheetState();
}

class _ArrivalsSheetState extends State<_ArrivalsSheet> {
  bool _isUnselecting = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_isUnselecting) return;

    // If dragged to the very top (1.0), and we have a selection, unselect it.
    // This allows dragging up to "dismiss" the map and selection.
    if (widget.selectedService != null &&
        widget.controller.isAttached &&
        widget.controller.size >= 0.98) {
      _isUnselecting = true;
      // Use microtask to avoid calling build during build
      Future.microtask(() {
        widget.onServiceTap(widget.selectedService!);
        _isUnselecting = false;
      });
    }
  }

  @override
  void didUpdateWidget(_ArrivalsSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If a service was selected (likely via tap), snap to the small state
    if (widget.selectedService != null && oldWidget.selectedService == null) {
      if (widget.controller.isAttached) {
        widget.controller.animateTo(
          0.18,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        // Dynamic styling based on scroll position
        final double currentSize = widget.controller.isAttached
            ? widget.controller.size
            : 1.0;
        final bool isFullscreen = currentSize >= 0.95;
        final double cornerRadius = isFullscreen ? 0 : 20;

        return DraggableScrollableSheet(
          controller: widget.controller,
          initialChildSize: 1.0,
          minChildSize: 0.18,
          maxChildSize: 1.0,
          snap: true,
          snapSizes: const [0.18, 0.5, 1.0],
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(cornerRadius),
                ),
                boxShadow: isFullscreen
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 10,
                          offset: const Offset(0, -2),
                        ),
                      ],
              ),
              child: Column(
                children: [
                  // Drag handle - fade out when fullscreen
                  Opacity(
                    opacity: isFullscreen ? 0 : 1,
                    child: Center(
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 12),
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ),

                  // Arrivals List
                  Expanded(
                    child: _ArrivalsList(
                      busStopCode: widget.busStopCode,
                      data: widget.data,
                      selectedService: widget.selectedService,
                      onServiceTap: widget.onServiceTap,
                      scrollController: scrollController,
                      isMinimized: currentSize <= 0.2,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

// =============================================================================
// Arrivals List
// =============================================================================

class _ArrivalsList extends ConsumerWidget {
  final String busStopCode;
  final StopArrivalsData data;
  final String? selectedService;
  final ValueChanged<String> onServiceTap;
  final ScrollController scrollController;
  final bool isMinimized;

  const _ArrivalsList({
    required this.busStopCode,
    required this.data,
    required this.selectedService,
    required this.onServiceTap,
    required this.scrollController,
    this.isMinimized = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    if (data.buses.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.directions_bus_outlined,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              'No arrivals',
              style: TextStyle(
                color: colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
    }

    // Natural Sort: Length, Letter, Number
    final sortedBuses = List<BusArrivalInfo>.from(data.buses)
      ..sort((a, b) {
        final sA = a.serviceNo;
        final sB = b.serviceNo;

        // 1. Length
        if (sA.length != sB.length) return sA.length.compareTo(sB.length);

        // 2. Letter part (first char)
        final charA = sA[0];
        final charB = sB[0];
        if (charA != charB) return charA.compareTo(charB);

        // 3. Number part
        final numA = int.tryParse(sA.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        final numB = int.tryParse(sB.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
        if (numA != numB) return numA.compareTo(numB);

        return sA.compareTo(sB);
      });

    // Promotion: Move selected bus to top ONLY when minimized
    if (selectedService != null && isMinimized) {
      final index = sortedBuses.indexWhere(
        (b) => b.serviceNo == selectedService,
      );
      if (index != -1) {
        final selected = sortedBuses.removeAt(index);
        sortedBuses.insert(0, selected);
      }
    }

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(stopArrivalsProvider(busStopCode));
      },
      child: ListView.builder(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        itemCount: sortedBuses.length,
        itemBuilder: (context, index) {
          final arrival = sortedBuses[index];
          return ArrivalTile(
            arrival: arrival,
            isSelected: arrival.serviceNo == selectedService,
            onTap: () => onServiceTap(arrival.serviceNo),
          );
        },
      ),
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
