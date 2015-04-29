library test.stagexl.demo_5;

import 'package:unittest/unittest.dart';
import 'package:demos/graphics/ticks_numeric.dart';
import 'package:demos/math/utils.dart';

List roundList(List x, [int digits = 0]) => x.map((e) => round(e, digits)).toList();

testAxisNumeric() {

  group('Ticks for numeric axis:', () {
    test("(0.001,0.023) = [0, 0.005, 0.01, 0.015, 0.02, 0.025]", () {
      expect( roundList(calculateTicks(0.001, 0.023), 3),
      [0, 0.005, 0.01, 0.015, 0.02, 0.025]);
    });

    test("(0,1) = [0, 0.2, 0.4, 0.6, 0.8, 1]", () {
      List ticks = calculateTicks(0, 1);
      expect(roundList(ticks, 1), [0, 0.2, 0.4, 0.6, 0.8, 1]);
    });
    test("(65,66) = [65.0, 65.2, 65.4, 65.6, 65.8, 66.0]", () {
      expect(calculateTicks(65, 66).map((num e) => num.parse(e.toStringAsPrecision(3))).toList(),
      [65.0, 65.2, 65.4, 65.6, 65.8, 66.0]);
    });
    test("(0,3) = [0, 0.5, 1, 1.5, 2, 2.5, 3]", () {
      expect(calculateTicks(0, 3), [0, 0.5, 1, 1.5, 2, 2.5, 3]);
    });
    test("(0,5) = [0, 1, 2, 3, 4, 5]", () {
      expect(calculateTicks(0, 5), [0, 1, 2, 3, 4, 5]);
    });
    test("(0,10) = [0, 2, 4, 6, 8, 10]", () {
      expect(calculateTicks(0, 10), [0, 2, 4, 6, 8, 10]);
    });
    test("(0,25) = [0, 5, 10, 15, 20, 25]", () {
      expect(calculateTicks(0, 25), [0, 5, 10, 15, 20, 25]);
    });
    test("(-10,17) = [-10, -5, 0, 5, 10, 15, 20]", () {
      expect(calculateTicks(-10, 17), [-10, -5, 0, 5, 10, 15, 20]);
    });
    test("(0,50) = [0, 10, 20, 30, 40, 50]", () {
      expect(calculateTicks(0, 50), [0, 10, 20, 30, 40, 50]);
    });
    test("(-12,45) = [-20, -10, 0, 10, 20, 30, 40, 50]", () {
      expect(calculateTicks(-12, 45), [-20, -10, 0, 10, 20, 30, 40, 50]);
    });
    test("(0,100) = [0, 25, 50, 75, 100]", () {
      expect(calculateTicks(0, 100), [0, 25, 50, 75, 100]);
    });
    test("(-22,74) = [-25, 0, 25, 50, 75]", () {
      expect(calculateTicks(-22, 74), [-25, 0, 25, 50, 75]);
    });
    test("(0,1000) = [0, 200, 400, 600, 800, 1000]", () {
      expect(roundList(calculateTicks(0, 1000)), [0, 200, 400, 600, 800, 1000]);
    });
    test("(-10,4001) = [-1000, 0, 1000, 2000, 3000, 4000, 5000]", () {
      expect(roundList(calculateTicks(-10, 4001)), [-1000, 0, 1000, 2000, 3000, 4000, 5000]);
    });
    test("(-10,65701) = [-20000, 0, 20000, 40000, 60000, 80000]", () {
      expect(roundList(calculateTicks(-10, 65701)), [-20000, 0, 20000, 40000, 60000, 80000]);
    });


  });

}


main() {
  testAxisNumeric();
}