library test_bucket;

import 'package:unittest/unittest.dart';
import 'package:timeseries/elec/bucket.dart';

List<DateTime> seqHours(DateTime start, DateTime end) {
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
  List<DateTime> hrs = seqHours(new DateTime(2015,1,1,1), new DateTime(2016));
  Bucket b7x24 = new Bucket7x24();
  group("Test the 7x24 bucket", () {
    test("All hours should be in bucket 7x24", () {
      expect(hrs.every((hour) => b7x24.containsHourEnding(hour)), true);
    });
  });



}

main() => test_bucket();