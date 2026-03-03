// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// User's current GPS location (mobile only).
///
/// Returns `null` on desktop/web platforms, or if location services are
/// disabled or permission was denied. Handles denial gracefully.

@ProviderFor(currentLocation)
final currentLocationProvider = CurrentLocationProvider._();

/// User's current GPS location (mobile only).
///
/// Returns `null` on desktop/web platforms, or if location services are
/// disabled or permission was denied. Handles denial gracefully.

final class CurrentLocationProvider
    extends
        $FunctionalProvider<
          AsyncValue<Position?>,
          Position?,
          FutureOr<Position?>
        >
    with $FutureModifier<Position?>, $FutureProvider<Position?> {
  /// User's current GPS location (mobile only).
  ///
  /// Returns `null` on desktop/web platforms, or if location services are
  /// disabled or permission was denied. Handles denial gracefully.
  CurrentLocationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentLocationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentLocationHash();

  @$internal
  @override
  $FutureProviderElement<Position?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Position?> create(Ref ref) {
    return currentLocation(ref);
  }
}

String _$currentLocationHash() => r'7b5960f51b702059335a3819832d37dfcbbe264b';

/// Nearby bus stops based on the user's current GPS location.
///
/// Returns an empty list if location is unavailable (desktop/web, denied, etc).
/// Fetches from the Frontline gRPC API via [FrontlineService.findNearbyStops].

@ProviderFor(nearbyStops)
final nearbyStopsProvider = NearbyStopsProvider._();

/// Nearby bus stops based on the user's current GPS location.
///
/// Returns an empty list if location is unavailable (desktop/web, denied, etc).
/// Fetches from the Frontline gRPC API via [FrontlineService.findNearbyStops].

final class NearbyStopsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<NearbyStop>>,
          List<NearbyStop>,
          FutureOr<List<NearbyStop>>
        >
    with $FutureModifier<List<NearbyStop>>, $FutureProvider<List<NearbyStop>> {
  /// Nearby bus stops based on the user's current GPS location.
  ///
  /// Returns an empty list if location is unavailable (desktop/web, denied, etc).
  /// Fetches from the Frontline gRPC API via [FrontlineService.findNearbyStops].
  NearbyStopsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'nearbyStopsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$nearbyStopsHash();

  @$internal
  @override
  $FutureProviderElement<List<NearbyStop>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<NearbyStop>> create(Ref ref) {
    return nearbyStops(ref);
  }
}

String _$nearbyStopsHash() => r'5920603ee0351c23f7f043cb73b68318b97b0d40';
