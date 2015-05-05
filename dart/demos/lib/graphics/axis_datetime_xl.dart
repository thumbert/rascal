library graphics.axis_datetime_xl;

import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/axis_datetime.dart';

/**
 * An implementation of a DateTime axis that should be used from StageXL.
 */
class DateTimeAxisXl extends Sprite with DateTimeAxis {

  DateTimeAxisXL(DateTime start, DateTime end) {
    this.start = start;
    this.end = end;
    assert(start.isBefore(end));
    calculateTicks();
  }


  draw() {
    var _width = parent.width;
    print('width is $width, parent width is $_width, parentName is ${parent.name}');
    var range = extEnd.millisecondsSinceEpoch - extStart.millisecondsSinceEpoch;
    scale = (DateTime x) => ((x.millisecondsSinceEpoch - extStart.millisecondsSinceEpoch) * (_width-2*margin) / range + margin).round();

    for (int h=0; h<headers.length; h++) {
      num _width = 10;
      addChild(new HeaderXl(headerLabels[h], _width, 20));
    }

    for (int i=0; i<ticks.length; i++) {
      print(scale(ticks[i]));
      graphics.moveTo(scale(ticks[i]), y+24);
      graphics.lineTo(scale(ticks[i]), y+34);
    }
    graphics.strokeColor(Color.Black);


  }
}

class HeaderXl extends Sprite {
  final fmt = new TextFormat("Arial", 14, Color.Black, align: TextFormatAlign.CENTER);

  HeaderXl(String label, int width, int height) {
    graphics.rect(0, 0, width, height);
    graphics.strokeColor(Color.Black, 1, JointStyle.MITER);
    graphics.fillColor(Color.Wheat);

    TextField text = new TextField()
      ..defaultTextFormat = fmt
      ..autoSize = TextFieldAutoSize.CENTER
      ..text = label;
    addChild(text);
  }
}