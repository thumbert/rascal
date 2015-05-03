library graphics.axis_datetime;

import 'package:intl/intl.dart';
import 'package:demos/datetime/utils.dart';
import 'package:demos/math/utils.dart';


/**
 * A DateTime axis for the x axis.
 */
class DateTimeAxis {

  static DateFormat ddMMMyyyy = new DateFormat('dd MMM yyyy');
  static DateFormat MMMyy = new DateFormat('MMMyy');

  DateTime start, end;
  /// location of the ticks
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

  /// the headers are the categorical groups one level higher than the ticks.
  /// e.g. if the ticks are days, the headers are months, etc.
  List<String> _header = [];


  /**
   * Calculate the ticks, the panel and the label.
   */
  calculateTicks() {
    String _headerType;
    List<num> _defaultTicks;

    Duration duration = end.difference(start);
    int _nDays = duration.inDays;
    int _nMths = (12 * end.year + end.month) - (12 * start.year + start.month);
    int _nYears = end.year - start.year + 1;

    print('nDays: $_nDays, nMths: $_nMths, nYears: $_nYears');
    if (_nDays <= 3) {
      _headerType = "DAY";
    } else if (_nMths <= 6) {
      _headerType = "MONTH";
    } else if (_nYears <= 1) {
      _headerType = "YEAR";
    }

    switch (_headerType) {
      case 'DAY':
        List days = seqDays(start, end);
        if (_nDays < 1) {
          _defaultTicks = [1, 8, 15, 22];
        } else if (_nDays == 1) {
          _defaultTicks = [0, 6, 12, 18, 24];
        } else if (_nDays <= 3) {
          _defaultTicks = [0, 8, 16];
        }
        ticks = days.expand((day) => _defaultTicks
        .map((hour) => new DateTime(day.year, day.month, day.day, hour)));
        break;
      case 'MONTH':
        List mths = seqMonths(start, end);
        if (_nMths <= 3) {
          _defaultTicks = [1, 8, 15, 22];
        } else {
          _defaultTicks = [1, 15];
        }
        ticks = mths.expand((mth) => _defaultTicks
        .map((day) => new DateTime(mth.year, mth.month, day)));
        break;
      case 'YEAR':
        if (_nYears <= 2) {
          ticks = seqMonths(new DateTime(start.year, start.month),
            nextMonth(new DateTime(end.year, end.month)));
        } else if (_nYears <= 5) {
          ticks = seqMonths(new DateTime(start.year, start.month),
            nextMonth(new DateTime(end.year, end.month)), step: 6);
        } else {
          ticks = seqNum(start.year, end.year+1).map((year) => new DateTime(year)).toList();
        }
        break;
    }


  }



}