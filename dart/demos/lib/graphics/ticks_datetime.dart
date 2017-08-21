library graphics.ticks_datetime;

import 'package:intl/intl.dart';
import 'package:tuple/tuple.dart';
import 'package:date/date.dart';

import 'tick_utils.dart';

/// Some common datetime tick frequencies
enum DateTimeTickFrequency {
  year,
  month,
  day,
  hour,
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
    new DateFormat('dMMMyy H:00'),
    new DateFormat('dMMM H:00'),
    new DateFormat('H:00')
  ],
  DateTimeTickFrequency.minute: [
    new DateFormat('dMMMyy H:MM'),
    new DateFormat('H:MM'),
  ],
  DateTimeTickFrequency.second: [
    new DateFormat('dMMMyy H:MM:SS'),
    new DateFormat('H:MM:SS'),
  ]
};

/// Calculate the location and format for default datetime ticks.
/// Note that both start/end datetimes are inclusive.
/// All returned ticks will be in the [start,end] interval, but
/// the [start] and [end] are not guaranteed to be a tick.
Tuple2<DateTimeTickFrequency, List<DateTime>> defaultTicksDateTime(
    DateTime start, DateTime end,
    {TickCoverType tickCoverType: TickCoverType.undercover}) {
  Tuple2 res;
  DateTimeTickFrequency frequency = getTickFrequency(start, end);
  switch (frequency) {
    case DateTimeTickFrequency.year:
      res = _coverWithYears(start, end, tickCoverType: tickCoverType);
      break;
    case DateTimeTickFrequency.month:
      res = _coverWithMonths(start, end, tickCoverType: tickCoverType);
      break;
    case DateTimeTickFrequency.day:
      res = _coverWithDays(start, end, tickCoverType: tickCoverType);
      break;
    case DateTimeTickFrequency.hour:
      res = _coverWithHours(start, end, tickCoverType: tickCoverType);
      break;
    case DateTimeTickFrequency.minute:
      res = _coverWithMonths(start, end, tickCoverType: tickCoverType);
      break;
    case DateTimeTickFrequency.second:
      res = _coverWithMonths(start, end, tickCoverType: tickCoverType);
      break;
  }

  return res;
}

DateTimeTickFrequency getTickFrequency(DateTime start, DateTime end) {
  Duration duration = end.difference(start);
  DateTimeTickFrequency freq;
  if (duration.inDays >= 3) {
    if (duration.inDays <= 60) {
      freq = DateTimeTickFrequency.day;
    } else if (duration.inDays <= 400) {
      freq = DateTimeTickFrequency.month;
    } else {
      freq = DateTimeTickFrequency.year;
    }
  } else {
    if (duration.inSeconds <= 6) {
      freq = DateTimeTickFrequency.second;
    } else if (duration.inSeconds <= 6 * 60) {
      freq = DateTimeTickFrequency.minute;
    } else if (duration.inSeconds <= 26 * 3600) {
      freq = DateTimeTickFrequency.hour;
    } else {
      freq = DateTimeTickFrequency.day;
    }
  }

  return freq;
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
  int nDays = endDate.value - startDate.value;
  int step ;
  if (nDays <= 6) {
    step = 1;
  } else if (nDays <= 10) {
    step = 2;
  } else if (nDays <= 25) {
    step = 5;
  } else {
    step = 10;
  }
  List days = new TimeIterable(startDate, endDate, step: step)
      .map((Date e) => e.start)
      .toList();
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
  int nHours = endHour.difference(startHour).inHours;
  int step = 1;
  if (nHours >= 6 && nHours <= 27) {
    step = 6;
  } else if (nHours <= 50) {
    step = 12;
  }
  List hours = [];
  var duration = new Duration(hours: step);
  var current = startHour;
  while (!endHour.isBefore(current)) {
    hours.add(current);
    current = current.add(duration);
  }

  return new Tuple2(DateTimeTickFrequency.hour, hours);
}
