library interpolator;

abstract class Interpolator extends Function {
  Function call(x);
}  

class NumericalInterpolator extends Interpolator{
  Function _apply;
  
  /**
   * Interpolate from [x1,x2] -> [y1,y2]
   */ 
  NumericalInterpolator.fromPoints(num x1, num x2, num y1, num y2) {
    _apply = (x) => y1 + (y2-y1)*x/(x2-x1);
  }
  
  /**
   * Interpolate to a*x + b using slope a and offset b 
   */
  NumericalInterpolator.fromSlope(num a, num b) {
    _apply = (x) => a*x + b;
  }
  
  call(x) { return _apply(x);}
}
