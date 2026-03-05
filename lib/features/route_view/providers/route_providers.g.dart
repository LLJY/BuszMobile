// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches full route details for a bus service in a given direction.
///
/// [direction] 1 or 2, matching the backend route direction.
/// Auto-disposes when the route view screen is left.

@ProviderFor(serviceRoute)
final serviceRouteProvider = ServiceRouteFamily._();

/// Fetches full route details for a bus service in a given direction.
///
/// [direction] 1 or 2, matching the backend route direction.
/// Auto-disposes when the route view screen is left.

final class ServiceRouteProvider
    extends
        $FunctionalProvider<
          AsyncValue<ServiceRouteData>,
          ServiceRouteData,
          FutureOr<ServiceRouteData>
        >
    with $FutureModifier<ServiceRouteData>, $FutureProvider<ServiceRouteData> {
  /// Fetches full route details for a bus service in a given direction.
  ///
  /// [direction] 1 or 2, matching the backend route direction.
  /// Auto-disposes when the route view screen is left.
  ServiceRouteProvider._({
    required ServiceRouteFamily super.from,
    required (String, int) super.argument,
  }) : super(
         retry: null,
         name: r'serviceRouteProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$serviceRouteHash();

  @override
  String toString() {
    return r'serviceRouteProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ServiceRouteData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ServiceRouteData> create(Ref ref) {
    final argument = this.argument as (String, int);
    return serviceRoute(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is ServiceRouteProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$serviceRouteHash() => r'2e2011e00be71102a4fe1a494934b34477dffd3c';

/// Fetches full route details for a bus service in a given direction.
///
/// [direction] 1 or 2, matching the backend route direction.
/// Auto-disposes when the route view screen is left.

final class ServiceRouteFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ServiceRouteData>, (String, int)> {
  ServiceRouteFamily._()
    : super(
        retry: null,
        name: r'serviceRouteProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches full route details for a bus service in a given direction.
  ///
  /// [direction] 1 or 2, matching the backend route direction.
  /// Auto-disposes when the route view screen is left.

  ServiceRouteProvider call(String serviceNo, int direction) =>
      ServiceRouteProvider._(argument: (serviceNo, direction), from: this);

  @override
  String toString() => r'serviceRouteProvider';
}
