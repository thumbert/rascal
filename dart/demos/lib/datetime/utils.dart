library utils;

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
