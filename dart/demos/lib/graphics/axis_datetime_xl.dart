library graphics.axis_datetime_xl;

import 'dart:math';
import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/axis_datetime.dart';
import 'package:demos/graphics/axis_datetime_utils.dart';

/**
 * An implementation of a DateTime axis that should be used from StageXL.
 */
class DateTimeAxisXl extends Sprite with DateTimeAxis {
  final fmt =
    new TextFormat("Arial", 20, Color.Black, align: TextFormatAlign.CENTER);

  DateTimeAxisXl(
      DateTime start, DateTime end, {List<DateTime> ticks, String label}) {
    this.start = start;
    this.end = end;
    assert(start.isBefore(end));

    if (ticks == null) defaultTicks();

    this.label ??= label;
  }

  draw() {
    var _width = parent.width;
    print(
        'width is $width, parent width is $_width, parentName is ${parent.name}');
    var range = end.millisecondsSinceEpoch - start.millisecondsSinceEpoch;
    scale = (DateTime x) => ((x.millisecondsSinceEpoch -
                start.millisecondsSinceEpoch) *
            (_width - 2 * margin) /
            range +
        margin).round();

    print(ticks);
    print(tickLabels);

    /// draw the headers
    for (int h = 0; h < headers.length; h++) {
      num xS = max(scale(headers[h].start), 0);
      num xE = min(scale(headers[h].end), _width);
      addChild(new HeaderXl(headers[h], xE - xS, headerHeight)..x = xS);
    }

    /// draw the ticks
    for (int i = 0; i < ticks.length; i++) {
      //print(scale(ticks[i]));
      graphics.moveTo(scale(ticks[i]), headerHeight);
      graphics.lineTo(scale(ticks[i]), headerHeight + 10);
    }
    graphics.strokeColor(Color.Black);

    /// draw the tick labels
    //print(tickLabels);
    for (int i = 0; i < ticks.length; i++) {
      TextField text = new TextField()
        ..defaultTextFormat = fmt
        ..autoSize = TextFieldAutoSize.CENTER
        ..text = tickLabels[i]
        ..y = headerHeight + 10;
      text.x = scale(ticks[i]) - text.width/2;
      addChild(text);
    }
  }
}

class HeaderXl extends Sprite {
  final fmt =
      new TextFormat("Arial", 20, Color.Black, align: TextFormatAlign.CENTER);

  /**
   * Draw the header.
   * [width] is the screen width in pixels
   * [height] is the screen height in pixels
   */
  HeaderXl(DateTimeAxisHeader header, num width, num height) {
    graphics.rect(0, 0, width, height);
    graphics.strokeColor(Color.Black, 1, JointStyle.MITER);
    graphics.fillColor(Color.Wheat);

    TextField text = new TextField()
      ..defaultTextFormat = fmt
      ..autoSize = TextFieldAutoSize.CENTER
      ..text = header.text;
    text.x = width/2 - text.width/2;
    /// check if the label fits before adding it
    if (width > text.width)
      addChild(text);
  }
}
