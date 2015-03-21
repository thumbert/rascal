library axis_numeric;

import 'dart:math';
import 'package:intl/intl.dart';
import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/ticks_numeric.dart';



/**
 * A Numeric axis.
 */
class NumericAxis extends Sprite {

  List<num> ticks;
  List<String> tickLabels;
  num min, max;

  // go from a num to a screen coordinate;
  Function scale;
  // the label gets under the ticks to clarify the meaning of the ticks
  String label;

  // margin in points from the edges of the parent
  int _margin = 10;

  NumericAxis(num this.min, num this.max, {String this.label: ''}) {
    assert(min <= max);

    ticks = calculateTicks(min, max);
    print('ticks are: ${ticks.join(',')}');
  }

  draw() {
    var _width = parent.width;
    var range = max - min;
    scale = (num x) => ((x - min)*(_width-2*_margin) / range + _margin).round();

    print('x: $x, y: $y');
    print('width is $width, parent width is ${parent.width}, parentName is ${parent.name}');
    graphics.moveTo(0, y);
    graphics.lineTo(parent.width, y);
    for (int i=0; i<ticks.length; i++) {
      print('i: $i, ${scale(ticks[i])}');
      graphics.moveTo(scale(ticks[i]), y);
      graphics.lineTo(scale(ticks[i]), y+10);
    }
    graphics.strokeColor(Color.Black);
  }



}