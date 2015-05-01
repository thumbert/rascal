library graphics.axis_datetime;

import 'package:intl/intl.dart';
import 'package:stagexl/stagexl.dart';
import 'package:demos/datetime/utils.dart';


/**
 * A DateTime axis for the x axis.
 */
class DateTimeAxis extends Sprite {

  static DateFormat ddMMMyyyy = new DateFormat('dd MMM yyyy');
  static DateFormat MMMyy = new DateFormat('MMMyy');

  DateTime start, end;
  List<DateTime> ticks;
  List<String> tickLabels;
  /// may need to move the start earlier and the end later for the axis ticks
  DateTime extStart, extEnd;

  /// go from a DateTime to a screen coordinate;
  Function scale;
  /// the label gets under the ticks to clarify the meaning of the ticks
  String label;

  /// margin in points from the edges of the parent
  num margin = 10;

  /// the headers are the categorical groups that have meaning
  List<String> _header = [];


  DateTimeAxis(this.start, this.end) {
    assert(start.isBefore(end));
    calculateTicks();
  }

  /**
   * Calculate the ticks, the panel and the label.
   */
  calculateTicks() {
    Duration duration = end.difference(start);
    int _nDays = duration.inDays;
    int _nMths = (12 * end.year + end.month) - (12 * start.year + start.month);
    int _nYears = end.year - start.year + 1;

    print('nDays: $_nDays, nMths: $_nMths, nYears: $_nYears');
    if (_nDays <= 1) {
      _intraDayTicks();
      return;
    } else if (_nMths <= 24) {

    } else if ('') {
      _yearTicks();
      return;

    } else {

      if (!isBeginningOfMonth(start))
        extStart = currentMonth(asOf: start);
      else
        extStart = start;
      if (!isBeginningOfMonth(end))
        extEnd = nextMonth(asOf: end);
      else
        extEnd = end;



    }

    if (_nMths <= 3) {
      // between 1 to 3 months


    } else if (_nMths <= 6) {
      // between 3 to 6 months

    } else if (_nMths <= 12) {
      // between 6 to 12 months

    } else {
      // more than one year of data

    }

  }

  _intraDayTicks() {
    // TODO: deal with sub-hourly frequency
    if (!isBeginningOfDay(start))
      extStart = new DateTime(start.year, start.month, start.day, start.hour);
    else
      extStart = start;
    if (!isBeginningOfDay(end))
      extEnd = new DateTime(end.year, end.month, end.day, end.hour).add(new Duration(hours: 1));
    else
      extEnd = end;

    _header = [ddMMMyyyy.format(start)];
    ticks = seqBy(extStart, extEnd, new Duration(hours: 1));
    tickLabels = ticks.map((DateTime dt) => dt.hour.toString()).toList();
    print('ticks: $ticks');
    print('tick labels: $tickLabels');
  }

  _yearTicks() {

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