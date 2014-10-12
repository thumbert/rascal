library test_interpolators;

import 'package:chartxl/src/interpolator.dart';

test_interpolators() {
  
  var i1 = new NumericalInterpolator.fromSlope(1, 0);
  print(i1(0.5));
  print(new NumericalInterpolator.fromPoints(0, 1, 2, 12)(0.4) == 6.0);
  
  
}