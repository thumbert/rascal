library test.graphics.axis;

import 'package:test/test.dart';
import 'package:demos/graphics/axis.dart';


main() {
  test('axis type', () {
    List x = [1,2,3];
    expect(Axis.getAxisType(x), AxisType.numeric);
  });

}