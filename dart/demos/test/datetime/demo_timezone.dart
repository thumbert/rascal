library demo_timezone;

import 'package:timezone/standalone.dart';


realMain() {
  final ny = getLocation('America/New_York');
  final la = getLocation('America/Los_Angeles');
  final boy_ny = new TZDateTime(ny, 2014);
  print(boy_ny.millisecondsSinceEpoch);
  print(new DateTime.utc(2014).millisecondsSinceEpoch);
  
  print(new TZDateTime.from(new DateTime(2014), ny));   // 2014-01-01 00:00:00.000-0500
  print(new TZDateTime(ny, 2014));                      // 2014-01-01 00:00:00.000-0500
  var la14 = new TZDateTime(la, 2014);
  print(la14);                                          // 2014-01-01 00:00:00.000-0800
  
  List res = [new DateTime(2014)];
  for (int i=1; i<=10*8760; i++) {
    res.add(la14.add(new Duration(hours: i)));
  }
  
  
  print("Done");
}


main() {
  initializeTimeZoneSync();
  realMain();


}

// for 1 tzdatetime
// 9946 adrian    20   0  479420  31552   7412 S   3.7  0.2   0:01.06 dart        

// for 8760 tzdatetimes
//10401 adrian    20   0  479676  31256   7416 S   3.6  0.2   0:01.18 dart   
// for 10*8760 tzdatetimes
//10465 adrian    20   0  448444  47252   7416 S   4.0  0.3   0:01.20 dart

// for 10*8760 datetimes  by goly!  the tzdatetimes class does not use more 
// memory than datetime. 
//10557 adrian    20   0  515008  48764   7420 S   3.7  0.3   0:01.44 dart

