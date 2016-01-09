library axis_numeric;

import 'dart:math' as math;
import 'package:tuple/tuple.dart';
import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/ticks_numeric.dart';
import 'package:demos/graphics/tick.dart';
import 'package:demos/graphics/axis.dart';


/**
 * A Numeric axis.
 */
class NumericAxis extends Axis {

  /// min value for this axis
  num min;

  /// max value for this axis
  num max;

//  List<String> tickLabels;
//  TextFormat fmt;

  /// go from a num to a screen coordinate;
  Function scale;


  /// margin in points from the edges of the parent
  num margin = 30;

  /// margin in points from the left edge of the parent to the first tick
  //int leftMargin;
  /// margin in points from the right edge of the parent to the last tick
  //int rightMargin;

  /// amount of minimum space between labels, so they don't look crowded
  num minSpaceBetweenLabels = 10;

  /// the actual length of the axis in pixels
  num _axisLength;


  /**
   * A numeric axis.
   *
   * [min] lowest value to represent
   * [margin] margin in points from the edges of the parent.
   *   if ticks are specified
   *   if the tickLabels are specified, then the margin is adjusted to make room (if possible)
   */
  NumericAxis(this.min, this.max, {List<num> this.ticks, List<String> this.tickLabels}) {
    assert(min <= max);

    ticks ??= defaultNumericTicks(min, max);

    //print('ticks are: ${ticks.join(',')}');
  }

  /// Calculate the [min,max] of the iterable for axis limits
  /// You can pass in some existing limits from the previous lines to extend the
  /// limits.
  static Tuple2<num,num> getLimits(Iterable<num> x, {Tuple2<num,num> lim}) {
    if (x.isEmpty)
      throw 'Cannot calculate the limits of an empty iterable';
    if (x.length == 1 && (x.first.isNaN || x.first == null))
      throw 'Cannot calculate the limits';
    num min = lim.i1;
    num max = lim.i2;
    x.where((e) => !(e.isNaN || e == null)).forEach((num e){
      if (e > max || max == null) max = e;
      if (e < min || min == null) min = e;
    });

    return new Tuple2(min,max);
  }


  /// Draw this axis
  draw() {
    if (_axisLength == null) {
      if (parent != null) {
        _axisLength = parent.width;
      } else {
        throw('axisLength is null and parent is not set yet!');
      }
    }

    scale = (num x) => ((x - min) * (_axisLength - 2*margin) /(max - min) + margin).truncate();

    /// draw the axis line
    graphics.moveTo(0.5, y);
    graphics.lineTo(_axisLength-0.5, y);

    /// add the ticks
    _defaultNumericTicks().forEach((tick) => addChild(tick));

    graphics.strokeColor(Color.Black);
  }

  /// default ticks
  List<Tick> _defaultNumericTicks() {
    List _ticks = [];

    tickLabels ??= _defaultNumericTickLabels();

    /// tickLabels need to match the length of the ticks
    /// assert(tickLabels.length == ticks.length);

    num _left = 0;
    for (int i = 0; i < ticks.length; i++) {
      //print('i: $i, ${scale(ticks[i])}');
      var x = scale(ticks[i]);
      Tick tick = new Tick(tickLabels[i], Direction.DOWN);

      // if the label doesn't fit, remove the label
      if (x - tick.width/2 < _left + minSpaceBetweenLabels) {
        tick = new Tick('', Direction.DOWN);
      }
      if (x + tick.width/2 > _axisLength) {
        tick = new Tick('', Direction.DOWN);
      }

      tick.x = x;
      _left = x + tick.width/2;
      _ticks.add(tick);
    }

    return _ticks;
  }


  /// default tick labels
  _defaultNumericTickLabels() {
    Function fmtLabel;
    num range10 = (math.log(max - min)*math.LOG10E);
    //print('range10: $range10');
    if (range10 <= 0.6) {
      int precision = math.max(range10, 1).ceil();
      print('precision: $precision');
      fmtLabel = (num x) {
        String res;
        if (x.abs() >= 1000000)
          res = x.toStringAsExponential(2);
        else
          res = x.toStringAsFixed(precision);
        return res;
      };
    } else {
      fmtLabel = (num x) {
        String res;
        if (x.abs() >= 1000000)
          res = x.toStringAsExponential(0);
        else
          res = x.toStringAsFixed(0);
        return res;
      };
    }
    tickLabels = ticks.map((e) => fmtLabel(e)).toList();
  }



}