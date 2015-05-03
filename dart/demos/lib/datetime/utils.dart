library datetime.utils;


/**
 * Check if a DateTime is beginning of a day.
 */
bool isBeginningOfDay(DateTime dt) {
  if (dt.hour !=0 || dt.minute !=0 || dt.second !=0 || dt.millisecond !=0 )
    return false;
  return true;
}

bool isMidnight(DateTime dt) => isBeginningOfDay(dt);

/**
 * Check if a DateTime is beginning of a month.
 */
bool isBeginningOfMonth(DateTime dt) {
  if (dt.day != 1 || !isBeginningOfDay(dt) )
    return false;
  return true;
}


/**
 * Check if a DateTime is beginning of the year.
 */
bool isBeginningOfYear(DateTime dt) {
  if (dt.month !=1 || !isBeginningOfMonth(dt))
    return false;
  return true;
}


/**
 * Return nextDay from a given DateTime.
 */
DateTime nextDay({DateTime from}) {
  if (from == null)
    from = new DateTime.now().toUtc();

  return new DateTime.utc(from.year, from.month, from.day).add(new Duration(days: 1));
}


/**
 * Return a sequence of day between [start, end] inclusive.
 */
List<DateTime> seqDays(DateTime start, DateTime end, {int step: 1}) {
  var d1 = new Duration(days: step);

  List<DateTime> res = [];
  var current = new DateTime(start.year, start.month, start.day);
  while (end.isAfter(current) || end.isAtSameMomentAs(current)) {
    res.add(current);
    current = current.add(d1);
  }

  return res;
}


/**
 * Return a list of beginning of the months between two DateTimes.
 * If start is not a beginning of the month, truncate it to one.
 */
List<DateTime> seqMonths(DateTime start, DateTime end, {int step: 1}) {
  List<DateTime> months = [];
  var current = new DateTime(start.year, start.month);
  while (end.isAfter(current)  || end.isAtSameMomentAs(current)) {
    months.add(current);
    var mth = 12 * current.year + current.month + step;
    current = new DateTime(mth ~/ 12, mth % 12);;
  }

  return months;
}



/**
 * Return a List of DateTimes between [start, end] inclusive.
 */
List<DateTime> seqBy(DateTime start, DateTime end, Duration by) {
  List<DateTime> res = [];
  var current = start;
  while (end.isAfter(current) || end.isAtSameMomentAs(current)) {
    res.add(current);
    current = current.add( by );
  }

  return res;
}


/**
 * Return the beginning of the month from an asOf DateTime.
 */
DateTime currentMonth(DateTime asOf) {
  var now = asOf == null ? new DateTime.now() : asOf; 
  return new DateTime(now.year, now.month);
}

/**
 * Return the beginning of next month from a given asOf DateTime.
 */
DateTime nextMonth(DateTime asOf) {
  var now = asOf == null ? new DateTime.now() : asOf; 
  int mth = 12*now.year + now.month + 1;
  return new DateTime(mth~/12, mth%12);
}

/**
 * Return the beginning of previous month from a given asOfDateTime
 */
DateTime previousMonth(DateTime asOf) {
  var now = asOf == null ? new DateTime.now() : asOf; 
  int mth = 12*now.year + now.month - 1;
  return new DateTime(mth~/12, mth%12);
}

