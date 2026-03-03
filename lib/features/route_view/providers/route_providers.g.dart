// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches full route details for a bus service.
///
/// Auto-disposes when the route view screen is left.

@ProviderFor(serviceRoute)
final serviceRouteProvider = ServiceRouteFamily._();

/// Fetches full route details for a bus service.
///
/// Auto-disposes when the route view screen is left.

final class ServiceRouteProvider
    extends
        $FunctionalProvider<
          AsyncValue<ServiceRouteData>,
          ServiceRouteData,
          FutureOr<ServiceRouteData>
        >
    with $FutureModifier<ServiceRouteData>, $FutureProvider<ServiceRouteData> {
  /// Fetches full route details for a bus service.
  ///
  /// Auto-disposes when the route view screen is left.
  ServiceRouteProvider._({
    required ServiceRouteFamily super.from,
    required String super.argument,
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
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<ServiceRouteData> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<ServiceRouteData> create(Ref ref) {
    final argument = this.argument as String;
    return serviceRoute(ref, argument);
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

String _$serviceRouteHash() => r'ceffcb62ebb7b8b32b6d48f7e1488a92c44acde7';

/// Fetches full route details for a bus service.
///
/// Auto-disposes when the route view screen is left.

final class ServiceRouteFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<ServiceRouteData>, String> {
  ServiceRouteFamily._()
    : super(
        retry: null,
        name: r'serviceRouteProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches full route details for a bus service.
  ///
  /// Auto-disposes when the route view screen is left.

  ServiceRouteProvider call(String serviceNo) =>
      ServiceRouteProvider._(argument: serviceNo, from: this);

  @override
  String toString() => r'serviceRouteProvider';
}
