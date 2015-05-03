library graphics.axis_datetime_xl;

import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/axis_datetime.dart';

/**
 * An implementation of a DateTime axis that should be used from StageXL.
 */
class DateTimeAxisXL extends Sprite with DateTimeAxis {
  DateTime start, end;

  DateTimeAxisXL(this.start, this.end) {
    assert(start.isBefore(end));
    calculateTicks();
  }


  draw() {
    var _width = parent.width;
    print('width is $width, parent width is $_width, parentName is ${parent.name}');
    var range = extEnd.millisecondsSinceEpoch - extStart.millisecondsSinceEpoch;
    scale = (DateTime x) => ((x.millisecondsSinceEpoch - extStart.millisecondsSinceEpoch) * (_width-2*_margin) / range + _margin).round();

    graphics.rect(scale(ticks[0]), y, scale(ticks.last)-scale(ticks[0]), y+24);
    graphics.strokeColor(Color.Black, 1, JointStyle.MITER);
    graphics.fillColor(Color.Wheat);

    for (int i=0; i<ticks.length; i++) {
      print(scale(ticks[i]));
      graphics.moveTo(scale(ticks[i]), y+24);
      graphics.lineTo(scale(ticks[i]), y+34);
    }
    graphics.strokeColor(Color.Black);


  }


}