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
 * Best to have the inputs be UTC dates.
 */
List<DateTime> seqDays(DateTime start, DateTime end) {
  var D1 = new Duration(days: 1);

  List<DateTime> res = [];
  var current = start;
  while (end.isAfter(current) || current == end) {
    res.add(current);
    current = current.add( D1 );
  }
  
  return res;
}

String unquote(String x) => x.substring(1,x.length-1);

