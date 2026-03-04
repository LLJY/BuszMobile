// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// App-wide settings (data mode, polling interval).
///
/// Returns defaults synchronously, then updates once [SharedPreferences]
/// finishes loading. Kept alive for the app's lifetime.

@ProviderFor(AppSettingsNotifier)
final appSettingsProvider = AppSettingsNotifierProvider._();

/// App-wide settings (data mode, polling interval).
///
/// Returns defaults synchronously, then updates once [SharedPreferences]
/// finishes loading. Kept alive for the app's lifetime.
final class AppSettingsNotifierProvider
    extends $NotifierProvider<AppSettingsNotifier, AppSettings> {
  /// App-wide settings (data mode, polling interval).
  ///
  /// Returns defaults synchronously, then updates once [SharedPreferences]
  /// finishes loading. Kept alive for the app's lifetime.
  AppSettingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appSettingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appSettingsNotifierHash();

  @$internal
  @override
  AppSettingsNotifier create() => AppSettingsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppSettings>(value),
    );
  }
}

String _$appSettingsNotifierHash() =>
    r'8c883b190ff000fa82d69880516c53d75395a005';

/// App-wide settings (data mode, polling interval).
///
/// Returns defaults synchronously, then updates once [SharedPreferences]
/// finishes loading. Kept alive for the app's lifetime.

abstract class _$AppSettingsNotifier extends $Notifier<AppSettings> {
  AppSettings build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AppSettings, AppSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppSettings, AppSettings>,
              AppSettings,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
