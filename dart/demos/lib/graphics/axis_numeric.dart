library axis_numeric;

import 'dart:math' as math;
import 'package:tuple/tuple.dart';
import 'package:stagexl/stagexl.dart';
import 'ticks_numeric.dart';
import 'figure.dart';
import 'tick.dart';
import 'axis.dart';
import 'scale.dart';


/**
 * A Numeric axis.
 */
class NumericAxis extends Axis {

  /// the ticks for the axis
  List<Tick> ticks;

//  TextFormat fmt;

  /// margin in points from the edges of the parent (what is this for??)
  num margin = 30;

  /// margin in points from the left edge of the parent to the first tick
  //int leftMargin;
  /// margin in points from the right edge of the parent to the last tick
  //int rightMargin;

  /// amount of minimum space between labels, so they don't look crowded
  num minSpaceBetweenLabels = 10;


  /// the position of the axis
  Position position;

  /**
   * A numeric axis.
   *
   * [min] lowest value of the data
   * [max] largest value of the data
   */
  NumericAxis(Scale scale, this.position, {this.ticks}) {
    this.scale = scale;

    ticks ??= _defaultNumericTicks();

    //print('ticks are: ${ticks.join(',')}');
  }

  /// Extend the limits of a numeric axis, so the data is contained in
  /// a 'nice' interval.  For example if the lim of the data is [0.5,9]
  /// a nice extended limit would be [0,10].
  static Tuple2<num,num> extendLimits(Tuple2<num,num> lim) {
    Tuple2<num,num> limExt = lim;

    return limExt;
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

  /// the actual length of the axis in pixels
  num get _axisLength => scale.y2 - scale.y1;

  /// Draw this axis
  draw() {

    /// draw the axis line
    graphics.moveTo(0.5, 0);
    graphics.lineTo(_axisLength-0.5, 0);

    /// add the ticks
    ticks.forEach((tick) => addChild(tick));
    ticks.forEach((tick) => tick.draw());

    //graphics.strokeColor(Color.Black);
    graphics.strokeColor(Color.Black, 1, JointStyle.MITER, CapsStyle.SQUARE);
  }

  /// default ticks
  List<Tick> _defaultNumericTicks() {
    List<Tick> _ticks = [];

    List<num> tickNum = defaultNumericTicks(scale.x1, scale.x2);
    List<String> tickLabels = tickNum.map((e) => _defaultNumericTickLabel(e)).toList();
    print(tickLabels);

    /// construct the ticks
    num _left = 0;
    for (int i = 0; i < tickNum.length; i++) {
      print('i: $i, ${tickNum[i]}, ${scale(tickNum[i])}');
      var x = scale(tickNum[i]);
      Tick tick = new Tick(text: tickLabels[i])
        ..direction = TickDirection.down;

      // if the label doesn't fit, remove the label
//      if (x - tick.width/2 < _left + minSpaceBetweenLabels) {
//        tick = new Tick(text: '')
//          ..direction = TickDirection.down;
//      }
//      if (x + tick.width/2 > _axisLength) {
//        tick = new Tick(text: '')
//          ..direction = TickDirection.down;
//      }

      tick.x = x;
      tick.name = 'draw-tick-{i}';
      _left = x + tick.width/2;
      _ticks.add(tick);
    }

    return _ticks;
  }


  /// Construct the default tick label for a given value
  ///
  List<String> _defaultNumericTickLabel(num value) {
    Function fmtLabel;
    num range10 = (math.log(scale.x2 - scale.x1)*math.LOG10E);
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
    return fmtLabel(value);
  }



}