/// Settings screen for configuring data fetching behaviour.
///
/// Options:
/// - Data mode: streaming (server push) vs polling (periodic fetch)
/// - Polling interval: 5s, 10s, 15s, 30s, 60s
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/local/settings_providers.dart';
import '../../../data/local/settings_store.dart';

// =============================================================================
// Settings Screen
// =============================================================================

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const _pollingOptions = [5, 10, 15, 30, 60];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final notifier = ref.read(appSettingsProvider.notifier);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // ---------------------------------------------------------------
          // Data Mode Section
          // ---------------------------------------------------------------
          const _SectionHeader(title: 'Data Fetching'),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: SegmentedButton<DataMode>(
              segments: const [
                ButtonSegment(
                  value: DataMode.streaming,
                  label: Text('Streaming'),
                  icon: Icon(Icons.stream),
                ),
                ButtonSegment(
                  value: DataMode.polling,
                  label: Text('Polling'),
                  icon: Icon(Icons.sync),
                ),
              ],
              selected: {settings.dataMode},
              onSelectionChanged: (selection) {
                notifier.setDataMode(selection.first);
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              settings.dataMode == DataMode.streaming
                  ? 'Real-time updates via server-streaming RPC. '
                        'Falls back to polling on connection failure.'
                  : 'Fetches arrivals at a fixed interval. '
                        'Uses less battery but data may be stale.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ---------------------------------------------------------------
          // Polling Interval Section
          // ---------------------------------------------------------------
          const _SectionHeader(title: 'Polling Interval'),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: _pollingOptions.map((seconds) {
                final isSelected = settings.pollingIntervalSeconds == seconds;
                return ChoiceChip(
                  label: Text('${seconds}s'),
                  selected: isSelected,
                  onSelected: (_) {
                    notifier.setPollingInterval(seconds);
                  },
                );
              }).toList(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              settings.dataMode == DataMode.streaming
                  ? 'Used as fallback interval when streaming is unavailable.'
                  : 'Arrivals refresh every ${settings.pollingIntervalSeconds} seconds.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),

          const Divider(height: 32),

          // ---------------------------------------------------------------
          // Connection Info
          // ---------------------------------------------------------------
          const _SectionHeader(title: 'Connection'),

          ListTile(
            leading: Icon(Icons.info_outline, color: colorScheme.primary),
            title: const Text('Auto-retry'),
            subtitle: Text(
              'Connection errors (e.g. HTTP/2 termination) are automatically '
              'retried with exponential backoff up to 30 seconds.',
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// Section Header
// =============================================================================

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
