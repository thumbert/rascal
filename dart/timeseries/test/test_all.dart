library test;

import 'package:timezone/standalone.dart';

import 'test_seq.dart';
import 'test_timeseries.dart';
import 'test_bucket.dart' as test_bucket;
import 'test_calendar.dart' as test_calendar;
import 'test_dst.dart' as test_dst;
import 'test_date.dart' as test_date;
import 'test_holiday.dart' as test_holiday;
import 'test_interval.dart' as test_interval;
import 'test_month.dart' as test_month;
import 'test_period.dart' as test_period;


main () {
  //initializeTimeZone().then((_) => test_bucket.test_bucket());
//  test_bucket.main();
  test_calendar.main();
  test_date.main();
  test_dst.main();
  test_holiday.main();
  test_interval.main();
  test_month.main();
  test_period.main();
  //test_range();
  //test_timeseries();
  
}