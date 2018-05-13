import 'package:timezone/timezone.dart';
import 'package:date/date.dart';
import 'holiday.dart';

class IndependenceDay implements Holiday {
  String name = 'Independence Day';
  Date _date;

  IndependenceDay();

  Date get date => _date;
  set date(Date d) {
    if (date.month != 7 || date.day != 4)
      throw new ArgumentError('Not 4th of July!');
    _date = d;
  }

  /// Get all the independence days in this interval
  List<Date> getHolidays(Interval interval) {
    var res = [];
    TZDateTime start = interval.start;
    var current = new Date(start.year, 7, 4, location: start.location);
    if (current.isBefore(new Date.fromTZDateTime(interval.end))) {
      res.add(current);
      current = new Date(current.year + 1, 7, 4);
    }
    return res;
  }
}

/// If 7/4 Independence Day falls on Sun, NERC moves it to Mon.
/// If 7/4 falls on every other day, it stays where it is.
class NercIndependenceDay implements Holiday {
  String name = 'Independence Day';
  Date _date;

  NercIndependenceDay();

  Date get date => _date;
  set date(Date d) {
    int day = 4;
    if (d.weekday == 7) day = 5;
    if (date.month != 7 || date.day != day)
      throw new ArgumentError('Not NERC 4th of July!');
    _date = d;
  }

  /// Get all the independence days in this interval
  List<Date> getHolidays(Interval interval) {
    var res = [];
    TZDateTime start = interval.start;
    var current = new Date(start.year, 7, 4, location: start.location);
    if (current.isBefore(new Date.fromTZDateTime(interval.end))) {
      res.add(current);
      current = new Date(current.year + 1, 7, 4);
    }
    return res;
  }
}
