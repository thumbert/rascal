library axis_numeric;

import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/ticks_numeric.dart';
import 'package:demos/graphics/tick.dart';


/**
 * A Numeric axis.
 * [min] lowest value to represent
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
  int _margin = 10;

  NumericAxis(num this.min, num this.max, {List<num> this.ticks, List<String> this.tickLabels, String this.label: ''}) {
    assert(min <= max);

    if (ticks == null)
      ticks = calculateTicks(min, max);

    ///print('ticks are: ${ticks.join(',')}');
    fmt = new TextFormat("Arial", 14, Color.Black, align: TextFormatAlign.CENTER);

  }

  draw() {
    var _width = parent.width;
    var range = max - min;
    scale = (num x) => ((x - min) * (_width - 2 * _margin) / range + _margin).round();

    int precision = 1;
    if (tickLabels == null) {
      int range10 = (math.log(max - min)*math.LOG10E).round();
      if (range10 <=0) {
        precision = math.max(-range10 + 1, 1);
      } else {
        precision = math.max(range10, 1);
      }
    }

    graphics.moveTo(0, y);
    graphics.lineTo(_width, y);
    for (int i = 0; i < ticks.length; i++) {
      print('i: $i, ${scale(ticks[i])}');
      Tick tick = new Tick(ticks[i].toStringAsPrecision(precision), Direction.DOWN)
        ..x = scale(ticks[i]);
      addChild(tick);
    }
    graphics.strokeColor(Color.Black);

  }


}