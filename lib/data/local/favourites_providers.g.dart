// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favourites_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Singleton [FavouritesStore] instance for local persistence.

@ProviderFor(favouritesStore)
final favouritesStoreProvider = FavouritesStoreProvider._();

/// Singleton [FavouritesStore] instance for local persistence.

final class FavouritesStoreProvider
    extends
        $FunctionalProvider<FavouritesStore, FavouritesStore, FavouritesStore>
    with $Provider<FavouritesStore> {
  /// Singleton [FavouritesStore] instance for local persistence.
  FavouritesStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favouritesStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favouritesStoreHash();

  @$internal
  @override
  $ProviderElement<FavouritesStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FavouritesStore create(Ref ref) {
    return favouritesStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FavouritesStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FavouritesStore>(value),
    );
  }
}

String _$favouritesStoreHash() => r'3cd54c514e93aa6ce171e2b5a5d5efffb30339d1';

/// Async notifier that manages the user's favourite bus stops.
///
/// Provides CRUD operations and reordering, backed by [FavouritesStore].

@ProviderFor(Favourites)
final favouritesProvider = FavouritesProvider._();

/// Async notifier that manages the user's favourite bus stops.
///
/// Provides CRUD operations and reordering, backed by [FavouritesStore].
final class FavouritesProvider
    extends $AsyncNotifierProvider<Favourites, List<FavouriteStop>> {
  /// Async notifier that manages the user's favourite bus stops.
  ///
  /// Provides CRUD operations and reordering, backed by [FavouritesStore].
  FavouritesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favouritesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favouritesHash();

  @$internal
  @override
  Favourites create() => Favourites();
}

String _$favouritesHash() => r'21ffd3af85e3c3aaf9eed6ff25689f2bb2dce289';

/// Async notifier that manages the user's favourite bus stops.
///
/// Provides CRUD operations and reordering, backed by [FavouritesStore].

abstract class _$Favourites extends $AsyncNotifier<List<FavouriteStop>> {
  FutureOr<List<FavouriteStop>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<FavouriteStop>>, List<FavouriteStop>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<FavouriteStop>>, List<FavouriteStop>>,
              AsyncValue<List<FavouriteStop>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(tilePrecache)
final tilePrecacheProvider = TilePrecacheProvider._();

final class TilePrecacheProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  TilePrecacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tilePrecacheProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tilePrecacheHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return tilePrecache(ref);
  }
}

String _$tilePrecacheHash() => r'915888594bdc3a8dd89af04b52f268ab8d4837d4';
