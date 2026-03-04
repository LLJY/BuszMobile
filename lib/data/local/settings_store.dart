/// Local persistence for app settings.
///
/// Stores data mode (streaming vs polling) and polling frequency
/// using [SharedPreferences].
library;

import 'package:shared_preferences/shared_preferences.dart';

// =============================================================================
// Data Mode Enum
// =============================================================================

/// How the app fetches stop arrival data.
enum DataMode {
  /// Server-streaming RPC — real-time push updates.
  streaming,

  /// Periodic unary RPC calls at a configurable interval.
  polling,
}

// =============================================================================
// App Settings Model
// =============================================================================

/// Immutable settings snapshot.
class AppSettings {
  /// How stop arrivals are fetched.
  final DataMode dataMode;

  /// Polling interval in seconds (only used when [dataMode] is [DataMode.polling]).
  final int pollingIntervalSeconds;

  const AppSettings({
    this.dataMode = DataMode.streaming,
    this.pollingIntervalSeconds = 15,
  });

  AppSettings copyWith({DataMode? dataMode, int? pollingIntervalSeconds}) {
    return AppSettings(
      dataMode: dataMode ?? this.dataMode,
      pollingIntervalSeconds:
          pollingIntervalSeconds ?? this.pollingIntervalSeconds,
    );
  }

  @override
  String toString() =>
      'AppSettings(dataMode: $dataMode, pollingInterval: ${pollingIntervalSeconds}s)';
}

// =============================================================================
// Settings Store
// =============================================================================

/// Persists [AppSettings] to [SharedPreferences].
class SettingsStore {
  static const _dataModeKey = 'settings_data_mode';
  static const _pollingIntervalKey = 'settings_polling_interval_seconds';

  /// Loads saved settings, falling back to defaults for missing keys.
  Future<AppSettings> load() async {
    final prefs = await SharedPreferences.getInstance();
    final modeStr = prefs.getString(_dataModeKey);
    final interval = prefs.getInt(_pollingIntervalKey);

    return AppSettings(
      dataMode: modeStr == 'polling' ? DataMode.polling : DataMode.streaming,
      pollingIntervalSeconds: interval ?? 15,
    );
  }

  /// Persists the given settings.
  Future<void> save(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_dataModeKey, settings.dataMode.name);
    await prefs.setInt(_pollingIntervalKey, settings.pollingIntervalSeconds);
  }
}
