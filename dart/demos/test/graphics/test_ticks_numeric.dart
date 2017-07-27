library test.stagexl.demo_5;

import 'package:test/test.dart';
import 'package:demos/graphics/ticks_numeric.dart';
import 'package:demos/math/utils.dart';

List roundList(List x, [int digits = 0]) => x.map((e) => round(e, digits)).toList();

testAxisNumeric() {

//  print('between 0.001 and 0.023');
//  print(coverWithStep(0.01, 0.001, 0.023));
//  List ticks = defaultNumericTicks(0.001, 0.023);
//  print(ticks);



  group('Ticks for numeric axis:', () {
    test('(37.171,37.6447) = [37, 37.2, 37.4, 37.6, 37.8]', () {
      List ticks = defaultNumericTicks(37.171, 37.6447);
      expect(roundList(ticks, 1), [37, 37.2, 37.4, 37.6, 37.8]);
    });

    test("(0.001,0.023) = [0, 0.01, 0.02, 0.03]", () {
      List ticks = defaultNumericTicks(0.001, 0.023);
      expect( roundList(ticks, 3),
          [0, 0.01, 0.02, 0.03]);
    });

    test("(0,1) = [0, 0.2, 0.4, 0.6, 0.8, 1]", () {
      List ticks = defaultNumericTicks(0, 1);
      expect(roundList(ticks, 1), [0, 0.2, 0.4, 0.6, 0.8, 1]);
    });

    test('(24,51)', (){
      List ticks = defaultNumericTicks(24, 51);
      expect(ticks, new List.generate(8, (i)=> 20 + 5*i));
    });

    test("(65,66) = [65.0, 65.2, 65.4, 65.6, 65.8, 66.0]", () {
      expect(defaultNumericTicks(65, 66).map((num e) => num.parse(e.toStringAsPrecision(3))).toList(),
      [65.0, 65.2, 65.4, 65.6, 65.8, 66.0]);
    });
    test("(0,3) = [0, 0.5, 1, 1.5, 2, 2.5, 3]", () {
      expect(defaultNumericTicks(0, 3), [0, 0.5, 1, 1.5, 2, 2.5, 3]);
    });
    test("(0,5) = [0, 1, 2, 3, 4, 5]", () {
      expect(defaultNumericTicks(0, 5), [0, 1, 2, 3, 4, 5]);
    });
    test("(0,10) = [0, 2, 4, 6, 8, 10]", () {
      expect(defaultNumericTicks(0, 10), [0, 2, 4, 6, 8, 10]);
    });
    test("(0,25) = [0, 5, 10, 15, 20, 25]", () {
      expect(defaultNumericTicks(0, 25), [0, 5, 10, 15, 20, 25]);
    });
    test("(-10,17) = [-10, -5, 0, 5, 10, 15, 20]", () {
      expect(defaultNumericTicks(-10, 17), [-10, -5, 0, 5, 10, 15, 20]);
    });
    test("(0,50) = [0, 10, 20, 30, 40, 50]", () {
      expect(defaultNumericTicks(0, 50), [0, 10, 20, 30, 40, 50]);
    });
    test("(-12,45) = [-20, -10, 0, 10, 20, 30, 40, 50]", () {
      expect(defaultNumericTicks(-12, 45), [-20, -10, 0, 10, 20, 30, 40, 50]);
    });
    test("(0,100) = [0, 25, 50, 75, 100]", () {
      expect(defaultNumericTicks(0, 100), [0, 25, 50, 75, 100]);
    });
    test("(-22,74) = [-25, 0, 25, 50, 75]", () {
      expect(defaultNumericTicks(-22, 74), [-25, 0, 25, 50, 75]);
    });
    test("(0,1000) = [0, 200, 400, 600, 800, 1000]", () {
      expect(roundList(defaultNumericTicks(0, 1000)), [0, 200, 400, 600, 800, 1000]);
    });
    test("(-10,4001) = [-1000, 0, 1000, 2000, 3000, 4000, 5000]", () {
      expect(roundList(defaultNumericTicks(-10, 4001)), [-1000, 0, 1000, 2000, 3000, 4000, 5000]);
    });
    test("(-10,65701) = [-20000, 0, 20000, 40000, 60000, 80000]", () {
      expect(roundList(defaultNumericTicks(-10, 65701)), [-20000, 0, 20000, 40000, 60000, 80000]);
    });
  });

}


main() {
  testAxisNumeric();
}