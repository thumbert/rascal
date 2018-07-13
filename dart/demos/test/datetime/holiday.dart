import 'package:date/date.dart';

enum HolidayType { state, federal }

abstract class Holiday {
  Date date;
  String name;

  /// Get all the holidays in this DateTime interval
  List<Date> getHolidays(Interval interval);
}



//class CalendarCtStateHolidays implements Calendar {
//  Interval interval;
//  Map<Date, Holiday> cache;
//  CalendarCtStateHolidays(Interval interval) {
//
//  }
//  bool isHoliday(Date date) => cache.containsKey(date);
//}
//
//class CalendarCt extends Calendar {
//  CalendarCt(Interval interval) {
//    this.interval = interval;
//    cache.addAll(new NercCalendar(interval).cache);
//    cache.addAll(new CalendarCtStateHolidays(interval).cache);
//  }
//}
