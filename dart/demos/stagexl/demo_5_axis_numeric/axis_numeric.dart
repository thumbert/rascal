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
  num screenLength;

  /// go from a num to a screen coordinate;
  Function scale;

  /// the label gets under the ticks to clarify the meaning of the ticks
  String label;

  /// margin in points from the edges of the parent
  int margin = 10;

  /**
   * A numeric axis.
   *
   * [min] lowest value to represent
   * [margin]  margin in points from the edges of the parent.  If margin is too little, labels may
   *  push the axis
   */
  NumericAxis(num this.min, num this.max, num this.screenLength, {List<num> this.ticks, List<String> this.tickLabels, String this.label: '',
    int this.margin: 10}) {
    assert(min <= max);

    if (ticks == null)
      ticks = calculateTicks(min, max);

    ///print('ticks are: ${ticks.join(',')}');
    fmt = new TextFormat("Arial", 14, Color.Black, align: TextFormatAlign.CENTER);

  }

  draw() {
    var range = max - min;
    /// construct the scale function after you have the tick widths, i.e. determine the
    /// margin such that the axis fits inside the parent.
    scale = (num x) => ((x - min) * (screenLength - 2*margin) / range + margin).round();
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
    graphics.lineTo(screenLength, y);
    for (int i = 0; i < ticks.length; i++) {
      //print('i: $i, ${scale(ticks[i])}');
      Tick tick = new Tick(tickLabels[i], Direction.DOWN)
        ..x = scale(ticks[i]);
      addChild(tick);
    }
    graphics.strokeColor(Color.Black);

  }


}