library graphics.ticks_numeric;

import 'dart:math';
import 'package:demos/math/utils.dart';



/// Calculate the location of default numerical ticks.
///
List<num> defaultNumericTicks(num min, num max) {

  num range10 = log10(max - min);
  //print("range10 is " + range10.toString());
  num step;

  if (range10 < 0.0) {
    // a small range
    int multiple10 = range10.ceil();
    num restRange = -(range10 - multiple10);   // between (0,1)
    step = _getCustomStep(restRange)*pow(10.0, multiple10);
    if (step > (max - min)) step = step/10;
    //print(step);

  } else if (range10 >= 0.0 && range10 <= 2.0) {
    step = _getCustomStep(range10);


  } else if (range10 > 2.0) {
    // go back to what you did for the range10 in [0,2] interval
    // and multiply by the appropriate power of 10.
    int multiple10 = range10.truncate();
    num restRange = range10 - multiple10;   // between (0,1)
    step = _getCustomStep(restRange)*pow(10.0, multiple10);
  }


  return coverWithStep(step, min, max);
}


/// Custom split when range10 is between [0, 2].
num _getCustomStep(num range10) {
  num step;

  if (range10 >= 0 && range10 <= 0.46) {
    // separate by 0.2's
    step = 0.2;

  } else  if (range10 > 0.46 && range10 <= 0.6) {
    // separate by 0.5's
    step = 0.5;

  } else if (range10 > 0.6 && range10 <= 0.78) {
    // separate by 1's
    step = 1;

  } else if (range10 > 0.78 && range10 <= 1.0) {
    // separate by 2's
    step = 2;

  } else if (range10 > 1.0 && range10 <= 1.5) {
    // separate by 5's
    step = 5;

  } else if (range10 > 1.5 && range10 <= 1.76) {
    // separate by 10's
    step = 10;

  } else if (range10 > 1.76 && range10 <= 2.0) {
    //separate by 25's
    step = 25;
  }

  return step;
}



/**
 *  Generate the smallest list of multiples of step which covers
 *  the interval (x1,x2).  The first generated value rounds down x1
 *  and the last generated value rounds up x2.
 */
List<num> coverWithStep(num step, num x1, num x2) {
  num xLow  = (x1/step).floor()*step;
  num xHigh = (x2/step).ceil()*step;
//  print('xLow: $xLow, xHigh: $xHigh, step: $step');
  return seqNum(xLow, xHigh, step);
}
