library scale.interpolator;
import 'dart:collection';

abstract class Interpolator extends Function {
  Function call(x);
}  

class NumericalInterpolator extends Interpolator {
  Function _apply;
  
  /**
   * Interpolate from [x1,x2] -> [y1,y2]
   */ 
  NumericalInterpolator.fromPoints(num x1, num x2, num y1, num y2) {
    _apply = (x) => y1 + (y2-y1)/(x2-x1)*(x-x1);
  }
  
  /**
   * Interpolate to a*x + b using slope a and offset b 
   */
  NumericalInterpolator.fromSlope(num a, num b) {
    _apply = (x) => a*x + b;
  }
  
  call(x) { return _apply(x);}
}

/**
 * Works like a Partial Function by mapping a list of levels to another list of values. 
 * If the values list is shorter than the levels, the values will get recycled.  This 
 * is useful for color recycling if the number of levels is greater than the number of 
 * colors (values).  
 * 
 */
class OrdinalInterpolator extends Interpolator {
  Map _data;
  Function _apply;

  OrdinalInterpolator(List levels, {List values}) {
    if (values == null) {
      _data = new Map.fromIterables(levels, new List.generate(levels.length, (i)=>i));
    } else {
      int N = values.length;
      _data = new Map.fromIterables(levels, new List.generate(levels.length, (i) => values[i%N]));
    }
    _apply = (x) => _data[x]; 
  }
  
  call(x) { return _apply(x);}
}

