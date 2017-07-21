library graphics.scale;

/// Return a function to linearly interpolate using two points.
Function linearScale(num x1, num x2, num y1, num y2) {
  num slope = (y2 - y1)/(x2 - x1);
  return (x) => slope * (x - x1) + y1;
}

// do we need this??
enum ScaleType {
  linear,
  logarithmic
}

abstract class Scale<K> {
  /// the limits of the data + margin
  K x1, x2;
  /// the limits on the screen
  num y1, y2;
  num call(K x);
  K inverse(num y);
}

class LinearScale implements Scale<num> {
  num x1, x2, y1, y2;

  num _slope;

  Function _fun;

  LinearScale(this.x1, this.x2, this.y1, this.y2) {
    if (x1 == x2)
      throw 'Can\'t have the same value for x1 and x2';
    _slope = (y2 - y1)/(x2 - x1);
    _fun = (x) => _slope * (x - x1) + y1;
  }

  num call(num x) => _fun(x);

  /// calculate the x given a value for y
  num inverse(num y) => (y - y1)/_slope;

}