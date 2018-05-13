
import 'package:date/date.dart';
import 'holiday.dart';

/// A calendar class to keep track of special days.
class Calendar {
  Interval interval;
  Map<Date, Holiday> cache = {};
  Calendar(this.interval, {this.cache});
  bool isHoliday(Date date) => cache.containsKey(date);
}
