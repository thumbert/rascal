library time.calendar;

import 'package:timeseries/time/date.dart';
import 'package:timeseries/time/holiday.dart';


abstract class Calendar {
  bool isHoliday(Date day);
}

class NercCalendar extends Calendar {
  bool isHoliday(Date date) {
    bool res = false;
    if (date.month == 1 && Holiday.isNewYearsEve(date))
      res = true;
    else if (date.month == 7 && Holiday.isFourthOfJuly(date))
      res = true;
    else if (date.month == 9 && Holiday.isLaborDay(date))
      res = true;
    else if (date.month == 11 && Holiday.isThanksgiving(date))
      res = true;
    else if (date.month == 12 && Holiday.isChristmas(date))
      res = true;

    return res;
  }
}