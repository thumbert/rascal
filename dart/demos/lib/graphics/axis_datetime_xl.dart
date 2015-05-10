library graphics.axis_datetime_xl;

import 'dart:math';
import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/axis_datetime.dart';

/**
 * An implementation of a DateTime axis that should be used from StageXL.
 */
class DateTimeAxisXl extends Sprite with DateTimeAxis {
  DateTimeAxisXL(
      DateTime start, DateTime end, List<DateTime> ticks, String label) {
    this.start = start;
    this.end = end;
    assert(start.isBefore(end));

    if (ticks == null) defaultTicks();

    if (label != null) this.label = label;
  }

  draw() {
    var _width = parent.width;
    print(
        'width is $width, parent width is $_width, parentName is ${parent.name}');
    var range = extEnd.millisecondsSinceEpoch - extStart.millisecondsSinceEpoch;
    scale = (DateTime x) => ((x.millisecondsSinceEpoch -
                extStart.millisecondsSinceEpoch) *
            (_width - 2 * margin) /
            range +
        margin).round();

    for (int h = 0; h < headers.length; h++) {
      num xS = max(scale(headers[h].start), 0);
      num xE = min(scale(headers[h].end), _width);
      addChild(new HeaderXl(headers[h].text, xE - xS, 20)..x = xS);
    }

    for (int i = 0; i < ticks.length; i++) {
      print(scale(ticks[i]));
      graphics.moveTo(scale(ticks[i]), y + 24);
      graphics.lineTo(scale(ticks[i]), y + 34);
    }
    graphics.strokeColor(Color.Black);
  }
}

class HeaderXl extends Sprite {
  final fmt =
      new TextFormat("Arial", 14, Color.Black, align: TextFormatAlign.CENTER);

  HeaderXl(String label, int width, int height) {
    graphics.rect(0, 0, width, height);
    graphics.strokeColor(Color.Black, 1, JointStyle.MITER);
    graphics.fillColor(Color.Wheat);

    TextField text = new TextField()
      ..defaultTextFormat = fmt
      ..autoSize = TextFieldAutoSize.CENTER
      ..text = label;
    //TODO:  check if the label fits!
    addChild(text);
  }
}
