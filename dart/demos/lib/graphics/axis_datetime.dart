library graphics.axis_datetime;

import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'package:demos/datetime/utils.dart';
import 'package:demos/math/utils.dart';


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
  List<DateTime> headers = [];
  List<String> headerLabels = [];
  String headerType;

  /**
   * Calculate the ticks, the panel and the label.
   */
  calculateTicks() {
    List<num> _defaultTicks;

    Duration duration = end.difference(start);
    int _nDays = duration.inDays;
    int _nMths = (12 * end.year + end.month) - (12 * start.year + start.month) + 1;
    int _nYears = end.year - start.year + 1;
    DateTime current;

    //print('nDays: $_nDays, nMths: $_nMths, nYears: $_nYears');
    if (_nDays <= 3) {
      headerType = "DAY";
    } else if (_nMths <= 6) {
      headerType = "MONTH";
    } else if (_nYears <= 1) {
      headerType = "YEAR";
    }

    switch (headerType) {
      case 'DAY':
        headers = seqDays(start, end);
        headerLabels = headers.map((dt) => dMMMyy.format(dt)).toList();
        if (_nDays < 1) {
          _defaultTicks = [1, 8, 15, 22];
        } else if (_nDays == 1) {
          _defaultTicks = [0, 6, 12, 18, 24];
        } else if (_nDays <= 3) {
          _defaultTicks = [0, 8, 16];
        }
        ticks = headers.expand((day) => _defaultTicks
        .map((hour) => new DateTime(day.year, day.month, day.day, hour)))
        .where((dt) => !dt.isAfter(end))
        .toList();
        break;
      case 'MONTH':
        headers = seqMonths(start, end);
        if (isBeginningOfMonth(end))
          headers.removeLast();
        headerLabels = headers.map((dt) => MMMyy.format(dt)).toList();
        if (_nMths <= 3) {
          current = new DateTime(start.year, start.month, (start.day~/7)*7+1);
          DateTime to = new DateTime(end.year, end.month, (end.day~/7+1)*7+1);
          if (isBeginningOfMonth(end))
            to = end;
          for (DateTime header in headers) {
            print('header = $header');
            while ((current.isBefore(to) || current.isAtSameMomentAs(to)) && current.day < 23) {
              ticks.add(current);
              current = current.add(new Duration(days: 7));
            }
            current = nextMonth(header);
          }


        } else if (_nMths <= 5){
          current = new DateTime(start.year, start.month, (start.day~/14)*14+1);
          DateTime to = new DateTime(end.year, end.month, (end.day~/14+1)*14+1);
          if (isBeginningOfMonth(end))
            to = end;
          for (DateTime header in headers) {
            print('header = $header');
            while ((current.isBefore(to) || current.isAtSameMomentAs(to)) && current.day < 16) {
              ticks.add(current);
              current = current.add(new Duration(days: 14));
              if (currentMonth(current) != header)
                break;
            }
            current = nextMonth(header);
          }


        } else {
          current = new DateTime(start.year, start.month, 1);
          while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
            ticks.add(current);
            current = nextMonth(current);
          }
        }
//        if (isBeginningOfMonth(end))
//          ticks.add(end);
        break;
      case 'YEAR':
        if (_nYears <= 2) {
          ticks = seqMonths(new DateTime(start.year, start.month),
          nextMonth(new DateTime(end.year, end.month)));
        } else if (_nYears <= 5) {
          ticks = seqMonths(new DateTime(start.year, start.month),
          nextMonth(new DateTime(end.year, end.month)), step: 6);
        } else {
          ticks = seqNum(start.year, end.year + 1).map((year) => new DateTime(year)).toList();
        }
        break;
    }


  }


}