/// Home screen — the app entry point.
///
/// Features:
/// - Unified Search Bar with debounce
/// - Favourites section (always visible)
/// - Nearby stops (mobile only, visible when not searching)
/// - Search results (visible when searching)
/// - Full deduplication: Favourite stops are hidden from Nearby and Search Results.
library;

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/error/error_boundary.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/skeleton_loaders.dart';
import '../../../data/local/favourites_providers.dart';
import '../../../data/local/settings_providers.dart';
import '../../../data/local/settings_store.dart';
import '../../../data/models/favourite.dart';
import '../../../data/models/models.dart';
import '../../search/providers/search_providers.dart';
import '../providers/home_providers.dart';

// =============================================================================
// Home Screen
// =============================================================================

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  bool _isEditMode = false;

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  /// Whether the current platform supports GPS location.
  bool get _isMobilePlatform =>
      !kIsWeb &&
      defaultTargetPlatform != TargetPlatform.linux &&
      defaultTargetPlatform != TargetPlatform.macOS &&
      defaultTargetPlatform != TargetPlatform.windows;

  @override
  Widget build(BuildContext context) {
    final favouritesAsync = ref.watch(favouritesProvider);
    final searchQuery = ref.watch(searchQueryProvider);
    final isSearching = searchQuery.trim().isNotEmpty;

    // Trigger precaching for favourites
    ref.watch(tilePrecacheProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BuszMobile'),
        actions: [
          if (_isEditMode)
            TextButton(
              onPressed: () => setState(() => _isEditMode = false),
              child: const Text('Done'),
            ),
          if (!_isEditMode)
            Consumer(
              builder: (context, ref, _) {
                final settings = ref.watch(appSettingsProvider);
                final isStreaming = settings.dataMode == DataMode.streaming;
                return IconButton(
                  icon: Icon(isStreaming ? Icons.stream : Icons.sync, size: 20),
                  tooltip: isStreaming ? 'Streaming mode' : 'Polling mode',
                  onPressed: () => context.push('/settings'),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Unified Search Bar - hide when editing favourites
          if (!_isEditMode)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search bus stops...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: isSearching
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            ref.read(searchQueryProvider.notifier).update('');
                            _searchFocusNode.unfocus();
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).update(value);
                },
              ),
            ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: AppSpacing.xl),
              children: [
                // Favourites section (always visible)
                _FavouritesSection(
                  favouritesAsync: favouritesAsync,
                  isEditMode: _isEditMode,
                  onEditModeToggle: () => setState(() => _isEditMode = true),
                ),

                if (!isSearching && !_isEditMode) ...[
                  // Nearby stops (mobile only, hidden when searching or editing)
                  if (_isMobilePlatform)
                    _NearbyStopsSection(favouritesAsync: favouritesAsync),
                ] else if (isSearching && !_isEditMode) ...[
                  // Search Results (deduplicated against favourites)
                  _SearchResultsSection(favouritesAsync: favouritesAsync),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Nearby Stops Section (mobile only)
// =============================================================================

class _NearbyStopsSection extends ConsumerWidget {
  final AsyncValue<List<FavouriteStop>> favouritesAsync;

  const _NearbyStopsSection({required this.favouritesAsync, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearbyAsync = ref.watch(nearbyStopsProvider);
    final favCodes =
        favouritesAsync.asData?.value.map((f) => f.busStopCode).toSet() ?? {};

    return nearbyAsync.when(
      loading: () => const _LocationLoadingIndicator(),
      error: (_, _) => const SizedBox.shrink(),
      data: (stops) {
        // Dedup: filter out stops that are already in favourites
        final dedupStops = stops
            .where((s) => !favCodes.contains(s.busStopCode))
            .toList();

        if (dedupStops.isEmpty) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Nearby', icon: Icons.near_me),
            SizedBox(
              height: 148,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                itemCount: dedupStops.length,
                itemBuilder: (context, index) {
                  return _NearbyStopCard(stop: dedupStops[index]);
                },
              ),
            ),
            const SizedBox(height: AppSpacing.s),
          ],
        );
      },
    );
  }
}

// =============================================================================
// Search Results Section
// =============================================================================

class _SearchResultsSection extends ConsumerWidget {
  final AsyncValue<List<FavouriteStop>> favouritesAsync;

  const _SearchResultsSection({required this.favouritesAsync, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final resultsAsync = ref.watch(searchResultsProvider);
    final query = ref.watch(searchQueryProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final favCodes =
        favouritesAsync.asData?.value.map((f) => f.busStopCode).toSet() ?? {};

    return resultsAsync.when(
      data: (stops) {
        // Dedup: filter out results already in favourites
        final dedupStops = stops
            .where((s) => !favCodes.contains(s.busStopCode))
            .toList();

        if (dedupStops.isEmpty) {
          if (query.trim().length < 2) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xxl),
                child: Text(
                  'Type at least 2 characters to search',
                  style: TextStyle(color: colorScheme.onSurfaceVariant),
                ),
              ),
            );
          }
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xxl),
              child: Text(
                'No new stops found',
                style: TextStyle(color: colorScheme.onSurfaceVariant),
              ),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Search Results', icon: Icons.search),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              itemCount: dedupStops.length,
              itemBuilder: (context, index) {
                return _StopListTile(stop: dedupStops[index]);
              },
            ),
          ],
        );
      },
      loading: () => Column(
        children: [
          const _SectionHeader(title: 'Searching...', icon: Icons.search),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            itemCount: 5,
            separatorBuilder: (_, _) => const SizedBox(height: 6),
            itemBuilder: (context, index) => const ArrivalTileSkeleton(),
          ),
        ],
      ),
      error: (error, _) => ErrorBoundary(
        error: error,
        onRetry: () {
          ref.read(searchQueryProvider.notifier).update(query);
        },
      ),
    );
  }
}

// =============================================================================
// Favourites Section
// =============================================================================

class _FavouritesSection extends ConsumerWidget {
  final AsyncValue<List<FavouriteStop>> favouritesAsync;
  final bool isEditMode;
  final VoidCallback onEditModeToggle;

  const _FavouritesSection({
    required this.favouritesAsync,
    required this.isEditMode,
    required this.onEditModeToggle,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Favourites',
          icon: Icons.star,
          trailing: isEditMode
              ? null
              : favouritesAsync.asData?.value.isNotEmpty == true
              ? IconButton(
                  icon: const Icon(Icons.edit, size: 18),
                  onPressed: onEditModeToggle,
                  tooltip: 'Edit favourites',
                )
              : null,
        ),
        favouritesAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.xs,
            ),
            child: Column(
              children: [
                ArrivalTileSkeleton(),
                SizedBox(height: 6),
                ArrivalTileSkeleton(),
                SizedBox(height: 6),
                ArrivalTileSkeleton(),
              ],
            ),
          ),
          error: (_, _) => Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Center(
              child: Text(
                'Could not load favourites',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          data: (favourites) {
            if (favourites.isEmpty) return const _EmptyFavouritesPrompt();

            if (isEditMode) {
              // Create a local copy for the reorderable list
              final localFavs = List<FavouriteStop>.from(favourites);
              return ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                itemCount: localFavs.length,
                onReorder: (oldIndex, newIndex) {
                  if (newIndex > oldIndex) newIndex -= 1;
                  final item = localFavs.removeAt(oldIndex);
                  localFavs.insert(newIndex, item);
                  unawaited(
                    ref
                        .read(favouritesProvider.notifier)
                        .reorder(localFavs.map((f) => f.busStopCode).toList()),
                  );
                },
                itemBuilder: (context, index) {
                  return _FavouriteEditCard(
                    key: ValueKey(localFavs[index].busStopCode),
                    favourite: localFavs[index],
                  );
                },
              );
            }

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              itemCount: favourites.length,
              itemBuilder: (context, index) {
                return _FavouriteCard(
                  favourite: favourites[index],
                  onLongPress: onEditModeToggle,
                );
              },
            );
          },
        ),
      ],
    );
  }
}

// =============================================================================
// Favourite Edit Card
// =============================================================================

class _FavouriteEditCard extends ConsumerWidget {
  final FavouriteStop favourite;

  const _FavouriteEditCard({required this.favourite, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card.filled(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: IconButton(
          icon: const Icon(Icons.remove_circle, color: Colors.red),
          onPressed: () => ref
              .read(favouritesProvider.notifier)
              .remove(favourite.busStopCode),
        ),
        title: Text(
          favourite.customAlias ?? favourite.busStopName,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        subtitle: Text(
          favourite.busStopCode,
          style: const TextStyle(fontSize: 12),
        ),
        trailing: const Icon(Icons.drag_handle),
        onTap: () async {
          final newAlias = await _showRenameDialog(context, favourite);
          if (newAlias != null) {
            ref
                .read(favouritesProvider.notifier)
                .rename(
                  favourite.busStopCode,
                  newAlias.isEmpty ? null : newAlias,
                );
          }
        },
      ),
    );
  }

  Future<String?> _showRenameDialog(BuildContext context, FavouriteStop stop) {
    final controller = TextEditingController(text: stop.customAlias);
    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rename Favourite'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter custom name',
            labelText: 'Nickname',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Stop List Tile
// =============================================================================

class _StopListTile extends StatelessWidget {
  final BusStopSearchResult stop;

  const _StopListTile({required this.stop, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Hero(
      tag: 'stop_${stop.busStopCode}',
      child: Material(
        type: MaterialType.transparency,
        child: ListTile(
          title: Text(
            stop.busStopName,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                stop.busStopCode,
                style: TextStyle(
                  color: colorScheme.outline,
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
              ),
              if (stop.serviceNos.isNotEmpty) ...[
                const SizedBox(height: 6),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: stop.serviceNos.map((serviceNo) {
                    return _MiniServiceChip(serviceNo: serviceNo);
                  }).toList(),
                ),
              ],
            ],
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 4,
          ),
          onTap: () {
            final params = <String, String>{'name': stop.busStopName};
            if (stop.latitude != null) {
              params['lat'] = stop.latitude.toString();
            }
            if (stop.longitude != null) {
              params['lng'] = stop.longitude.toString();
            }
            final query = params.entries
                .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
                .join('&');
            context.push('/stop/${stop.busStopCode}?$query');
          },
        ),
      ),
    );
  }
}

// =============================================================================
// Nearby Stop Card
// =============================================================================

class _NearbyStopCard extends StatelessWidget {
  final NearbyStop stop;

  const _NearbyStopCard({required this.stop, super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Format distance
    final distanceLabel = stop.distanceMeters < 1000
        ? '${stop.distanceMeters.round()}m'
        : '${(stop.distanceMeters / 1000).toStringAsFixed(1)}km';

    // Format next ETA
    String? etaLabel;
    if (stop.nextArrival != null) {
      final minutes = stop.nextArrival!.time
          .difference(DateTime.now())
          .inMinutes;
      etaLabel = minutes <= 0 ? 'Arr' : '${minutes}min';
    }

    return Padding(
      padding: const EdgeInsets.only(right: AppSpacing.s),
      child: SizedBox(
        width: 180,
        child: Hero(
          tag: 'stop_${stop.busStopCode}',
          child: Card.filled(
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => _navigateToStop(context),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Distance badge
                    Row(
                      children: [
                        Icon(
                          Icons.directions_walk,
                          size: 14,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          distanceLabel,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.primary,
                          ),
                        ),
                        const Spacer(),
                        if (etaLabel != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              etaLabel,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.s),

                    // Stop name
                    Text(
                      stop.busStopName,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                    const Spacer(),

                    // Service chips
                    if (stop.serviceNos.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        runSpacing: 2,
                        children: stop.serviceNos.take(4).map((serviceNo) {
                          return _MiniServiceChip(serviceNo: serviceNo);
                        }).toList(),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToStop(BuildContext context) {
    final params = <String, String>{'name': stop.busStopName};
    if (stop.latitude != 0) params['lat'] = stop.latitude.toString();
    if (stop.longitude != 0) params['lng'] = stop.longitude.toString();
    final query = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');
    context.push('/stop/${stop.busStopCode}?$query');
  }
}

// =============================================================================
// Favourite Card
// =============================================================================

class _FavouriteCard extends StatelessWidget {
  final FavouriteStop favourite;
  final VoidCallback onLongPress;

  const _FavouriteCard({
    required this.favourite,
    required this.onLongPress,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final displayName = favourite.customAlias ?? favourite.busStopName;

    return Hero(
      tag: 'stop_${favourite.busStopCode}',
      child: Card.filled(
        margin: const EdgeInsets.only(bottom: 6),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => _navigateToStop(context),
          onLongPress: onLongPress,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Row(
              children: [
                // Star icon
                Icon(Icons.star, size: 20, color: Colors.amber[600]),
                const SizedBox(width: AppSpacing.m),

                // Stop info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        displayName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        favourite.busStopCode,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.outline,
                          fontFamily: 'monospace',
                        ),
                      ),
                      if (favourite.serviceNos.isNotEmpty) ...[
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 4,
                          runSpacing: 2,
                          children: favourite.serviceNos.map((serviceNo) {
                            return _MiniServiceChip(serviceNo: serviceNo);
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
                ),

                // Chevron
                Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToStop(BuildContext context) {
    final params = <String, String>{'name': favourite.busStopName};
    if (favourite.latitude != null) {
      params['lat'] = favourite.latitude.toString();
    }
    if (favourite.longitude != null) {
      params['lng'] = favourite.longitude.toString();
    }
    final query = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');
    context.push('/stop/${favourite.busStopCode}?$query');
  }
}

// =============================================================================
// Helper Widgets
// =============================================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;

  const _SectionHeader({
    required this.title,
    required this.icon,
    this.trailing,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.s,
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: AppSpacing.s),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          const Spacer(),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class _MiniServiceChip extends StatelessWidget {
  final String serviceNo;

  const _MiniServiceChip({required this.serviceNo, super.key});

  @override
  Widget build(BuildContext context) {
    final baseColor = _serviceColor(serviceNo);
    final theme = Theme.of(context);

    // M3 API: Generate a localized ColorScheme for this service color.
    // This ensures that the container and text colors always have
    // accessible contrast regardless of the bus service's color.
    final serviceScheme = ColorScheme.fromSeed(
      seedColor: baseColor,
      brightness: theme.brightness,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: serviceScheme.secondaryContainer.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: serviceScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        serviceNo,
        style: TextStyle(
          color: serviceScheme.onSecondaryContainer,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  static Color _serviceColor(String serviceNo) {
    const colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.teal,
      Colors.pink,
      Colors.cyan,
      Colors.amber,
      Colors.indigo,
      Colors.red,
    ];
    final hash = serviceNo.hashCode.abs();
    return colors[hash % colors.length];
  }
}

class _LocationLoadingIndicator extends StatefulWidget {
  const _LocationLoadingIndicator({super.key});

  @override
  State<_LocationLoadingIndicator> createState() =>
      _LocationLoadingIndicatorState();
}

class _LocationLoadingIndicatorState extends State<_LocationLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.4,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.l),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _animation.value,
                    child: Icon(
                      Icons.gps_fixed,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  );
                },
              ),
              const SizedBox(width: AppSpacing.s),
              Text(
                'Finding nearby stops...',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          SizedBox(
            height: 148,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              itemCount: 3,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.s),
              itemBuilder: (context, index) => const NearbyStopCardSkeleton(),
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyFavouritesPrompt extends StatelessWidget {
  const _EmptyFavouritesPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xxl,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star_border,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              'No favourites yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: colorScheme.outline,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Tap the star on any stop to add it here',
              style: TextStyle(
                fontSize: 13,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
