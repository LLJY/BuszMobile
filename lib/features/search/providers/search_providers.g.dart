// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Singleton FrontlineService instance shared across the app.

@ProviderFor(frontlineService)
final frontlineServiceProvider = FrontlineServiceProvider._();

/// Singleton FrontlineService instance shared across the app.

final class FrontlineServiceProvider
    extends
        $FunctionalProvider<
          FrontlineServiceBase,
          FrontlineServiceBase,
          FrontlineServiceBase
        >
    with $Provider<FrontlineServiceBase> {
  /// Singleton FrontlineService instance shared across the app.
  FrontlineServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'frontlineServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$frontlineServiceHash();

  @$internal
  @override
  $ProviderElement<FrontlineServiceBase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FrontlineServiceBase create(Ref ref) {
    return frontlineService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FrontlineServiceBase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FrontlineServiceBase>(value),
    );
  }
}

String _$frontlineServiceHash() => r'b9415e0f6655efbe62c038af029033d77c4a93dd';

/// The current search query text.

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

/// The current search query text.
final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  /// The current search query text.
  SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'446383cb599327bea368f8da496260b05a5f9bec';

/// The current search query text.

abstract class _$SearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Debounced search results.
///
/// Watches [searchQueryProvider] and fetches results with a 300ms debounce.
/// Auto-disposes when no longer listened to (e.g., screen navigated away).

@ProviderFor(searchResults)
final searchResultsProvider = SearchResultsProvider._();

/// Debounced search results.
///
/// Watches [searchQueryProvider] and fetches results with a 300ms debounce.
/// Auto-disposes when no longer listened to (e.g., screen navigated away).

final class SearchResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<BusStopSearchResult>>,
          List<BusStopSearchResult>,
          FutureOr<List<BusStopSearchResult>>
        >
    with
        $FutureModifier<List<BusStopSearchResult>>,
        $FutureProvider<List<BusStopSearchResult>> {
  /// Debounced search results.
  ///
  /// Watches [searchQueryProvider] and fetches results with a 300ms debounce.
  /// Auto-disposes when no longer listened to (e.g., screen navigated away).
  SearchResultsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchResultsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchResultsHash();

  @$internal
  @override
  $FutureProviderElement<List<BusStopSearchResult>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<BusStopSearchResult>> create(Ref ref) {
    return searchResults(ref);
  }
}

String _$searchResultsHash() => r'e583c9a6d930d535e89fafd90ccbb4ad52fdb296';
