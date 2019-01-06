library test_maps;

import 'dart:collection';
import 'package:test/test.dart';

/**
 * an unmodifiable map view
 */
t1() {
  test('a map view', () {
    Map m = {"A": 1, "B": 2};
    var mv = new UnmodifiableMapView(m);

    m["C"] = 3;          // add another entry in the first map
    expect(mv['C'], 3);  // {A: 1, B: 2, C: 3} it gets reflected in the view
    // mv["D"] = 4;      // throws
  });
}

/// Map copying works
copy() {
  test('Simple map copying', () {
    Map m1 = {'a': 1, 'b': 2};
    Map c1 = new Map.from(m1);

    m1.remove('b');
    expect(c1.length, 2);  // unaffected
  });

  test('Map with object key copying', () {
    Map m1 = {new Coord(0,0): 1, new Coord(0,1): 2};
    Map c1 = new Map.from(m1);

    m1.remove(new Coord(0,1));
    expect(c1.length, 2);  // unaffected
  });
}




main() {
  t1();

  copy();
}





class Coord {
  int row, column;
  int _value;

  Coord(this.row, this.column) {
    _value = 1024*column + row;
  }
  int get hashCode => _value;
  bool operator ==(other) => other != null && row == other.row && column == other.column;
  String toString() => '($row, $column)';
}

