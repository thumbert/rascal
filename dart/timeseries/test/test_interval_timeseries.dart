library test_interval_timeseries;

import 'package:unittest/unittest.dart';
import 'package:timeseries/timeseries.dart';
import 'package:timeseries/time/month.dart';

main() {
  
  group('IntervalTimeSeries tests: ', () {
  
    test('create monthly timeseries using fill', () {
      var index = new Month(2014,1).seqLength(12).toList(); 
      var ts = new TimeSeries.fill(index, 1);
      expect(ts.length, 12);
    }); 
    
  });
}