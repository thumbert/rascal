
import 'package:date/date.dart';

enum HolidayType {
  state,
  federal
}

abstract class Holiday {
  /// Get all the holidays in this interval
  //List<Date> getHolidays(Interval interval);
}

class IndependenceDay implements Holiday {
  Date day;
  String name = 'Independence Day';
  IndependenceDay.from(this.day){
    /// Check that it is 4th of July ...
  }

  static List<Date> getHolidays(Interval interval) {

  }
}

class Calendar {
  Interval interval;
  Map<Date,Holiday> cache;
  Calendar(this.interval, {this.cache}) {
    cache ??= {};
  }
  bool isHoliday(Date date) => cache.containsKey(date);
}

class NercCalendar implements Calendar {
  Interval interval;
  Map<Date,Holiday> cache;
  NercCalendar(this.interval) {
    var iday = IndependenceDay.getHolidays(interval);
    cache.addAll(new Map.fromIterables(iday, iday.map((day) => new IndependenceDay.from(day))));
  }
  bool isHoliday(Date date) => cache.containsKey(date);
}





class CalendarCtStateHolidays extends Calendar {
  CalendarCtStateHolidays(Interval interval) {

  }
}

class CalendarCt extends Calendar {
  CalendarCt(Interval interval) {
    this.interval = interval;
    cache.addAll(new NercCalendar(interval).cache);
    cache.addAll(new CalendarCtStateHolidays(interval).cache);
  }
}
