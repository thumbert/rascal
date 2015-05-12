library graphics.axis_datetime_utils;

import 'package:intl/intl.dart';
import 'package:demos/datetime/utils.dart';

DateFormat ddMMMyy = new DateFormat('dMMMyy');
DateFormat MMMyy = new DateFormat('MMMyy');

enum HeaderType {
  YEAR,
  MONTH,
  DAY
}

String getHeader(DateTime start, HeaderType type) {
  String text;

  switch (type) {
    case HeaderType.YEAR:
      assert(isBeginningOfYear(start));
      text = start.year.toString();
      break;
    case HeaderType.MONTH:
      assert(isBeginningOfMonth(start));
      text = MMMyy.format(start);
      break;
    case HeaderType.DAY:
      assert(isBeginningOfDay(start));
      text = ddMMMyy.format(start);
      break;
    default:
      throw('unknown type $type');
  }

  return text;
}

List<DateTime> getTicks(DateTime start, DateTime end) {
  List<DateTime> ticks = [];
  DateTime extStart, extEnd;

  Duration duration = end.difference(start);
  int _nDays = duration.inDays;
  int _nMths = (12 * end.year + end.month) - (12 * start.year + start.month);
  int _nYears = end.year - start.year + 1;

  print('nDays: $_nDays, nMths: $_nMths, nYears: $_nYears');
  if (_nDays <= 1) {
    _intraDayTicks();
    return;
  } else if (_nMths <= 24) {

  } else if ('') {
    _yearTicks();
    return;

  } else {

    if (!isBeginningOfMonth(start))
      extStart = currentMonth(asOf: start);
    else
      extStart = start;
    if (!isBeginningOfMonth(end))
      extEnd = nextMonth(asOf: end);
    else
      extEnd = end;



  }

  if (_nMths <= 3) {
    // between 1 to 3 months


  } else if (_nMths <= 6) {
    // between 3 to 6 months

  } else if (_nMths <= 12) {
    // between 6 to 12 months

  } else {
    // more than one year of data

  }


  return ticks;
}


_intraDayTicks(DateTime start, DateTime end) {
  // TODO: deal with sub-hourly frequency
  if (!isBeginningOfDay(start))
    extStart = new DateTime(start.year, start.month, start.day, start.hour);
  else
    extStart = start;
  if (!isBeginningOfDay(end))
    extEnd = new DateTime(end.year, end.month, end.day, end.hour).add(new Duration(hours: 1));
  else
    extEnd = end;

  _header = [ddMMMyyyy.format(start)];
  ticks = seqBy(extStart, extEnd, new Duration(hours: 1));
  tickLabels = ticks.map((DateTime dt) => dt.hour.toString()).toList();
  print('ticks: $ticks');
  print('tick labels: $tickLabels');
}

_yearTicks() {

}


