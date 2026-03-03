// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stop_detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Streams stop arrivals with bus locations via server-streaming RPC.
///
/// Falls back to 15-second polling if the stream fails to connect.
/// Auto-disposes when the stop detail screen is left, stopping the stream
/// or polling loop and freeing network/battery resources.

@ProviderFor(stopArrivals)
final stopArrivalsProvider = StopArrivalsFamily._();

/// Streams stop arrivals with bus locations via server-streaming RPC.
///
/// Falls back to 15-second polling if the stream fails to connect.
/// Auto-disposes when the stop detail screen is left, stopping the stream
/// or polling loop and freeing network/battery resources.

final class StopArrivalsProvider
    extends
        $FunctionalProvider<
          AsyncValue<StopArrivalsData>,
          StopArrivalsData,
          Stream<StopArrivalsData>
        >
    with $FutureModifier<StopArrivalsData>, $StreamProvider<StopArrivalsData> {
  /// Streams stop arrivals with bus locations via server-streaming RPC.
  ///
  /// Falls back to 15-second polling if the stream fails to connect.
  /// Auto-disposes when the stop detail screen is left, stopping the stream
  /// or polling loop and freeing network/battery resources.
  StopArrivalsProvider._({
    required StopArrivalsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stopArrivalsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stopArrivalsHash();

  @override
  String toString() {
    return r'stopArrivalsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<StopArrivalsData> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<StopArrivalsData> create(Ref ref) {
    final argument = this.argument as String;
    return stopArrivals(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StopArrivalsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stopArrivalsHash() => r'e76ac76e7e41049d07652396a0d66db002ad6173';

/// Streams stop arrivals with bus locations via server-streaming RPC.
///
/// Falls back to 15-second polling if the stream fails to connect.
/// Auto-disposes when the stop detail screen is left, stopping the stream
/// or polling loop and freeing network/battery resources.

final class StopArrivalsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<StopArrivalsData>, String> {
  StopArrivalsFamily._()
    : super(
        retry: null,
        name: r'stopArrivalsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Streams stop arrivals with bus locations via server-streaming RPC.
  ///
  /// Falls back to 15-second polling if the stream fails to connect.
  /// Auto-disposes when the stop detail screen is left, stopping the stream
  /// or polling loop and freeing network/battery resources.

  StopArrivalsProvider call(String busStopCode) =>
      StopArrivalsProvider._(argument: busStopCode, from: this);

  @override
  String toString() => r'stopArrivalsProvider';
}

/// The currently selected service number filter on the stop detail screen.
/// null = show all services (no map, full list).
/// Auto-disposes when no longer watched (resets on screen re-entry).

@ProviderFor(SelectedService)
final selectedServiceProvider = SelectedServiceProvider._();

/// The currently selected service number filter on the stop detail screen.
/// null = show all services (no map, full list).
/// Auto-disposes when no longer watched (resets on screen re-entry).
final class SelectedServiceProvider
    extends $NotifierProvider<SelectedService, String?> {
  /// The currently selected service number filter on the stop detail screen.
  /// null = show all services (no map, full list).
  /// Auto-disposes when no longer watched (resets on screen re-entry).
  SelectedServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedServiceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedServiceHash();

  @$internal
  @override
  SelectedService create() => SelectedService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$selectedServiceHash() => r'6286756e5654602c561f09ea0fa29fd6c6253ec0';

/// The currently selected service number filter on the stop detail screen.
/// null = show all services (no map, full list).
/// Auto-disposes when no longer watched (resets on screen re-entry).

abstract class _$SelectedService extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Filtered bus locations for the selected service.
///
/// When a service is selected, returns only bus locations matching that
/// service. When null, returns empty (map not shown).

@ProviderFor(filteredBusLocations)
final filteredBusLocationsProvider = FilteredBusLocationsFamily._();

/// Filtered bus locations for the selected service.
///
/// When a service is selected, returns only bus locations matching that
/// service. When null, returns empty (map not shown).

final class FilteredBusLocationsProvider
    extends
        $FunctionalProvider<
          List<BusLocationInfo>,
          List<BusLocationInfo>,
          List<BusLocationInfo>
        >
    with $Provider<List<BusLocationInfo>> {
  /// Filtered bus locations for the selected service.
  ///
  /// When a service is selected, returns only bus locations matching that
  /// service. When null, returns empty (map not shown).
  FilteredBusLocationsProvider._({
    required FilteredBusLocationsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'filteredBusLocationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$filteredBusLocationsHash();

  @override
  String toString() {
    return r'filteredBusLocationsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<List<BusLocationInfo>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  List<BusLocationInfo> create(Ref ref) {
    final argument = this.argument as String;
    return filteredBusLocations(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<BusLocationInfo> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<BusLocationInfo>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredBusLocationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$filteredBusLocationsHash() =>
    r'9fc899eae598d2dd51737658aace6a1167250ba0';

/// Filtered bus locations for the selected service.
///
/// When a service is selected, returns only bus locations matching that
/// service. When null, returns empty (map not shown).

final class FilteredBusLocationsFamily extends $Family
    with $FunctionalFamilyOverride<List<BusLocationInfo>, String> {
  FilteredBusLocationsFamily._()
    : super(
        retry: null,
        name: r'filteredBusLocationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Filtered bus locations for the selected service.
  ///
  /// When a service is selected, returns only bus locations matching that
  /// service. When null, returns empty (map not shown).

  FilteredBusLocationsProvider call(String busStopCode) =>
      FilteredBusLocationsProvider._(argument: busStopCode, from: this);

  @override
  String toString() => r'filteredBusLocationsProvider';
}
