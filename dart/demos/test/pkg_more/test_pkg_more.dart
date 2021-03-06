library test_pkg_more;

import 'package:more/cache.dart';
import 'package:test/test.dart';
import 'package:more/iterable.dart';
import 'package:more/ordering.dart';

test_permutations() {
  var x = permutations(['A', 'B', 'C']);
  test('permutations', (){
    expect(x.length, 6);
    var it = x.iterator;
    expect(it.moveNext(), true);
    expect(it.current, ['A', 'B', 'C']);
  });
}

test_orderings() {
  group('Orderings tests:', () {
    var data = [
      ["BOS", "Jan", 25],
      ["LAX", "Jan", 55],
      ["BOS", "Apr", 54],
      ["BOS", "Feb", 28],
      ["LAX", "Feb", 58]
    ];

    var byMonthExplicit = Ordering.explicit(["Jan", "Feb", "Mar", "Apr"]);
    test('list with nulls', () {
      var natural = Ordering.natural<num>();
      var ordering = natural.nullsLast;
      expect(ordering.sorted([2, null, 3, 1]),
          [1, 2, 3, null]);
    });

    test('explicit sort (like R factors)', () {
      var months = [
        "Feb",
        "Feb",
        "Jan",
        "Apr",
        "Mar",
        "Mar"
      ];
      expect(byMonthExplicit.sorted(months),
          ['Jan', 'Feb', 'Feb', 'Mar', 'Mar', 'Apr']);
    });

    test('sort by first element of list', (){
      var byCode = Ordering.natural<String>().onResultOf((obs) => obs[0]);
      var res = byCode.sorted(data);
      expect(res, [
        ['BOS', 'Jan', 25],
        ['BOS', 'Apr', 54],
        ['BOS', 'Feb', 28],
        ['LAX', 'Jan', 55],
        ['LAX', 'Feb', 58]]);
    });

    test('sort by two variables: code & month', (){
      var byCode = Ordering.natural<String>().onResultOf((obs) => obs[0]);
      var byMonth = byMonthExplicit.onResultOf((obs) => obs[1]);
      var byCodeMonth = byCode.compound(byMonth);
      var res = byCodeMonth.sorted(data);
      expect(res, [
        ['BOS', 'Jan', 25],
        ['BOS', 'Feb', 28],
        ['BOS', 'Apr', 54],
        ['LAX', 'Jan', 55],
        ['LAX', 'Feb', 58]
      ]);
    });

    test('order datetimes', (){
      var dt = [DateTime(2014), DateTime(2010), DateTime(2011)];
      expect(Ordering.natural<DateTime>().sorted(dt), [
        new DateTime(2010),
        new DateTime(2011),
        new DateTime(2014),
      ]);
    });

    test('order a List of Maps with nulls', (){
      var map1 = [
        {'station': 'A', 'value': 10},
        {'station': 'A', 'value': null},
        {'station': 'B', 'value': 15},
        {'station': 'A', 'value': 7},
      ];
      var ord = Ordering.natural<num>()
          .nullsFirst
          .onResultOf<Map>((Map row) => row['value']);
      expect(ord.sorted(map1), [
        {'station': 'A', 'value': null},
        {'station': 'A', 'value': 7},
        {'station': 'A', 'value': 10},
        {'station': 'B', 'value': 15},
      ]);
    });

    test('order a List of Maps by two fields', () {
      var map2 = [
        {'station': 'A', 'value': 10},
        {'station': 'A', 'value': 12},
        {'station': 'B', 'value': 15},
        {'station': 'B', 'value': 6},
        {'station': 'A', 'value': 7},
      ];
      var natural = Ordering.natural<String>();
      var byStation = natural
          .onResultOf<Map>((Map row) => row['station']);
      var byValue = natural
          .onResultOf<Map>((Map row) => row['value']);
      var byStationValue = byStation.compound(byValue);
      expect(byStationValue.sorted(map2), [
        {'station': 'A', 'value': 7},
        {'station': 'A', 'value': 10},
        {'station': 'A', 'value': 12},
        {'station': 'B', 'value': 6},
        {'station': 'B', 'value': 15},
      ]);
    });

  });


}

testCache() async {
  /// define an LRU cache
  String loader(int key) => '$key';
  var cache = Cache<int,String>.lru(loader: loader);
  /// set a value by hand
  cache.set(1, 'A');
  print(await cache.get(1));  // returns 'A'
  /// because key: 2 is not in the cache, use the loader to put it in first.
  print(await cache.get(2));  // returns '2'

  cache.invalidate(1);
  print(await cache.size());
}


main() {
  testCache();

//  test_permutations();
//
//  test_orderings();


}
