import 'dart:collection';
import 'package:collection/collection.dart';

const _rowEquality = const MapEquality();

List<Map> unique(List<Map> xs, {List names}) {
  Set uRows = new LinkedHashSet(
      equals: _rowEquality.equals,
      isValidKey: _rowEquality.isValidKey,
      hashCode: (e) => _rowEquality.hash(e));

  if (names == null) {
    for (int i = 0; i < xs.length; i++) uRows.add(xs[i]);
  } else {
    Map aux = {};
//    for (int i = 0; i < xs.length; i++) {
//      Map rowi = row(i);
//      columnNames.forEach((name) => aux[name] = rowi[name]);
//      uRows.add(aux);
//    }
  }

  return uRows.toList();
}

uniqueMapTest() {
  List<Map> xs = [
    {'type': 'A', 'time': new DateTime(2018), 'value': 10},
    {'type': 'A', 'time': new DateTime(2018), 'value': 10},
    {'type': 'B', 'time': new DateTime(2018), 'value': 10},
  ];
  var res = unique(xs);
  res.forEach(print);
}

main() {
  uniqueMapTest();
}
