library holiday;

import 'package:timeseries/time/date.dart';

/**
 *  http://en.wikipedia.org/wiki/Federal_holidays_in_the_United_States
 */
class Holiday {
  static final Duration duration = new Duration(days: 1);
  Date day;
  String name;
  
  Holiday();
  Holiday.from(Date this.day);
  
  toString() => day.toString();
  
  static Holiday christmas(int year) => 
      new Holiday.from( new Date(year, 12, 25))..name="Christmas";

  static Holiday fourthOfJuly(int year) => 
       new Holiday.from( new Date(year, 7, 4))..name="4th July";
  
  /**
   * Labor Day, 1st Monday in Sep
   */
  static Holiday laborDay(int year) =>
    _makeHoliday(year, DateTime.SEPTEMBER, 1, DateTime.MONDAY)..name="Labor Day";
    
  
  /**
   * Martin Luther King holiday, 3rd Monday in Jan
   */
  static Holiday martinLutherKing(int year) =>
    _makeHoliday(year, DateTime.JANUARY, 3, DateTime.MONDAY)..name="Martin Luther King";
  
 
  /**
   * Thanksgiving holiday, 4rd Thursday in Nov
   */
  static Holiday thanksgiving(int year) =>
    _makeHoliday(year, DateTime.NOVEMBER, 4, DateTime.THURSDAY)..name = "Thanksgiving";

  /**
   * Memorial day is on last Monday in May
   */
  static Holiday memorialDay(int year) { 
    int wday_eom = new Date(year, 5, 31).weekday;
    return new Holiday()
      ..day = new Date(year, 5, 32 - wday_eom)
      ..name = "Memorial Day";
  }
  
  static Holiday newYearsEve(int year) => 
      new Holiday.from( new Date(year, 1, 1))..name="New Year's Eve";
  
  /**
   * Make a holiday if you know the month, week of the month, and weekday
   */
  static Holiday _makeHoliday(int year, int month, int weekOfMonth, int weekday) {
    int wday_bom = new DateTime(year, month, 1).weekday;
    int inc = weekday - wday_bom;
    if  (inc < 0) 
      inc += 7;
    
    return new Holiday()..day = new Date(year, month, 7*(weekOfMonth-1) + inc + 1);
  }
}



