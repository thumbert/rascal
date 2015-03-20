library math.utils;

import 'dart:math';

num log10(num x) => log(x)*LOG10E;

/**
 * Round a double to a certain digit.
 * e.g. round(1.23456, 2) == 1.23
 *
 */
double round(double value, [int digit=1]) {
  double pow10 = pow(10.0, digit);
  return (pow10*value).round()/pow10;
}


/**
 * Generate a linear sequence of numbers from a start value to an end value
 * given a step size.  There is a risk that for a double step, the end value
 * may not be reached because of loss of numerical precision.  You may want
 * to correct for that by increasing the end value by a small epsilon value.
 *
 */
List<num> seqNum(num start, num end, [num step=1]) {
  List<num> res=[];
  for(num i=start; i<=end; i+=step) {
    res.add(i);
  }

  return res;
}
