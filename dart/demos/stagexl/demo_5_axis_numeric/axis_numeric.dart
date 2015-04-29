library axis_numeric;

import 'dart:math' as math;
import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/ticks_numeric.dart';
import 'package:demos/graphics/tick.dart';


/**
 * A Numeric axis.
 */
class NumericAxis extends Sprite {

  num min, max;
  List<num> ticks;
  List<String> tickLabels;
  TextFormat fmt;

  /// go from a num to a screen coordinate;
  Function scale;

  /// the label gets under the ticks to clarify the meaning of the ticks
  String label;

  /// margin in points from the edges of the parent
  num margin;
  /// margin in points from the left edge of the parent to the first tick
  //int leftMargin;
  /// margin in points from the right edge of the parent to the last tick
  //int rightMargin;

  /// amount of minimum space between labels, so they don't look crowded
  num minSpaceBetweenLabels;

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
  NumericAxis(num this.min, num this.max, {List<num> this.ticks, List<String> this.tickLabels, String this.label: '',
    num this.margin: 30, num this.minSpaceBetweenLabels: 10}) {
    assert(min <= max);

    if (ticks == null)
      ticks = calculateTicks(min, max);

    //print('ticks are: ${ticks.join(',')}');
    fmt = new TextFormat("Arial", 14, Color.Black, align: TextFormatAlign.CENTER);

  }

  draw() {
    if (_axisLength == null) {
      if (parent != null) {
        _axisLength = parent.width;
      } else {
        throw('axisLength is null and parent is not set yet!');
      }
    }

    scale = (num x) => ((x - min) * (_axisLength - 2*margin) /(max - min) + margin).truncate();

    // draw the axis
    graphics.moveTo(0.5, y);
    graphics.lineTo(_axisLength-0.5, y);

    // add the ticks
    _makeTicks().forEach((tick) => addChild(tick));

    graphics.strokeColor(Color.Black);
  }

  List<Tick> _makeTicks() {
    List _ticks = [];

    if (tickLabels == null) {
      _makeTickLabels();
    } else {
      // if tickLabels are provided, they need to match the length of the ticks
      assert(tickLabels.length == ticks.length);
    }

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


  _makeTickLabels() {
    Function fmtLabel;
    num range10 = (math.log(max - min)*math.LOG10E);
    print('range10: $range10');
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