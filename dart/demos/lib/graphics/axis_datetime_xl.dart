library graphics.axis_datetime_xl;

import 'dart:math';
import 'package:stagexl/stagexl.dart';
import 'axis_datetime.dart';
import 'axis_datetime_utils.dart';
import 'scale.dart';
import 'axis.dart';

/// An implementation of DateTime axis for StageXL
//class DateTimeAxisXl extends Axis  {
//  final fmt =
//    new TextFormat("Arial", 20, Color.Black, align: TextFormatAlign.CENTER);
//
//
//  DateTime start, end;
//  Scale scale;
//  Position position;
//
//  DateTimeAxisXl(this.scale, this.position, {List<DateTime> tickLocations}) {
//    start = new DateTime.fromMillisecondsSinceEpoch(scale.x1);
//    end = new DateTime.fromMillisecondsSinceEpoch(scale.x2);
//    assert(start.isBefore(end));
//
//    if (tickLocations == null) defaultTicks();
//
//    draw();
//  }
//
//  draw() {
//    var _width = scale.y2 - scale.y1;
//    print(tickLocations);
//    print(tickLabels);
//
//    /// draw the headers
//    for (int h = 0; h < headers.length; h++) {
//      num xS = max(scale(headers[h].start), 0);
//      num xE = min(scale(headers[h].end), _width);
//      addChild(new HeaderXl(headers[h], xE - xS, headerHeight)..x = xS);
//    }
//
//    /// draw the ticks
//    for (int i = 0; i < tickLocations.length; i++) {
//      //print(scale(ticks[i]));
//      graphics.moveTo(scale(tickLocations[i]), headerHeight);
//      graphics.lineTo(scale(tickLocations[i]), headerHeight + 10);
//    }
//    graphics.strokeColor(Color.Black);
//
//    /// draw the tick labels
//    for (int i = 0; i < tickLocations.length; i++) {
//      TextField text = new TextField()
//        ..defaultTextFormat = fmt
//        ..autoSize = TextFieldAutoSize.CENTER
//        ..text = tickLabels[i]
//        ..y = headerHeight + 10;
//      text.x = scale(tickLocations[i]) - text.width/2;
//      addChild(text);
//    }
//  }
//}

