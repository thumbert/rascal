library test_dst;

import 'package:unittest/unittest.dart';

/**
 * Test daylight savings time issues in Dart. 
 * You should always keep your timestamps in UTC.  For display only, do a .toLocal()!
 * 
 */
test_dst() {
  group("daylight savings tests", () {
    test("spring forward", () {
      // on 2014-03-09 skip forward one hour (hour beginning 2:00 does not exist) in the US/Eastern time zone. 
      var start = new DateTime(2014, 3, 9);
      List hours = new List.generate(6, (h) => start.add(new Duration(hours: h)));
      expect(hours.join(", "), "2014-03-09 00:00:00.000, 2014-03-09 01:00:00.000, 2014-03-09 03:00:00.000, 2014-03-09 04:00:00.000, 2014-03-09 05:00:00.000, 2014-03-09 06:00:00.000");
      
      // if you add 1 day to 2014-03-09 you get 2014-04-10 01:00:00!  Use UTC!
      expect(start.add(new Duration(days: 1)).toString(), "2014-03-10 01:00:00.000");
      
      // you don't miss it in UTC
      var startUtc = new DateTime.utc(2014, 3, 9);
      List hoursUtc = new List.generate(6, (h) => startUtc.add(new Duration(hours: h)));
      expect(hoursUtc.join(", "), "2014-03-09 00:00:00.000Z, 2014-03-09 01:00:00.000Z, 2014-03-09 02:00:00.000Z, 2014-03-09 03:00:00.000Z, 2014-03-09 04:00:00.000Z, 2014-03-09 05:00:00.000Z");     
    });
    
    test("fall back", () {
      var start = new DateTime(2014, 11, 2);
    });
  });
}

//main() => test_dst();
