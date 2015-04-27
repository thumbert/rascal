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
  int margin;
  /// margin in points from the left edge of the parent to the first tick
  int leftMargin;
  /// margin in points from the right edge of the parent to the last tick
  int rightMargin;

  /// the actual length of the axis in pixels
  num axisLength;

  /// strict == true guarantees that tick labels don't overflow the boundaries of the axis parent.
  bool strict;

  bool _haveDefaultTicks = false;
  bool _haveDefaultLabels = false;
  Function _maxMargin;


  /**
   * A numeric axis.
   *
   * [min] lowest value to represent
   * [margin] margin in points from the edges of the parent.
   *   if ticks are specified
   *   if the tickLabels are specified, then the margin is adjusted to make room (if possible)
   */
  NumericAxis(num this.min, num this.max, {List<num> this.ticks, List<String> this.tickLabels, String this.label: '',
    int this.margin: 10, bool this.strict: true}) {
    assert(min <= max);

    if (ticks == null) {
      _haveDefaultTicks = true;
      ticks = calculateTicks(min, max);
    }

    if (tickLabels == null)
    _haveDefaultLabels = true;

    ///print('ticks are: ${ticks.join(',')}');
    fmt = new TextFormat("Arial", 14, Color.Black, align: TextFormatAlign.CENTER);

  }

  draw() {
    if (axisLength == null) {
      if (parent != null) {
        axisLength = parent.width;
      } else {
        print('axisLength is null and parent is not set yet!');
      }
    }

    _maxMargin = () => axisLength ~/ 10;

    var range = max - min;
    /// construct the scale function after you have the tick widths, i.e. determine the
    /// margin such that the axis fits inside the parent.
    scale = (num x) => ((x - min) * (axisLength - 2*margin) / range + margin).round();
    Function fmtLabel;

    if (tickLabels == null) {
      num range10 = (math.log(max - min)*math.LOG10E);
      print('range10: $range10');
      if (range10 <= 0.6) {
        int precision = math.max(range10, 1).ceil();
        print('precision: $precision');
        fmtLabel = (num x) => (x.toStringAsFixed(precision));
      } else {
        fmtLabel = (num x) => x.toStringAsFixed(0);
      }
      tickLabels = ticks.map((e) => fmtLabel(e)).toList();
    } else {
      assert(tickLabels.length == ticks.length);
    }

    graphics.moveTo(0, y);
    graphics.lineTo(axisLength, y);

    /// generate the ticks, place them at the default location
    var _ticks = new List.generate(ticks.length,
        (i) => new Tick(tickLabels[i], Direction.DOWN)..x = scale(ticks[i]));
    var _sum = _ticks.fold(0, (num a, Tick tick) => a + tick.width);
    if (_sum > axisLength) {
      /// labels don't fit at all, so make every other label = ''
      _ticks = new List.generate(ticks.length, (i) {
        var lab = '';
        if (i % 2 == 1)
          lab = tickLabels[i];
        return new Tick(lab, Direction.DOWN)..x = scale(ticks[i]);
      });
    }

    num _left = 0;
    for (int i = 0; i < ticks.length; i++) {
      print('i: $i, ${scale(ticks[i])}');
      var x = scale(ticks[i]);
      Tick tick = new Tick(tickLabels[i], Direction.DOWN);

      // if the label doesn't fit, remove the label
      if (x - tick.width/2 < _left)
        tick = new Tick('', Direction.DOWN);
      if (x + tick.width/2 > axisLength) {
        print('too long!');
        tick = new Tick('', Direction.DOWN);
      }

      tick.x = x;
      addChild(tick);

      _left = x + tick.width/2;
    }

    graphics.strokeColor(Color.Black);




  }

//  // see if the first tickLabel fits, if it doesn't by how much you need to adjust
//  Tick tick = new Tick(tickLabels[0], Direction.DOWN);
//  var leftEdge = tick.x - tick.width/2;
//  if (leftEdge < 0) {
//
//  }


}