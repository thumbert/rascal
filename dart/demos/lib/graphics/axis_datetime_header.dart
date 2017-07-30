library graphics.axis_datetime_header;

import 'dart:math' show max, min;
import 'package:stagexl/stagexl.dart';
import 'package:intl/intl.dart';
import 'package:demos/datetime/utils.dart';
import 'package:demos/math/utils.dart';

import 'axis_datetime_utils.dart';
import 'axis.dart';
import 'scale.dart';

/// A DateTime axis
/// Currently only for the x axis.
class DateTimeAxis extends Axis {
  static DateFormat dMMMyy = new DateFormat('dMMMyy');
  static DateFormat MMMyy = new DateFormat('MMMyy');
  final fmt =
      new TextFormat("Arial", 20, Color.Black, align: TextFormatAlign.CENTER);

  DateTime start, end;
  Position position;

  /// location of the ticks
  List<DateTime> tickLocations = [];
  List<String> tickLabels = [];

  /// may need to move the start earlier and the end later for the axis ticks
  //DateTime extStart, extEnd;

  /// go from a DateTime to a screen coordinate;
  Scale scale;

  /// the label gets under the ticks to clarify the meaning of the ticks
//  String label = '';

  /// margin in points from the edges of the parent
  num margin = 10;

  /// the headers are the categorical groups one level higher than the ticks.
  /// e.g. if the ticks are days, the headers are months, etc.
  List<DateTimeAxisHeader> headers = [];
  HeaderType headerType;

  /// header height in px
  num headerHeight = 24;

  DateTimeAxis(this.scale, this.position, {List<DateTime> tickLocations}) {
    start = scale.x1;
    end = scale.x2;
    assert(start.isBefore(end));

    if (tickLocations == null) defaultTicks();

    draw();
  }

  draw() {
    var _width = scale.y2 - scale.y1;
    print('drawing the datetime axis');
    print('tickLocations: $tickLocations');
    print('tickLabels: $tickLabels');
    print('headers: $headers');

    /// draw the headers
    for (int h = 0; h < headers.length; h++) {
      num xS = max(scale(headers[h].start), 0);
      num xE = min(scale(headers[h].end), _width);
      addChild(new HeaderXl(headers[h], xE - xS, headerHeight)..x = xS);
    }

    /// draw the ticks
    for (int i = 0; i < tickLocations.length; i++) {
      //print(scale(ticks[i]));
      graphics.moveTo(scale(tickLocations[i]), headerHeight);
      graphics.lineTo(scale(tickLocations[i]), headerHeight + 10);
    }
    graphics.strokeColor(Color.Black);

    /// draw the tick labels
    for (int i = 0; i < tickLocations.length; i++) {
      TextField text = new TextField()
        ..defaultTextFormat = fmt
        ..autoSize = TextFieldAutoSize.CENTER
        ..text = tickLabels[i]
        ..y = headerHeight + 10;
      text.x = scale(tickLocations[i]) - text.width / 2;
      addChild(text);
    }
  }

  /// Calculate the ticks, the headers and the label.
  defaultTicks() {
    Duration duration = end.difference(start);
    int _nDays = duration.inDays;
    int _nMths =
        (12 * end.year + end.month) - (12 * start.year + start.month) + 1;
    int _nYears = end.year - start.year + 1;

    //print('nDays: $_nDays, nMths: $_nMths, nYears: $_nYears');
    if (_nDays <= 6) {
      headerType = HeaderType.DAY;
      label = new TextField()..text = 'Hour of day';
    } else if (_nMths <= 5) {
      headerType = HeaderType.MONTH;
      label = new TextField()..text = 'Day of month';
    } else if (_nYears <= 5) {
      headerType = HeaderType.YEAR;
      label = new TextField()..text = 'Month of year';
    } else {
      headerType = null;
      label = new TextField()..text = '';
    }

    switch (headerType) {
      case HeaderType.DAY:
        headers = seqDays(start, end)
            .map((dt) => new DateTimeAxisHeader(dt, HeaderType.DAY))
            .toList();
        if (isBeginningOfDay(end)) headers.removeLast();
        if (_nDays < 1) {
          tickLocations = coverHours(start, end, 1);
        } else if (_nDays == 1) {
          tickLocations = coverHours(start, end, 3);
        } else if (_nDays <= 3) {
          tickLocations = coverHours(start, end, 8);
        } else if (_nDays <= 6) {
          tickLocations = coverHours(start, end, 12);
        }
        tickLabels =
            tickLocations.map((DateTime tick) => tick.hour.toString()).toList();
        break;

      case HeaderType.MONTH:
        headers = seqMonths(start, end)
            .map((dt) => new DateTimeAxisHeader(dt, HeaderType.MONTH))
            .toList();
        ;
        if (isBeginningOfMonth(end)) headers.removeLast();
        if (_nMths <= 3) {
          tickLocations = coverDays(start, end, 7);
        } else {
          tickLocations = coverDays(start, end, 14);
        }
        tickLabels =
            tickLocations.map((DateTime tick) => tick.day.toString()).toList();
        break;

      case HeaderType.YEAR:
        headers = seqNum(start.year, end.year)
            .map((yr) =>
                new DateTimeAxisHeader(new DateTime(yr), HeaderType.YEAR))
            .toList();
        DateTime to = end;
        if (!isBeginningOfMonth(end)) to = nextMonth(end);
        if (_nMths <= 12) {
          /// 1 month ticks
          tickLocations = seqMonths(new DateTime(start.year, start.month),
              new DateTime(to.year, to.month));
        } else if (_nYears <= 3) {
          /// ticks separated by 3 months
          tickLocations = seqMonths(new DateTime(start.year, start.month),
              new DateTime(to.year, to.month),
              step: 3);
        } else if (_nYears <= 5) {
          /// ticks separated by 6 months
          tickLocations = coverMonths(start, end, 6);
        } else {
          tickLocations = seqNum(start.year, end.year + 1)
              .map((year) => new DateTime(year))
              .toList();
        }
        tickLabels = tickLocations
            .map((DateTime tick) => tick.month.toString())
            .toList();
        break;

      default:
        throw ('Unknown header!');
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
    text.x = width / 2 - text.width / 2;
    text.y = -1;

    /// check if the label fits before adding it
    if (width > text.width) addChild(text);
  }
}
