library period;
import 'package:timeseries/time/interval.dart';

final Period ONE_YEAR = new Period(years: 1);
//const Period ONE_MONTH = Period.MONTH;



class Period {

  static final YEAR = new Period(years: 1);
  static final MONTH = new Period(months: 1);
  static final DAY = new Period(days: 1);
  static final HOUR = new Period(hours: 1);
  static final MINUTE = new Period(minutes: 1);

  final int years;
  final int months;
  final int days;
  final int hours;
  final int minutes;
  final int seconds;
  final int milliseconds;
  final int microseconds;
  Duration _duration;

  Period({int this.years: 0, int this.months: 0, int this.days: 0, int this.hours: 0, int
      this.minutes: 0, int this.seconds: 0, int this.milliseconds: 0, int this.microseconds: 0}) {
    _duration = new Duration(
        days: days,
        hours: hours,
        minutes: minutes,
        seconds: seconds,
        milliseconds: milliseconds,
        microseconds: microseconds);
  }

  /**
   * Add a DateTime to a Period to get another DateTime. 
   * TODO:  need to test for utc
   */
  DateTime next(DateTime x) {
    DateTime res = x.add(_duration);
    if (years != 0 ||
        months !=
            0) res = new DateTime(
                res.year + years,
                res.month + months,
                res.day,
                res.hour,
                res.minute,
                res.hour,
                res.millisecond);


    return res;
  }


  /**
   * Construct the interval with Period period which brackets the given datetime.
   */
  Interval currentInterval(DateTime datetime) {
    var start = trunc(datetime);

    return new Interval.fromStartEnd(start, this.next(start));
  }


  /**
   * Truncate this datetime to the this period, that is return the start datetime of the 
   * period that contains the datetime.
   */
  DateTime trunc(DateTime datetime) {
    DateTime start;
    if (years != 0) {
      start = new DateTime(datetime.year);
    } else if (months != 0) {
      start = new DateTime(datetime.year, datetime.month);
    } else if (days != 0) {
      start = new DateTime(datetime.year, datetime.month, datetime.day);
    } else if (hours != 0) {
      start = new DateTime(datetime.year, datetime.month, datetime.day, datetime.hour);
    } else if (minutes != 0) {
      start =
          new DateTime(datetime.year, datetime.month, datetime.day, datetime.hour, datetime.minute);
    } else if (seconds != 0) {
      start = new DateTime(
          datetime.year,
          datetime.month,
          datetime.day,
          datetime.hour,
          datetime.minute,
          datetime.second);
    }

    if (datetime.isUtc) start = new DateTime.utc(
        datetime.year,
        datetime.month,
        datetime.day,
        datetime.hour,
        datetime.minute,
        datetime.second);

    return start;
  }



  /**
    * Generate a list of DateTimes between a start and end DateTime.
    */
  List<DateTime> seq(DateTime start, DateTime end) {
    List<DateTime> res = [];
    while (start.isBefore(end)) {
      res.add(start);
      start = this.next(start);
    }

    return res;
  }


  /**
   * Generate a list of DateTimes of a given length, separated by this Period.
   */
  List<DateTime> seqFrom(DateTime start, int length) {
    List<DateTime> res = [];
    for (int i = 0; i < length; i++) {
      res.add(start);
      start = this.next(start);
    }

    return res;
  }




}
