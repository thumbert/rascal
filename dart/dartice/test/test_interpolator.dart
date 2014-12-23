library test_interpolator;

import 'package:unittest/unittest.dart';
import 'package:dartice/scale/interpolator.dart';


test_interpolator() {
  group("test interpolator", () {

    test("ordinal interpolator", () {
      List groups = ["A", "B", "C"];
      OrdinalInterpolator oi = new OrdinalInterpolator(groups);
      expect(oi("A"), 0);
      expect(oi("C"), 2);
    });
    test("ordinal interpolator with recycling", () {
      List groups = ["A", "B", "C", "E", "F"];
      OrdinalInterpolator oi = new OrdinalInterpolator(groups, values: [1, 2, 3]);
      expect(groups.map((g) => oi(g)).toList(), [1, 2, 3, 1, 2]);
    });


  });

}

main() => test_interpolator();
