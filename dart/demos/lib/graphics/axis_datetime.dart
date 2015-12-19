library graphics.axis_datetime;

import 'package:intl/intl.dart';
import 'package:demos/datetime/utils.dart';
import 'package:demos/math/utils.dart';
import 'package:demos/graphics/axis_datetime_utils.dart';


Map theme = {
  /// distance in points from the edge of the plot window
  'margin': 10,

};

/**
 * A DateTime axis for the x axis.
 */
class DateTimeAxis {

  static DateFormat dMMMyy = new DateFormat('dMMMyy');
  static DateFormat MMMyy = new DateFormat('MMMyy');

  DateTime start, end;

  /// location of the ticks
  List<DateTime> ticks = [];
  List<String> tickLabels = [];

  /// may need to move the start earlier and the end later for the axis ticks
  //DateTime extStart, extEnd;

  /// go from a DateTime to a screen coordinate;
  Function scale;

  /// the label gets under the ticks to clarify the meaning of the ticks
  String label = '';

  /// margin in points from the edges of the parent
  num margin = 10;

  /// the headers are the categorical groups one level higher than the ticks.
  /// e.g. if the ticks are days, the headers are months, etc.
  List<DateTimeAxisHeader> headers = [];
  HeaderType headerType;

  /// header height in px
  num headerHeight = 20;

  DateTimeAxis() {

  }

  /**
   * Calculate the ticks, the headers and the label.
   */
  defaultTicks() {
    Duration duration = end.difference(start);
    int _nDays = duration.inDays;
    int _nMths = (12 * end.year + end.month) - (12 * start.year + start.month) + 1;
    int _nYears = end.year - start.year + 1;

    //print('nDays: $_nDays, nMths: $_nMths, nYears: $_nYears');
    if (_nDays <= 6) {
      headerType = HeaderType.DAY;
      label = 'Hour of day';
    } else if (_nMths <= 5) {
      headerType = HeaderType.MONTH;
      label = 'Day of month';
    } else if (_nYears <= 5) {
      headerType = HeaderType.YEAR;
      label = 'Month of year';
    } else {
      throw('Unknown header type!');
    }

    switch (headerType) {
      case HeaderType.DAY:
        headers = seqDays(start, end)
          .map((dt) => new DateTimeAxisHeader(dt, HeaderType.DAY)).toList();
        if (isBeginningOfDay(end))
          headers.removeLast();
        if (_nDays < 1) {
          ticks = coverHours(start, end, 1);
        } else if (_nDays == 1) {
          ticks = coverHours(start, end, 3);
        } else if (_nDays <= 3) {
          ticks = coverHours(start, end, 8);
        } else if (_nDays <= 6) {
          ticks = coverHours(start, end, 12);
        }
        tickLabels = ticks.map((DateTime tick) => tick.hour.toString()).toList();
        break;


      case HeaderType.MONTH:
        headers = seqMonths(start, end)
          .map((dt) => new DateTimeAxisHeader(dt, HeaderType.MONTH)).toList();;
        if (isBeginningOfMonth(end))
          headers.removeLast();
        if (_nMths <= 3) {
          ticks = coverDays(start, end, 7);
        } else {
          ticks = coverDays(start, end, 14);
        }
        tickLabels = ticks.map((DateTime tick) => tick.day.toString()).toList();
        break;


      case HeaderType.YEAR:
        headers = seqNum(start.year, end.year)
          .map((yr) => new DateTimeAxisHeader(new DateTime(yr), HeaderType.YEAR)).toList();
        DateTime to = end;
        if (!isBeginningOfMonth(end))
          to = nextMonth(end);
        if (_nMths <= 12) {
          /// 1 month ticks
          ticks = seqMonths(new DateTime(start.year, start.month),
          new DateTime(to.year, to.month));
        } else if (_nYears <= 3) {
          /// ticks separated by 3 months
          ticks = seqMonths(new DateTime(start.year, start.month),
          new DateTime(to.year, to.month), step: 3);
        } else if (_nYears <= 5) {
          /// ticks separated by 6 months
          ticks = coverMonths(start, end, 6);
        } else {
          ticks = seqNum(start.year, end.year + 1).map((year) => new DateTime(year)).toList();
        }
        tickLabels = ticks.map((DateTime tick) => tick.month.toString()).toList();
        break;

      default:
        throw('Unknown header!');
    }
  }
}
