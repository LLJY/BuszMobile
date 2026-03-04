/// Riverpod providers for app settings.
///
/// Synchronous notifier with defaults — loads persisted values on first
/// access without blocking the UI.
library;

import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'settings_store.dart';

part 'settings_providers.g.dart';

// =============================================================================
// App Settings Provider
// =============================================================================

/// App-wide settings (data mode, polling interval).
///
/// Returns defaults synchronously, then updates once [SharedPreferences]
/// finishes loading. Kept alive for the app's lifetime.
@Riverpod(keepAlive: true)
class AppSettingsNotifier extends _$AppSettingsNotifier {
  final _store = SettingsStore();

  @override
  AppSettings build() {
    _loadFromDisk();
    return const AppSettings();
  }

  /// Reads saved values from disk and applies them.
  Future<void> _loadFromDisk() async {
    try {
      final saved = await _store.load();
      state = saved;
    } catch (e) {
      debugPrint('[Settings] Failed to load: $e');
      // Keep defaults on error
    }
  }

  /// Changes the data fetching mode (streaming or polling).
  Future<void> setDataMode(DataMode mode) async {
    final updated = state.copyWith(dataMode: mode);
    state = updated;
    await _store.save(updated);
  }

  /// Changes the polling interval in seconds.
  Future<void> setPollingInterval(int seconds) async {
    final clamped = seconds.clamp(5, 120);
    final updated = state.copyWith(pollingIntervalSeconds: clamped);
    state = updated;
    await _store.save(updated);
  }
}
