

import 'package:date/date.dart';
import 'holiday.dart';
import 'calendar.dart';
import 'independence_day.dart';

class NercCalendar implements Calendar {
  Interval interval;
  Map<Date, Holiday> cache;
  NercCalendar(this.interval) {
    var iday = new IndependenceDay().getHolidays(interval);
    cache.addAll(new Map.fromIterables(
        iday, iday.map((day) => new IndependenceDay.from(day))));
  }
  bool isHoliday(Date date) => cache.containsKey(date);
}
