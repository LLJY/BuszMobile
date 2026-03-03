import 'package:busz_mobile/data/local/favourites_store.dart';
import 'package:busz_mobile/data/models/favourite.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late FavouritesStore store;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    store = FavouritesStore();
  });

  FavouriteStop makeStop({
    required String code,
    String name = 'Test Stop',
    int sortOrder = 0,
    String? alias,
    List<String> serviceNos = const ['10', '20'],
  }) {
    return FavouriteStop(
      busStopCode: code,
      busStopName: name,
      customAlias: alias,
      latitude: 1.35,
      longitude: 103.85,
      serviceNos: serviceNos,
      sortOrder: sortOrder,
      addedAt: DateTime(2026, 1, 1),
    );
  }

  group('FavouritesStore', () {
    test('getAll returns empty list when no favourites saved', () async {
      final result = await store.getAll();
      expect(result, isEmpty);
    });

    test('add persists a favourite stop', () async {
      final stop = makeStop(code: '12345', name: 'Orchard Rd');

      await store.add(stop);

      final result = await store.getAll();
      expect(result, hasLength(1));
      expect(result.first.busStopCode, '12345');
      expect(result.first.busStopName, 'Orchard Rd');
      expect(result.first.latitude, 1.35);
      expect(result.first.longitude, 103.85);
      expect(result.first.serviceNos, ['10', '20']);
    });

    test('add preserves all fields through serialization', () async {
      final stop = FavouriteStop(
        busStopCode: '99999',
        busStopName: 'Full Field Stop',
        customAlias: 'Home',
        latitude: 1.2345,
        longitude: 103.6789,
        serviceNos: ['A', 'B', 'C'],
        sortOrder: 5,
        addedAt: DateTime(2026, 3, 4, 12, 30),
      );

      await store.add(stop);
      final result = await store.getAll();

      expect(result, hasLength(1));
      final loaded = result.first;
      expect(loaded.busStopCode, '99999');
      expect(loaded.busStopName, 'Full Field Stop');
      expect(loaded.customAlias, 'Home');
      expect(loaded.latitude, 1.2345);
      expect(loaded.longitude, 103.6789);
      expect(loaded.serviceNos, ['A', 'B', 'C']);
      expect(loaded.sortOrder, 5);
      expect(loaded.addedAt, DateTime(2026, 3, 4, 12, 30));
    });

    test('remove deletes a favourite by busStopCode', () async {
      await store.add(makeStop(code: '111', sortOrder: 0));
      await store.add(makeStop(code: '222', sortOrder: 1));
      await store.add(makeStop(code: '333', sortOrder: 2));

      await store.remove('222');

      final result = await store.getAll();
      expect(result, hasLength(2));
      expect(result.map((f) => f.busStopCode), ['111', '333']);
    });

    test('remove re-indexes sort orders', () async {
      await store.add(makeStop(code: '111', sortOrder: 0));
      await store.add(makeStop(code: '222', sortOrder: 1));
      await store.add(makeStop(code: '333', sortOrder: 2));

      await store.remove('111');

      final result = await store.getAll();
      expect(result[0].sortOrder, 0);
      expect(result[1].sortOrder, 1);
    });

    test('remove is a no-op for non-existent busStopCode', () async {
      await store.add(makeStop(code: '111'));

      await store.remove('999');

      final result = await store.getAll();
      expect(result, hasLength(1));
    });

    test('reorder changes the order of favourites', () async {
      await store.add(makeStop(code: 'A', sortOrder: 0));
      await store.add(makeStop(code: 'B', sortOrder: 1));
      await store.add(makeStop(code: 'C', sortOrder: 2));

      await store.reorder(['C', 'A', 'B']);

      final result = await store.getAll();
      expect(result.map((f) => f.busStopCode).toList(), ['C', 'A', 'B']);
      expect(result[0].sortOrder, 0);
      expect(result[1].sortOrder, 1);
      expect(result[2].sortOrder, 2);
    });

    test('reorder appends stops not in the reorder list', () async {
      await store.add(makeStop(code: 'A', sortOrder: 0));
      await store.add(makeStop(code: 'B', sortOrder: 1));
      await store.add(makeStop(code: 'C', sortOrder: 2));

      // Only reorder A and C; B should be appended at end
      await store.reorder(['C', 'A']);

      final result = await store.getAll();
      expect(result.map((f) => f.busStopCode).toList(), ['C', 'A', 'B']);
    });

    test('rename sets custom alias', () async {
      await store.add(makeStop(code: '111', name: 'Bus Terminal'));

      await store.rename('111', 'Work');

      final result = await store.getAll();
      expect(result.first.customAlias, 'Work');
      expect(result.first.busStopName, 'Bus Terminal');
    });

    test('rename clears alias when null is passed', () async {
      await store.add(makeStop(code: '111', alias: 'Office'));

      await store.rename('111', null);

      final result = await store.getAll();
      expect(result.first.customAlias, isNull);
    });

    test('favourites persist across store instances', () async {
      await store.add(makeStop(code: '111', name: 'Persisted'));

      // Create new store instance (simulates app restart, same SharedPrefs)
      final newStore = FavouritesStore();
      final result = await newStore.getAll();

      expect(result, hasLength(1));
      expect(result.first.busStopCode, '111');
      expect(result.first.busStopName, 'Persisted');
    });

    test(
      'duplicate prevention: adding same busStopCode twice is a no-op',
      () async {
        final stop1 = makeStop(code: '111', name: 'First Add');
        final stop2 = makeStop(code: '111', name: 'Second Add');

        await store.add(stop1);
        await store.add(stop2);

        final result = await store.getAll();
        expect(result, hasLength(1));
        // Original name is preserved
        expect(result.first.busStopName, 'First Add');
      },
    );

    test('isFavourite returns true for saved stops', () async {
      await store.add(makeStop(code: '111'));

      expect(await store.isFavourite('111'), isTrue);
    });

    test('isFavourite returns false for unsaved stops', () async {
      expect(await store.isFavourite('999'), isFalse);
    });

    test('getAll returns stops sorted by sortOrder', () async {
      // Add in non-sequential order
      await store.add(makeStop(code: 'C', sortOrder: 2));
      await store.add(makeStop(code: 'A', sortOrder: 0));
      await store.add(makeStop(code: 'B', sortOrder: 1));

      final result = await store.getAll();
      expect(result.map((f) => f.busStopCode).toList(), ['A', 'B', 'C']);
    });
  });
}
