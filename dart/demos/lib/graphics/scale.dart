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

  LinearScale(this.x1, this.x2, this.y1, this.y2) {
    if (x1 == x2)
      throw 'Can\'t have the same value for x1 and x2';
    _slope = (y2 - y1)/(x2 - x1);
  }

  num call(num x) => _slope * (x - x1) + y1;

  /// calculate the x given a value for y
  num inverse(num y) => (y - y1)/_slope + x1;
}

class DateTimeScale implements Scale<DateTime> {
  DateTime x1, x2;
  int _x1m, _x2m;
  num y1, y2;

  num _slope;

  DateTimeScale(this.x1, this.x2, this.y1, this.y2) {
    if (x1 == x2)
      throw 'Can\'t have the same value for x1 and x2';
    _x1m = x1.millisecondsSinceEpoch;
    _x2m = x2.millisecondsSinceEpoch;
    _slope = (y2 - y1)/(_x2m - _x1m);
  }

  num call(DateTime x) => _slope * (x.millisecondsSinceEpoch - _x1m) + y1;

  /// calculate the x given a value for y
  DateTime inverse(num y) => new DateTime.fromMillisecondsSinceEpoch(((y - y1)/_slope).round() + _x1m);
}