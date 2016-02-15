library test.math.combinatorics.bell_test;

import 'package:test/test.dart';
import 'package:demos/math/combinatorics/bell.dart';

testBell() {
  test('bell numbers', () {
    List exp = [1, 1, 2, 5, 15, 52];
    List act = new List.generate(6, (i) => bell(i));
    expect(exp, act);
  });
}


main() {
  testBell();

  print(bell(20));

  List act = new List.generate(30, (i) => bell(i));
  act.forEach((n) => print(n));
}