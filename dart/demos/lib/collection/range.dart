

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




testRange() {
  List<int> x = seqInt(0, 10, 2);
  x.forEach((e)=>print(e));
  
  List<DateTime> y = seqMonth(new DateTime(2013,1), new DateTime(2015,3), 2);
  y.forEach((e)=>print(e));
  
  
}

// main() {testRange();}

