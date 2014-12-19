library test;

import 'test_seq.dart';
import 'test_timeseries.dart';
import 'test_date.dart';
import 'test_holiday.dart';
import 'test_interval.dart';
import 'test_month.dart';
import 'test_period.dart';


main () {
  
  test_date();
  //test_dst();
  test_holiday();
  test_interval();
  test_month();
  test_period();
  //test_range();
  //test_timeseries();
  
}