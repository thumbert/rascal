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
 * Return the beginning of nextDay from a given DateTime.
 */
DateTime nextDay(DateTime from) {
  return new DateTime(from.year, from.month, from.day).add(new Duration(days: 1));
}


/**
 * Return a sequence of days between [start, end] inclusive.
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
 * Return the beginning of the day from an asOf DateTime.
 */
DateTime currentDay(DateTime asOf) {
  var now = asOf == null ? new DateTime.now() : asOf;
  return new DateTime(now.year, now.month, now.day);
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

/**
 * Add a number of months to a given datetime.
 * [from] will be considered too be a beginningOfMonth DateTime.
 * [step] can be positive or negative
 */
DateTime addMonths(DateTime from, {int step: 1}) {
  int mth = 12*from.year + from.month + step;
  return new DateTime(mth~/12, mth%12);
}

/**
 * Cover a [start,end] DateTime interval with hour durations.
 * Rule is to respect the day boundaries, so hour 0 will need to
 * show up when you cross the day boundary.
 * [hours] is the number of hours to skip, e.g. hours=8
 */
List<DateTime> coverHours(DateTime start, DateTime end, int hours) {
  List<DateTime> res = [new DateTime(start.year, start.month, start.day, (start.hour~/hours)*hours)];
  while (res.last.isBefore(end)) {
    DateTime aux = res.last.add(new Duration(hours: hours));
    if (currentDay(aux) == currentDay(res.last))
      res.add(aux);
    else
      res.add(nextDay(res.last));
  }

  return res;
}


/**
 * Cover a [start,end] DateTime interval with day durations.
 * Rule is to respect the month boundaries, so 1st of the month will need to
 * show up when you cross the month boundaries.
 * [days] is the number of days to skip, e.g. days=7 for a week
 */
List<DateTime> coverDays(DateTime start, DateTime end, int days, {bool show1st: false}) {
  List<DateTime> res = [new DateTime(start.year, start.month, (start.day~/days)*days+1)];
  while (res.last.isBefore(end)) {
    DateTime aux = res.last.add(new Duration(days: days));
    if (show1st) {
      if (currentMonth(aux) == currentMonth(res.last))
        res.add(aux);
      else
        res.add(nextMonth(res.last));
    } else {
      res.add(aux);
    }
  }

  return res;
}

/**
 * Cover a [start,end] DateTime interval with full months.
 * [months] is the number of days to skip, e.g. months=3 skip by quarter
 * [showJan] if you want to respect the year boundaries, so Jan of the year will
 * show up when you cross the year boundaries.  May not make much sense as people
 * can follow sequence of numbers up to 12.
 */
List<DateTime> coverMonths(DateTime start, DateTime end, int months, {bool showJan: false}) {
  List<DateTime> res = [new DateTime(start.year, start.month)];
  while (res.last.isBefore(end)) {
    DateTime aux = addMonths(res.last, step: months);
    if (showJan) {
      if (aux.year == res.last.year)
        res.add(aux);
      else
        res.add(new DateTime(res.last.year+1));
    } else {
      res.add(aux);
    }
  }

  return res;
}