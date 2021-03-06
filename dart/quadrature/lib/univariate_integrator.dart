library univariate_integrator;
import 'package:quadrature/src/incrementor.dart';
import 'package:logging/logging.dart';


final Logger _log = new Logger("UnivariateIntegrator");


abstract class UnivariateIntegrator {
  
  bool success;
  
  double getRelativeAccuracy();
  
  double getAbsoluteAccuracy();
  
  int getMinimalIterationCount();
  
  /**
   * Get the upper limit for the number of iterations.
   *
   * @return the actual upper limit
   */
  int getMaximalIterationCount();
  
  /**
   * Integrate the function in the given interval.
  *
   * @param maxEval Maximum number of evaluations.
   * @param f the integrand function
   * @param min the min bound for the interval
   * @param max the upper bound for the interval
   * @return the value of integral
   * @throws TooManyEvaluationsException if the maximum number of function
   * evaluations is exceeded.
   * @throws MaxCountExceededException if the maximum iteration count is exceeded
   * or the integrator detects convergence problems otherwise
   * @throws MathIllegalArgumentException if min > max or the endpoints do not
   * satisfy the requirements specified by the integrator
   * @throws NullArgumentException if {@code f} is {@code null}.
   */
  double integrate(int maxEval, Function f, double min, double max);
  
  /**
   * Get the number of function evaluations of the last run of the integrator.
   * @return number of function evaluations
   */
  int getEvaluations();
  
  /**
   * Get the number of iterations of the last run of the integrator.
   * @return number of iterations
   */
  int getIterations();
}



abstract class BaseAbstractUnivariateIntegrator implements UnivariateIntegrator {
  
  static final double DEFAULT_ABSOLUTE_ACCURACY = 1.0e-15;
  
  static final double DEFAULT_RELATIVE_ACCURACY = 1.0e-6;
  
  static final int DEFAULT_MIN_ITERATIONS_COUNT = 3;
  
  static final int DEFAULT_MAX_ITERATIONS_COUNT = 2147483647;
  
  Incrementor iterations;
  
  bool success = false;
  
  double _absoluteAccuracy;
  
  double _relativeAccuracy;
  
  int _minimalIterationCount;
  
  Incrementor _evaluations;
  
  Function _function;  // TODO: how can I specify it's a double -> double ??
  
  num _min;
  
  num _max;
  
  initialize({
      double relativeAccuracy, 
      double absoluteAccuracy,
      int minimalIterationCount, 
      int maximalIterationCount}) {
    
    if (relativeAccuracy == null) {
      _relativeAccuracy = DEFAULT_RELATIVE_ACCURACY;
    } else {
      _relativeAccuracy = relativeAccuracy;
    }
      
    if (absoluteAccuracy == null) {    
      _absoluteAccuracy = DEFAULT_ABSOLUTE_ACCURACY;
    } else {
      _absoluteAccuracy = absoluteAccuracy;
    }
      
    if (minimalIterationCount == null) {
      _minimalIterationCount = DEFAULT_MIN_ITERATIONS_COUNT;
    } else {
      _minimalIterationCount = minimalIterationCount; 
    }
      
    if (maximalIterationCount == null) 
      maximalIterationCount = DEFAULT_MAX_ITERATIONS_COUNT;
    
    iterations = new Incrementor(maximalIterationCount);
    
    assert(_minimalIterationCount > 0);
    assert(maximalIterationCount > _minimalIterationCount);
    
    _evaluations = new Incrementor();
  }
  
  double getRelativeAccuracy() {
    return _relativeAccuracy;
  }

  double getAbsoluteAccuracy() {
    return _absoluteAccuracy;
  }
  
  int getMinimalIterationCount() {
    return _minimalIterationCount;
  }
  
  int getMaximalIterationCount() {
    return iterations.maximalCount;
  }
  
  int getEvaluations() {
    return _evaluations.count;
  }
  
  int getIterations() {
    return iterations.count;
  }
  
  double get min => _min;
  
  double get max => _max;
  
  double computeObjectiveValue(double point) {
     _evaluations.incrementCount(1);
    
    return _function(point);
  }
  
  setup(int maxEval, Function f, num lower, num upper) {
    assert(lower < upper);
    
    _min = lower;
    _max = upper;
    _function = f; 
    _evaluations.maximalCount = maxEval;
    iterations.resetCount();
  }
  
  integrate(int maxEval, Function f, num lower, num upper) {
    setup(maxEval, f, lower, upper);
    
    double res = double.NAN; 
    try {
      res = doIntegrate();
      _log.info("SUCCESS.  Function evaluations: " + getEvaluations().toString());
    } catch (e) {
      _log.info("FAILED.  Too many evaluations or convergence problems. " + 
          "Function evaluations: " + getEvaluations().toString());
    }
    
    return res;
  }
  
  
  double doIntegrate();
}

