library format_datetime;
import 'package:intl/intl.dart';

addMonths(DateTime x, int years, int months) {
  return new DateTime(x.year + years, x.month + months, x.day);
}

main() {
  
  var dt = new DateTime(2014,1,1,9);
  print(dt.toString());  // 2014-01-01 09:00:00.000
  
  var dt2 = DateTime.parse("2014-01-01 09:00:00");
  print(dt2.toString());   // 2014-01-01 09:00:00.000 
  print(dt2.isUtc);        // false
  print(dt2.timeZoneName); // "EST"
  
  var fmt = new DateFormat("dMMMyy");
  print(fmt.format(dt2));  //1Jan14
  
  
  var dt3 = DateTime.parse("2014-01-01");
  print(dt3); // 2014-01-01 00:00:00.000
  
  var dt4 = addMonths(dt3, 1, 13);
  
  print("Adding 1 year and 13 months to 2014-01-01 is $dt4");
  
}