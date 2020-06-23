library test_lists;

import 'dart:collection';
import 'dart:math' show min;
import 'package:date/date.dart';
import 'package:timeseries/timeseries.dart';

//import 'package:demos/collection/custom_iterator.dart';
import 'package:test/test.dart';

class Person {
  String name;
  int age;
  Person(this.name, this.age);
  String toString() => "{name: $name, age: $age}";
}

class MyCustomList<E> extends Object with ListMixin<E> {
  final List<E> l = [];
  MyCustomList();

  void set length(int newLength) { l.length = newLength; }
  int get length => l.length;
  E operator [](int index) => l[index];
  void operator []=(int index, E value) { l[index] = value; }

}

/// Merge [a] and [b] until [a] is fully consumed. Then add 42.
Iterable<int> combine(Iterable<int> a, Iterable<int> b) sync* {
  var aIterator = a.iterator;
  var bIterator = b.iterator;
  while (aIterator.moveNext()) {
    yield aIterator.current;
    if (bIterator.moveNext()) {
      yield bIterator.current;
    }
  }
  yield 42;
}

void examples() {
  List x = [new Person("Andrei", 50),
    new Person("Laura",  10),
    new Person("Gaga",   27)];

  x.removeWhere((p) => p.age < 20);
  print(x);

  MyCustomList y = new MyCustomList();
  y.addAll([new Person("Andrei", 50),
    new Person("Laura",  10),
    new Person("Gaga",   27)]);
  y.removeWhere((p) => p.age < 20);
  print(y);

  /// Calculate the minimum of a list
  List z = [3, 5, 1, 4, 7];
  print(z.fold(z.first, (a,b) => min(a,b)));


  /// when you get an element from the List, it keeps the reference
  /// make changes to the original list
  List xx = [
    {'id': 1, 'value': 'A'},
    {'id': 2, 'value': 'B'},
  ];
  var a = xx.firstWhere((e) => e['id'] == 1);
  a['value'] = 'AA';
  print(xx.first['value'] == 'AA');  // true

}

void tests() {
  group('Sorting of Lists', () {
    var xs = [
      {'id': 'A', 'value': -500},
      {'id': 'B', 'value':  500},
      {'id': 'C', 'value': -1000},
      {'id': 'C', 'value':  2000},
    ];
    test('sort ascending', () {
      var ys = xs..sort((a,b) => (a['value'] as num).compareTo(b['value'] as num));
      expect(ys, [
        {'id': 'C', 'value': -1000},
        {'id': 'A', 'value': -500},
        {'id': 'B', 'value':  500},
        {'id': 'C', 'value':  2000},
      ]);
    });
    test('sort descending', () {
      var ys = xs..sort((a,b) => -(a['value'] as num).compareTo(b['value'] as num));
      expect(ys, [
        {'id': 'C', 'value':  2000},
        {'id': 'B', 'value':  500},
        {'id': 'A', 'value': -500},
        {'id': 'C', 'value': -1000},
      ]);
    });
    test('sort descending by absolute value', () {
      var ys = xs..sort((a,b) {
        var as = (a['value'] as num).abs();
        var bs = (b['value'] as num).abs();
        return -as.compareTo(bs);
      });
      ys.forEach(print);
      expect(ys, [
        {'id': 'C', 'value':  2000},
        {'id': 'B', 'value':  500},
        {'id': 'A', 'value': -500},
        {'id': 'C', 'value': -1000},
      ]);
    });


  });
}


void main() {

  // chain where
  var x = List.generate(24, (i) => i);
  var index = Date(2020, 1, 1).hours();
  var ts = TimeSeries.from(index, x);
  var ys = ts;

  var xs = ys.where((e) => e.value % 2 == 0);
  xs = xs.where((e) => e.value > 10);
  xs.forEach(print);





  //tests();

}

