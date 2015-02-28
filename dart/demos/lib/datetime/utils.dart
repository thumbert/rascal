library utils;

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
List<DateTime> seqDays(DateTime start, DateTime end) {
  var D1 = new Duration(days: 1);

  List<DateTime> res = [];
  var current = start;
  while (end.isAfter(current)) {
    res.add(current);
    current = current.add( D1 );
  }

  return res;
}

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


main(){
  print("Current month is " + currentMonth().toString());  
  print("Current month from 2014-01-14 is " + currentMonth(asOf: new DateTime(2014,1,14)).toString());

  print("\n");
  print("Next month is " + nextMonth().toString());
  print("Next month from 2014-01-14 is " + nextMonth(asOf: new DateTime(2014,1,14)).toString());
  
  print("\n");
  print("Previous month is " + previousMonth().toString());
  print("Previous month from 2014-01-14 is " + previousMonth(asOf: new DateTime(2014,1,14)).toString());

  
}
