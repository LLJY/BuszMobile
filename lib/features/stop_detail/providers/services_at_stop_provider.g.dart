// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'services_at_stop_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fetches all bus services available at a stop.
///
/// Auto-disposes when the stop detail screen is left.
/// This is a one-shot fetch (not polled) since the service list
/// changes infrequently.

@ProviderFor(servicesAtStop)
final servicesAtStopProvider = ServicesAtStopFamily._();

/// Fetches all bus services available at a stop.
///
/// Auto-disposes when the stop detail screen is left.
/// This is a one-shot fetch (not polled) since the service list
/// changes infrequently.

final class ServicesAtStopProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ServiceSummary>>,
          List<ServiceSummary>,
          FutureOr<List<ServiceSummary>>
        >
    with
        $FutureModifier<List<ServiceSummary>>,
        $FutureProvider<List<ServiceSummary>> {
  /// Fetches all bus services available at a stop.
  ///
  /// Auto-disposes when the stop detail screen is left.
  /// This is a one-shot fetch (not polled) since the service list
  /// changes infrequently.
  ServicesAtStopProvider._({
    required ServicesAtStopFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'servicesAtStopProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$servicesAtStopHash();

  @override
  String toString() {
    return r'servicesAtStopProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ServiceSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ServiceSummary>> create(Ref ref) {
    final argument = this.argument as String;
    return servicesAtStop(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ServicesAtStopProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$servicesAtStopHash() => r'e459be6d6211927138dcb079f3925c8265d23045';

/// Fetches all bus services available at a stop.
///
/// Auto-disposes when the stop detail screen is left.
/// This is a one-shot fetch (not polled) since the service list
/// changes infrequently.

final class ServicesAtStopFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ServiceSummary>>, String> {
  ServicesAtStopFamily._()
    : super(
        retry: null,
        name: r'servicesAtStopProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Fetches all bus services available at a stop.
  ///
  /// Auto-disposes when the stop detail screen is left.
  /// This is a one-shot fetch (not polled) since the service list
  /// changes infrequently.

  ServicesAtStopProvider call(String busStopCode) =>
      ServicesAtStopProvider._(argument: busStopCode, from: this);

  @override
  String toString() => r'servicesAtStopProvider';
}
