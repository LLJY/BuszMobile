/// Search screen for finding bus stops by name or code.
///
/// Features:
/// - SearchBar with 300ms debounce
/// - ListView of results with colored service chips
/// - Tap to navigate to stop detail screen
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/models/models.dart';
import '../providers/search_providers.dart';

// =============================================================================
// Search Screen
// =============================================================================

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(searchResultsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('BuszMobile')),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              autofocus: true,
              decoration: const InputDecoration(
                hintText: 'Search bus stops...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).update(value);
              },
            ),
          ),

          // Results
          Expanded(
            child: results.when(
              data: (stops) {
                if (stops.isEmpty) {
                  final query = ref.read(searchQueryProvider);
                  if (query.trim().length < 2) {
                    return const Center(
                      child: Text(
                        'Type at least 2 characters to search',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }
                  return const Center(
                    child: Text(
                      'No stops found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: stops.length,
                  itemBuilder: (context, index) {
                    return _StopListTile(stop: stops[index]);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 48,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Search failed',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        error.toString(),
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
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

  const _StopListTile({required this.stop});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        stop.busStopName,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            stop.busStopCode,
            style: TextStyle(
              color: Colors.grey[400],
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
                return _ServiceChip(serviceNo: serviceNo);
              }).toList(),
            ),
          ],
        ],
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
    );
  }
}

// =============================================================================
// Service Chip
// =============================================================================

class _ServiceChip extends StatelessWidget {
  final String serviceNo;

  const _ServiceChip({required this.serviceNo});

  @override
  Widget build(BuildContext context) {
    // Use a hash-based color for variety
    final color = _serviceColor(serviceNo);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        serviceNo,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Generate a consistent color from service number.
  Color _serviceColor(String serviceNo) {
    final colors = [
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
