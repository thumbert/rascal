import 'dart:collection';
import 'package:collection/collection.dart';

import 'package:test/test.dart';

const _rowEquality = const MapEquality();

List<Map> unique(List<Map> xs, {List names}) {
  Set uRows = new LinkedHashSet(
      equals: _rowEquality.equals,
      isValidKey: _rowEquality.isValidKey,
      hashCode: (e) => _rowEquality.hash(e));
  if (names == null) {
    for (int i = 0; i < xs.length; i++) uRows.add(xs[i]);
  } else {
    for (int i = 0; i < xs.length; i++) {
      Map aux = new Map.fromIterables(names, names.map((name) => xs[i][name]));
      uRows.add(aux);
    }
  }
  return uRows.toList();
}

uniqueMapTest() {
  group('unique maps:', (){
    List<Map> xs = [
      {'type': 'A', 'time': new DateTime(2018), 'value': 10},
      {'type': 'A', 'time': new DateTime(2018), 'value': 10},
      {'type': 'B', 'time': new DateTime(2018), 'value': 10},
    ];
    test('no names', (){
      var res = unique(xs);
      expect(res.length, 2);
    });
    test('with one name', (){
      var res = unique(xs, names: ['type']);
      expect(res.length, 2);
      expect(res, [{'type': 'A'}, {'type': 'B'},]);
    });
    test('with two names', (){
      xs.add({'type': 'A', 'time': new DateTime(2019), 'value': 10});
      var res = unique(xs, names: ['type', 'time']);
      var out = [
        {'type': 'A', 'time': new DateTime(2018)},
        {'type': 'B', 'time': new DateTime(2018)},
        {'type': 'A', 'time': new DateTime(2019)},];
      expect(res.length, 3);
      expect(res, out);
    });
  });
}

main() {
  uniqueMapTest();
}
