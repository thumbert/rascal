library test_bucket;

import 'package:timezone/standalone.dart';
import 'package:unittest/unittest.dart';
import 'package:timeseries/elec/bucket.dart';
import 'package:timeseries/elec/iso.dart';
import 'package:timeseries/time/month.dart';


List<DateTime> seqHours(TZDateTime start, TZDateTime end) {
  Duration H1 = new Duration(hours: 1);
  List<DateTime> res = [];
  var dt = start;
  while (dt.isBefore(end) || dt.isAtSameMomentAs(end)) {
    res.add(dt);
    dt = dt.add(H1);
  }

  return res;
}

test_bucket() {

  group("Test the 5x16 bucket NEPOOL", () {
    Bucket b5x16 = Nepool.bucket5x16;
    test("peak hours by year", () {
      List res = [];
      for (int year in [2012, 2013, 2014, 2015, 2016]) {
        List<DateTime> hrs = seqHours(new TZDateTime(Nepool.location, year,1,1), new TZDateTime(Nepool.location, year,12,31,23));
        res.add(hrs.where((hour) => b5x16.containsHourBeginning(hour)).length);
      }
      expect(res, [4096, 4096]);
    });
    solo_test("peak hours by month 2015", () {
      List res = [];
      for (int mon in new List.generate(12, (i) => i)) {
        Month next = new Month(2015, mon).next();
        List<DateTime> hrs = seqHours(new TZDateTime(Nepool.location,2015,mon,1),
          new TZDateTime(Nepool.location, next.year, next.month).subtract(new Duration(hours: 1)));
        res.add(hrs.where((hour) => b5x16.containsHourBeginning(hour)).length);
      }
      expect(res, [352, 336, 320, 352, 352, 320, 352, 368, 336, 336, 352, 321]);
    });



  });



//  List<DateTime> hrs = seqHours(new DateTime(2015,1,1,1), new DateTime(2016));
//  Bucket b7x24 = new Bucket7x24();
//  group("Test the 7x24 bucket", () {
//    test("All hours should be in bucket 7x24", () {
//      expect(hrs.every((hour) => b7x24.containsHourEnding(hour)), true);
//    });
//  });



}

main() {
  initializeTimeZone().then((_) => test_bucket());
}
