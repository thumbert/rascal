library graphics.ticks_datetime;

import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'package:date/date.dart';

import 'tick_utils.dart';

enum DateTimeTickFrequency {
  year,
  month,
  day,
  hour,
  m30, // 30 minutes
  m15, // 15 minutes
  m5, //  5 minutes
  minute, //  1 minute
  second //  1 second
}

/// Return a function that will format your datetime.  The formatter will take
/// a datetime and return a list of strings progressively shorter strings.
defaultDateTimeTickFormatter(DateTimeTickFrequency freq) => (DateTime dt) =>
    _dateTimeTickFormat[freq].map((DateFormat fmt) => fmt.format(dt)).toList();

Map<DateTimeTickFrequency, List<DateFormat>> _dateTimeTickFormat = {
  DateTimeTickFrequency.year: [new DateFormat('yyyy')],
  DateTimeTickFrequency.month: [new DateFormat('MMMyy'), new DateFormat('MMM')],
  DateTimeTickFrequency.day: [
    new DateFormat('dMMMyy'),
    new DateFormat('dMMM'),
    new DateFormat('d'),
  ],
  DateTimeTickFrequency.hour: [
    new DateFormat('dMMMyy HH'),
    new DateFormat('HH')
  ],
  DateTimeTickFrequency.minute: [
    new DateFormat('dMMMyy HH:MM'),
    new DateFormat('HH:MM'),
  ],
  DateTimeTickFrequency.second: [
    new DateFormat('dMMMyy HH:MM:SS'),
    new DateFormat('HH:MM:SS'),
  ]
};

/// Calculate the location and format for default datetime ticks.
/// Note that both start/end datetimes are inclusive.
/// All returned ticks will be in the [start,end] interval.
Tuple2<DateTimeTickFrequency, List<DateTime>> defaultTicksDateTime(
    DateTime start, DateTime end,
    {TickCoverType tickCoverType: TickCoverType.undercover}) {
  var res4 = _coverWithHours(start, end, tickCoverType: tickCoverType);
  if (res4.item2.length <= 25)
    return res4;
  else {
    var res3 = _coverWithDays(start, end, tickCoverType: tickCoverType);
    if (res3.item2.length <= 31)
      return res3;
    else {
      var res2 = _coverWithMonths(start, end, tickCoverType: tickCoverType);
      if (res2.item2.length <= 12)
        return res2;
      else {
        var res1 = _coverWithYears(start, end, tickCoverType: tickCoverType);
        return res1;
      }
    }
  }
}

/// cover the interval with years, see if you get more than 1 year.
Tuple2<DateTimeTickFrequency, List<DateTime>> _coverWithYears(
    DateTime start, DateTime end,
    {TickCoverType tickCoverType: TickCoverType.undercover}) {
  int startYear = start.year;
  int endYear = end.year;
  if (tickCoverType == TickCoverType.undercover && !isBeginningOfYear(start))
    ++startYear;
  if (tickCoverType == TickCoverType.overcover && !isBeginningOfYear(end))
    ++endYear;
  List years = new List.generate(
      endYear - startYear + 1, (i) => new DateTime(startYear + i));
  return new Tuple2(DateTimeTickFrequency.year, years);
}

/// cover the interval with months, see if you get more than 1 months.
Tuple2<DateTimeTickFrequency, List<DateTime>> _coverWithMonths(
    DateTime start, DateTime end,
    {TickCoverType tickCoverType: TickCoverType.undercover}) {
  Month startMonth = new Month.fromDateTime(start);
  Month endMonth = new Month.fromDateTime(end);
  if (tickCoverType == TickCoverType.undercover && !isBeginningOfMonth(start))
    startMonth = startMonth.next;
  if (tickCoverType == TickCoverType.overcover && !isBeginningOfMonth(end))
    endMonth = endMonth.next;
  List mths =
      new TimeIterable(startMonth, endMonth).map((Month e) => e.start).toList();
  return new Tuple2(DateTimeTickFrequency.month, mths);
}

/// cover the interval with months, see if you get more than 1 months.
Tuple2<DateTimeTickFrequency, List<DateTime>> _coverWithDays(
    DateTime start, DateTime end,
    {TickCoverType tickCoverType: TickCoverType.undercover}) {
  Date startDate = new Date.fromDateTime(start);
  Date endDate = new Date.fromDateTime(end);
  if (tickCoverType == TickCoverType.undercover && !isBeginningOfDay(start))
    startDate = startDate.next;
  if (tickCoverType == TickCoverType.overcover && !isBeginningOfDay(end))
    endDate = endDate.next;
  List days =
      new TimeIterable(startDate, endDate).map((Date e) => e.start).toList();
  return new Tuple2(DateTimeTickFrequency.day, days);
}

/// cover the interval with hours, see if you get more than 1 hour.
Tuple2<DateTimeTickFrequency, List<DateTime>> _coverWithHours(
    DateTime start, DateTime end,
    {TickCoverType tickCoverType: TickCoverType.undercover}) {
  var h1 = new Duration(hours: 1);
  var startHour = new DateTime(start.year, start.month, start.day, start.hour);
  var endHour = new DateTime(end.year, end.month, end.day, end.hour);
  if (tickCoverType == TickCoverType.undercover && !isBeginningOfHour(start))
    startHour = startHour.add(h1);
  if (tickCoverType == TickCoverType.overcover && !isBeginningOfHour(end))
    endHour = endHour.add(h1);
  var nHours = endHour.difference(startHour).inHours;
  List hours = [];
  var current = startHour;
  for (int h = 0; h <= nHours; h++) {
    hours.add(current);
    current = current.add(h1);
  }
  return new Tuple2(DateTimeTickFrequency.hour, hours);
}
