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

abstract class Scale {
  /// the limits of the data + margin
  num x1, x2;
  /// the limits on the screen
  num y1, y2;
  num call(x);
}

class LinearScale implements Scale {
  num x1, x2, y1, y2;

  Function _fun;

  LinearScale(this.x1, this.x2, this.y1, this.y2) {
    num slope = (y2 - y1)/(x2 - x1);
    _fun = (x) => slope * (x - x1) + y1;
  }

  num call(num x) => _fun(x);
}