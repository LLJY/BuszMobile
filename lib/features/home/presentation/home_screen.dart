/// Home screen — the app entry point.
///
/// Shows:
/// - Nearby bus stops (mobile only, based on GPS)
/// - Favourite bus stops (always visible)
/// - Search icon in app bar → navigates to search screen
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/local/favourites_providers.dart';
import '../../../data/models/favourite.dart';
import '../../../data/models/models.dart';
import '../providers/home_providers.dart';

// =============================================================================
// Home Screen
// =============================================================================

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  /// Whether the current platform supports GPS location.
  bool get _isMobilePlatform =>
      !kIsWeb &&
      defaultTargetPlatform != TargetPlatform.linux &&
      defaultTargetPlatform != TargetPlatform.macOS &&
      defaultTargetPlatform != TargetPlatform.windows;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouritesAsync = ref.watch(favouritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('BuszMobile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search bus stops',
            onPressed: () => context.push('/search'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // Nearby stops section (mobile only)
          if (_isMobilePlatform) _NearbyStopsSection(),

          // Favourites section (always visible)
          _FavouritesSection(favouritesAsync: favouritesAsync),
        ],
      ),
    );
  }
}

// =============================================================================
// Nearby Stops Section (mobile only)
// =============================================================================

class _NearbyStopsSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final nearbyAsync = ref.watch(nearbyStopsProvider);

    return nearbyAsync.when(
      loading: () => const _LocationLoadingIndicator(),
      error: (_, _) => const SizedBox.shrink(), // Silently skip on error
      data: (stops) {
        if (stops.isEmpty) return const SizedBox.shrink();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _SectionHeader(title: 'Nearby', icon: Icons.near_me),
            SizedBox(
              height: 148,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: stops.length,
                itemBuilder: (context, index) {
                  return _NearbyStopCard(stop: stops[index]);
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        );
      },
    );
  }
}

// =============================================================================
// Pulsing Location Loading Indicator
// =============================================================================

class _LocationLoadingIndicator extends StatefulWidget {
  const _LocationLoadingIndicator();

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
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
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
          const SizedBox(width: 8),
          Text(
            'Finding nearby stops...',
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Nearby Stop Card
// =============================================================================

class _NearbyStopCard extends StatelessWidget {
  final NearbyStop stop;

  const _NearbyStopCard({required this.stop});

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
      padding: const EdgeInsets.only(right: 8),
      child: SizedBox(
        width: 180,
        child: Card.filled(
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => _navigateToStop(context),
            child: Padding(
              padding: const EdgeInsets.all(12),
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
                      const SizedBox(width: 4),
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
                  const SizedBox(height: 8),

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
// Favourites Section
// =============================================================================

class _FavouritesSection extends StatelessWidget {
  final AsyncValue<List<FavouriteStop>> favouritesAsync;

  const _FavouritesSection({required this.favouritesAsync});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SectionHeader(title: 'Favourites', icon: Icons.star),
        favouritesAsync.when(
          loading: () => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (_, _) => const Padding(
            padding: EdgeInsets.all(24),
            child: Center(
              child: Text(
                'Could not load favourites',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ),
          data: (favourites) {
            if (favourites.isEmpty) return const _EmptyFavouritesPrompt();
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: favourites.length,
              itemBuilder: (context, index) {
                return _FavouriteCard(favourite: favourites[index]);
              },
            );
          },
        ),
      ],
    );
  }
}

// =============================================================================
// Empty Favourites Prompt
// =============================================================================

class _EmptyFavouritesPrompt extends StatelessWidget {
  const _EmptyFavouritesPrompt();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.star_border, size: 48, color: Colors.grey[600]),
            const SizedBox(height: 12),
            Text(
              'No favourites yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Tap the star on any stop to add it here',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// Favourite Card
// =============================================================================

class _FavouriteCard extends StatelessWidget {
  final FavouriteStop favourite;

  const _FavouriteCard({required this.favourite});

  @override
  Widget build(BuildContext context) {
    final displayName = favourite.customAlias ?? favourite.busStopName;

    return Card.filled(
      margin: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _navigateToStop(context),
        onLongPress: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Edit mode coming soon'),
              duration: Duration(seconds: 2),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Star icon
              Icon(Icons.star, size: 20, color: Colors.amber[600]),
              const SizedBox(width: 12),

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
                        color: Colors.grey[400],
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
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
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
// Section Header
// =============================================================================

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Mini Service Chip
// =============================================================================

class _MiniServiceChip extends StatelessWidget {
  final String serviceNo;

  const _MiniServiceChip({required this.serviceNo});

  @override
  Widget build(BuildContext context) {
    final color = _serviceColor(serviceNo);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        serviceNo,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Generate a consistent color from service number.
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
