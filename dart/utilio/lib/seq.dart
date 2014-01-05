library seq;

/*
 * Functions to generate regular sequences. DateTimes, Days, Months, ints.
 */

    
List<DateTime> seqDateTime(DateTime start, DateTime end, Duration step) {
  List<DateTime> data = [];
    
  while (start.compareTo(end) <= 0) {
    data.add( start );
    start = start.add( step );
  }

  return data;
}



List<DateTime> seqDay(DateTime start, DateTime end, [int step=1]) {
  List<DateTime> res = [];
    
  DateTime day = new DateTime(start.year, start.month, start.day);
  DateTime dayEnd = new DateTime(end.year, end.month, end.day);
  Duration inc = new Duration(days:step);
  
  while (day.compareTo(dayEnd) <= 0) {
    res.add( day);
    day = day.add(inc);
  }
  
  return res;    
}



List<int> seqInt(int start, int end, int step) {
  List<int> res = [];
  for(int i=start; i<=end; i+=step) {
    res.add(i);
  }
  
  return res;    
}



List<DateTime> seqMonth(DateTime start, DateTime end, [int step=1]) {
  List<DateTime> res = [];
    
  int mthStart = 12*start.year + start.month;
  int mthEnd = 12*end.year + end.month;
  
  while (mthStart <= mthEnd) {
    res.add( new DateTime(mthStart~/12, mthStart%12) );
    mthStart += step;
  }
  
  return res;    
}


