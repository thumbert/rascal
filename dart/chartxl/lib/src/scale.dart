library scale;

import 'package:chartxl/src/interpolator.dart';

abstract class Scale {
  
}

/**
 * Linear scale between domain to range. 
 */
class LinearScale extends Scale {
  List<num> domain;
  List<num> range;
  Interpolator interpolator;
  
  LinearScale(this.domain, this.range, Interpolator this.interpolator, {bool clamp: false}) {
    
  }
  
  scale(x) => interpolator(x);
  
}

class LogScale extends Scale {
  
}
