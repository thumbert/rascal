library graphics.axis_datetime;

import 'package:intl/intl.dart';
import 'package:demos/datetime/utils.dart';
import 'package:demos/math/utils.dart';
import 'package:demos/graphics/axis_datetime_utils.dart';

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
  DateTime extStart, extEnd;

  /// go from a DateTime to a screen coordinate;
  Function scale;

  /// the label gets under the ticks to clarify the meaning of the ticks
  String label = '';

  /// margin in points from the edges of the parent
  num margin = 10;

  /// the headers are the categorical groups one level higher than the ticks.
  /// e.g. if the ticks are days, the headers are months, etc.
  List<DateTimeAxisHeader> headers = [];
  String _headerType;

  /**
   * Calculate the ticks, the panel and the label.
   */
  calculateTicks() {
    Duration duration = end.difference(start);
    int _nDays = duration.inDays;
    int _nMths = (12 * end.year + end.month) - (12 * start.year + start.month) + 1;
    int _nYears = end.year - start.year + 1;

    //print('nDays: $_nDays, nMths: $_nMths, nYears: $_nYears');
    if (_nDays <= 6) {
      _headerType = 'DAY';
    } else if (_nMths <= 5) {
      _headerType = 'MONTH';
    } else if (_nYears <= 5) {
      _headerType = 'YEAR';
    } else {
      _headerType = '';
    }

    switch (_headerType) {
      case 'DAY':
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
        break;


      case 'MONTH':
        headers = seqMonths(start, end)
          .map((dt) => new DateTimeAxisHeader(dt, HeaderType.MONTH)).toList();;
        if (isBeginningOfMonth(end))
          headers.removeLast();
        if (_nMths <= 3) {
          ticks = coverDays(start, end, 7);
        } else {
          ticks = coverDays(start, end, 14);
        }
        break;


      case 'YEAR':
        headers = seqNum(start.year, end.year)
          .map((yr) => new DateTimeAxisHeader(new DateTime(yr), HeaderType.YEAR)).toList();
        DateTime to = end;
        if (!isBeginningOfMonth(end))
          to = nextMonth(end);
        if (_nMths <= 12) {
          ticks = seqMonths(new DateTime(start.year, start.month),
          new DateTime(to.year, to.month));
        } else if (_nYears <= 3) {
          ticks = seqMonths(new DateTime(start.year, start.month),
          new DateTime(to.year, to.month), step: 3);
        } else if (_nYears <= 5) {
          ticks = seqMonths(new DateTime(start.year, start.month),
          new DateTime(to.year, to.month), step: 6);
        } else {
          ticks = seqNum(start.year, end.year + 1).map((year) => new DateTime(year)).toList();
        }
        break;
    }


  }


}
