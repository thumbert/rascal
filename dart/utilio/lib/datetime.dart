library datetime;

/*
 * Useful functions when working with DateTimes. 
 */

DateTime currentMonth({DateTime asOf}) {
  var now = asOf == null ? new DateTime.now() : asOf; 
  return new DateTime(now.year, now.month);
}

DateTime nextMonth({DateTime asOf}) {
  var now = asOf == null ? new DateTime.now() : asOf; 
  int mth = 12*now.year + now.month + 1;
  return new DateTime(mth~/12, mth%12);
}

DateTime previousMonth({DateTime asOf}) {
  var now = asOf == null ? new DateTime.now() : asOf; 
  int mth = 12*now.year + now.month - 1;
  return new DateTime(mth~/12, mth%12);
}

DateTime currentYear({DateTime asOf}) {
  var now = asOf == null ? new DateTime.now() : asOf; 
  return new DateTime(now.year);
}

DateTime nextYear({DateTime asOf}) {
  var now = asOf == null ? new DateTime.now() : asOf; 
  return new DateTime(now.year+1);
}



/*
 * Add a number of months to a DateTime.
 * A negative step will work too to give months before current month.  
 * Calculation is made from the beginning of the month. 
 * Return value is a beginning of the month DateTime.  
 */
DateTime addMonths(DateTime from, [int step=1]) {
  DateTime thisMonth = currentMonth(asOf: from);
  int mth = 12*thisMonth.year + thisMonth.month + step;
  return new DateTime(mth~/12, mth%12);
}

DateTime addYears(DateTime from, [int step=1]) {
  DateTime thisYear = currentYear(asOf: from);
  return new DateTime(thisYear.year + step);
}

