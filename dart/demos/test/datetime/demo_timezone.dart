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
  print(new TZDateTime(la, 2014));                      // 2014-01-01 00:00:00.000-0800
  
  
}

main() {

  initializeTimeZone().whenComplete(() => realMain());


}
