/// Stop detail screen showing arrivals and live bus map.
///
/// Layout:
/// - No service selected: full-screen arrival list
/// - Service tapped: split view with map (top) + arrivals (bottom sheet)
///
/// Polls GetStopArrivals every 15s with include_bus_locations=true.
library;

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding, SchedulerPhase;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:latlong2/latlong.dart';

import '../../../core/error/error_boundary.dart';
import '../../../core/map/polyline_parser.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/skeleton_loaders.dart';
import '../../../data/local/favourites_providers.dart';
import '../../../data/models/favourite.dart';
import '../../../data/models/models.dart';
import '../../route_view/providers/route_providers.dart';
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
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              itemCount: 4,
              separatorBuilder: (_, _) => const SizedBox(height: 6),
              itemBuilder: (context, index) => const ArrivalTileSkeleton(),
            ),
            error: (error, stack) => ErrorBoundary(
              error: error,
              onRetry: () => ref.invalidate(stopArrivalsProvider(busStopCode)),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================================
// Body: Map + Arrivals (responsive: sidebar on wide, sheet on narrow)
// =============================================================================

/// Widescreen breakpoint: above this width, show a sidebar instead of a sheet.
const double _kWidescreenBreakpoint = 840;

class _StopDetailBody extends ConsumerStatefulWidget {
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
  ConsumerState<_StopDetailBody> createState() => _StopDetailBodyState();
}

class _StopDetailBodyState extends ConsumerState<_StopDetailBody> {
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  // Cached parsed route data — avoids re-parsing on every rebuild.
  String? _cachedPolylineSource;
  List<LatLng> _cachedPolylinePoints = const [];
  Color _cachedPolylineColor = Colors.blue;
  List<StopOnRoute> _cachedRouteStops = const [];

  /// Monotonically increasing version counter for polyline parse requests.
  /// Guards against stale futures overwriting newer selections.
  int _parseVersion = 0;

  /// Current sheet fraction (0–1) for computing map bottom inset.
  /// Defaults to 0.5 — the snap target when a service is first selected.
  double _narrowSheetFraction = 0.5;

  @override
  void initState() {
    super.initState();
    _sheetController.addListener(_onSheetFractionChanged);
  }

  @override
  void didUpdateWidget(covariant _StopDetailBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When a service is newly selected, the sheet will animate to 0.5.
    // Reset the fraction so the initial map fit uses the correct inset.
    if (widget.selectedService != null && oldWidget.selectedService == null) {
      _narrowSheetFraction = 0.5;
    }
  }

  @override
  void dispose() {
    _sheetController.removeListener(_onSheetFractionChanged);
    _sheetController.dispose();
    super.dispose();
  }

  /// Track sheet position changes. Only triggers a rebuild on significant
  /// movements (>15% of screen height) to avoid re-fitting during drags
  /// while still responding to snap-point transitions (0.18 ↔ 0.5).
  void _onSheetFractionChanged() {
    if (!_sheetController.isAttached) return;
    final size = _sheetController.size;
    if ((size - _narrowSheetFraction).abs() > 0.15) {
      _safeSetState(() => _narrowSheetFraction = size);
    }
  }

  /// Defer [setState] when called during the build/layout phase
  /// (e.g. DraggableScrollableSheet.didUpdateWidget → _replaceExtent).
  void _safeSetState(VoidCallback fn) {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(fn);
      });
    } else {
      setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show either the selected service buses, or ALL buses for this stop
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

    // Determine direction from arrival data for the selected service.
    final selectedBus = widget.selectedService != null
        ? widget.data.buses.cast<BusArrivalInfo?>().firstWhere(
            (bus) => bus!.serviceNo == widget.selectedService,
            orElse: () => null,
          )
        : null;
    final selectedDirection = selectedBus?.direction ?? 1;

    // Load route data when a service is selected (parse only when data changes)
    if (widget.selectedService != null) {
      final routeAsync = ref.watch(
        serviceRouteProvider(widget.selectedService!, selectedDirection),
      );
      routeAsync.whenData((data) {
        if (data.encodedPolyline != _cachedPolylineSource) {
          _cachedPolylineSource = data.encodedPolyline;
          _cachedPolylineColor = AppTheme.parseHexColor(data.color);
          _cachedRouteStops = data.stops;
          // Parse polyline off the main thread, then rebuild.
          // Version guard: ignore results from stale parse requests.
          final version = ++_parseVersion;
          parsePolyline(data.encodedPolyline).then((points) {
            if (mounted && version == _parseVersion) {
              setState(() => _cachedPolylinePoints = points);
            }
          });
        }
      });
    } else if (_cachedPolylineSource != null) {
      _cachedPolylineSource = null;
      _cachedPolylinePoints = const [];
      _cachedPolylineColor = Colors.blue;
      _cachedRouteStops = const [];
    }

    final isWide = MediaQuery.sizeOf(context).width >= _kWidescreenBreakpoint;

    // Bottom inset for the map camera: in narrow layout the arrivals sheet
    // occludes the lower portion, so fitBounds must add extra bottom padding
    // to keep the route/stops visible above the sheet.
    final mapBottomInset = (!isWide && widget.selectedService != null)
        ? _narrowSheetFraction * MediaQuery.sizeOf(context).height
        : 0.0;

    final map = BusMap(
      busLocations: locations,
      stopLocation: stopLocation,
      plateEtaMinutes: plateEtaMap,
      polylinePoints: _cachedPolylinePoints,
      polylineColor: _cachedPolylineColor,
      routeStops: _cachedRouteStops,
      currentStopCode: widget.busStopCode,
      bottomInset: mapBottomInset,
    );

    if (isWide) {
      return _WidescreenLayout(
        busStopCode: widget.busStopCode,
        data: widget.data,
        selectedService: widget.selectedService,
        selectedDirection: selectedDirection,
        onServiceTap: widget.onServiceTap,
        map: map,
      );
    }

    return _NarrowLayout(
      sheetController: _sheetController,
      busStopCode: widget.busStopCode,
      data: widget.data,
      selectedService: widget.selectedService,
      selectedDirection: selectedDirection,
      onServiceTap: widget.onServiceTap,
      map: map,
    );
  }
}

// =============================================================================
// Narrow Layout (mobile): Map + DraggableScrollableSheet overlay
// =============================================================================

class _NarrowLayout extends StatefulWidget {
  final DraggableScrollableController sheetController;
  final String busStopCode;
  final StopArrivalsData data;
  final String? selectedService;
  final int selectedDirection;
  final ValueChanged<String> onServiceTap;
  final Widget map;

  const _NarrowLayout({
    required this.sheetController,
    required this.busStopCode,
    required this.data,
    required this.selectedService,
    required this.selectedDirection,
    required this.onServiceTap,
    required this.map,
  });

  @override
  State<_NarrowLayout> createState() => _NarrowLayoutState();
}

class _NarrowLayoutState extends State<_NarrowLayout> {
  double _sheetSize = 1.0;

  @override
  void initState() {
    super.initState();
    widget.sheetController.addListener(_onSheetChanged);
  }

  @override
  void dispose() {
    widget.sheetController.removeListener(_onSheetChanged);
    super.dispose();
  }

  void _onSheetChanged() {
    if (!widget.sheetController.isAttached) return;
    final size = widget.sheetController.size;
    if ((size - _sheetSize).abs() > 0.01) {
      _safeSetState(() => _sheetSize = size);
    }
  }

  /// Defer [setState] when called during the build/layout phase
  /// (e.g. DraggableScrollableSheet.didUpdateWidget → _replaceExtent).
  void _safeSetState(VoidCallback fn) {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(fn);
      });
    } else {
      setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool fabVisible = widget.selectedService != null && _sheetSize > 0.25;

    return Stack(
      children: [
        // Only render the map when a service is selected; otherwise the
        // arrivals sheet covers the entire screen and the map is wasted work.
        if (widget.selectedService != null)
          widget.map
        else
          const SizedBox.shrink(),

        _ArrivalsSheet(
          controller: widget.sheetController,
          busStopCode: widget.busStopCode,
          data: widget.data,
          selectedService: widget.selectedService,
          onServiceTap: widget.onServiceTap,
        ),

        // FAB for route view
        AnimatedPositioned(
          duration: const Duration(milliseconds: 200),
          right: 16,
          bottom: fabVisible ? 16 : -80,
          child: FloatingActionButton.small(
            heroTag: null,
            tooltip: 'View full route',
            onPressed: () {
              context.push(
                '/route/${widget.selectedService}?highlight=${widget.busStopCode}&dir=${widget.selectedDirection}',
              );
            },
            child: const Icon(Icons.route),
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// Widescreen Layout (desktop): Map (left) + Sidebar (right)
// =============================================================================

class _WidescreenLayout extends StatefulWidget {
  final String busStopCode;
  final StopArrivalsData data;
  final String? selectedService;
  final int selectedDirection;
  final ValueChanged<String> onServiceTap;
  final Widget map;

  const _WidescreenLayout({
    required this.busStopCode,
    required this.data,
    required this.selectedService,
    required this.selectedDirection,
    required this.onServiceTap,
    required this.map,
  });

  @override
  State<_WidescreenLayout> createState() => _WidescreenLayoutState();
}

class _WidescreenLayoutState extends State<_WidescreenLayout> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      children: [
        // Map takes remaining space
        Expanded(
          child: Stack(
            children: [
              widget.map,

              // FAB for route view
              if (widget.selectedService != null)
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: FloatingActionButton.small(
                    heroTag: null,
                    tooltip: 'View full route',
                    onPressed: () {
                      context.push(
                        '/route/${widget.selectedService}?highlight=${widget.busStopCode}&dir=${widget.selectedDirection}',
                      );
                    },
                    child: const Icon(Icons.route),
                  ),
                ),
            ],
          ),
        ),

        // Sidebar
        Container(
          width: 360,
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            border: Border(left: BorderSide(color: colorScheme.outlineVariant)),
          ),
          child: _ArrivalsList(
            busStopCode: widget.busStopCode,
            data: widget.data,
            selectedService: widget.selectedService,
            onServiceTap: widget.onServiceTap,
            scrollController: _scrollController,
          ),
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
  bool _isHoldingAtMid = false;
  double _currentSize = 1.0;

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

  /// Defer [setState] when called during the build/layout phase
  /// (e.g. DraggableScrollableSheet.didUpdateWidget → _replaceExtent).
  void _safeSetState(VoidCallback fn) {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(fn);
      });
    } else {
      setState(fn);
    }
  }

  void _onScroll() {
    if (_isUnselecting || !widget.controller.isAttached) return;

    final size = widget.controller.size;

    // Track current size for UI (corner radius, fullscreen, minimized)
    if ((size - _currentSize).abs() > 0.01) {
      _safeSetState(() => _currentSize = size);
    }

    // If the sheet hits 50%, enable the "holding" state.
    if (size >= 0.49 && size <= 0.51 && !_isHoldingAtMid) {
      _safeSetState(() => _isHoldingAtMid = true);
    }

    // Release the hold if we move significantly away from 50%
    if ((size < 0.45 || size > 0.55) && _isHoldingAtMid) {
      _safeSetState(() => _isHoldingAtMid = false);
    }

    // Unselect logic: If dragged to the very top (1.0), dismiss map/selection.
    if (widget.selectedService != null && size >= 0.99) {
      _isUnselecting = true;
      Future.microtask(() {
        widget.onServiceTap(widget.selectedService!);
        _isUnselecting = false;
        _isHoldingAtMid = false;
      });
    }
  }

  @override
  void didUpdateWidget(_ArrivalsSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Service selected: snap sheet to 50%
    if (widget.selectedService != null && oldWidget.selectedService == null) {
      if (widget.controller.isAttached) {
        _isHoldingAtMid = false;

        widget.controller
            .animateTo(
              0.5,
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutCubic,
            )
            .then((_) {
              // _onScroll listener catches 0.5 and sets _isHoldingAtMid.
            });
      }
    }
    // Service deselected: reset hold state
    if (widget.selectedService == null && oldWidget.selectedService != null) {
      _isHoldingAtMid = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isFullscreen = _currentSize >= 0.95;
    final double cornerRadius = isFullscreen ? 0 : 20;

    // Mid-point Scroll Lock:
    // Set maxChildSize to 0.5 so the list scrolls internally at mid-point.
    final double maxChildSize =
        (widget.selectedService != null && _isHoldingAtMid) ? 0.5 : 1.0;

    const double minChildSize = 0.18;
    final double initialChildSize = maxChildSize;

    return DraggableScrollableSheet(
      controller: widget.controller,
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      snap: true,
      snapSizes: const [0.18, 0.5],
      builder: (context, scrollController) {
        return NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            // When held at 50% and the user scrolled to the bottom,
            // unlock maxChildSize and animate to fullscreen.
            if (notification is ScrollEndNotification && _isHoldingAtMid) {
              final metrics = notification.metrics;
              if (metrics.maxScrollExtent > 0 &&
                  metrics.pixels >= metrics.maxScrollExtent) {
                setState(() => _isHoldingAtMid = false);
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (widget.controller.isAttached) {
                    widget.controller.animateTo(
                      1.0,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                    );
                  }
                });
              }
            }
            return false;
          },
          child: Container(
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
                // Drag handle
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 12, bottom: 20),
                  child: Opacity(
                    opacity: isFullscreen ? 0 : 1,
                    child: Center(
                      child: Container(
                        width: 36,
                        height: 4,
                        decoration: BoxDecoration(
                          color: colorScheme.outlineVariant,
                          borderRadius: BorderRadius.circular(2),
                        ),
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
                    isMinimized: _currentSize <= 0.2,
                  ),
                ),
              ],
            ),
          ),
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
        physics:
            const ClampingScrollPhysics(), // Important for boundary detection
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
