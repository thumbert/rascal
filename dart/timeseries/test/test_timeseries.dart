library test_timeseries;

import 'package:unittest/unittest.dart';
import 'package:timeseries/timeseries.dart';
import 'package:timeseries/seq.dart';
import 'package:timeseries/time/month.dart';
import 'package:timeseries/time/year.dart';
import 'package:timeseries/time/period.dart';
import 'package:timeseries/time/interval.dart';

main() {
  
  group('TimeSeries tests: ', () {
    
    test('create hourly timeseries using fill', () {
      var index = new Year(2014).split(Period.HOUR, (x) => x.start);
      var ts = new TimeSeries.fill(index, 1, period: Period.HOUR);
      expect(ts.length, 8760);
    }); 
  
    test('check indexing', () {
      var index = new Year(2014).split(Period.HOUR, (x) => x.start);
      var ts = new TimeSeries.fill(index, 1, period: Period.HOUR);
      Obs a1 = ts[0];
      expect(a1.index, index[0]);
      expect(a1.value, 1);
     }); 
    
    test('calculate the number of hours in some months', () {
      var index = new Year(2014).split(Period.HOUR, (x) => x.start);
      var ts = new TimeSeries.fill(index, 1, period: Period.HOUR);
      
      TimeSeries hrs = ts.toMonthly((x) => x.length);
      expect(hrs.values, [744, 672, 743, 720, 744, 720, 744, 744, 720, 744, 721, 744]);      
    });
 
    test('add observations', () {
      var months = new Interval.fromStartEnd(new DateTime(2014,1,1), new DateTime(2014,4,1))
        .split(Period.MONTH, (x) => x.start);
      var ts = new TimeSeries.generate(3, (i) => new Obs(months[i], i));
      ts.add(new Obs(new DateTime(2014,4,1), 4));
      expect(ts.length, 4);
    });
    
    test('adding to the middle of the tseries throws', () {
      var months = new Year(2014).split(Period.MONTH, (x) => x.start);
      var ts = new TimeSeries.generate(12, (i) => new Obs(months[i], i));
      expect(() => ts.add(new Obs(new DateTime(2014,4,1), 4)), throwsStateError);
      
    });
    
    test('filter observations', () {
      var months = new Interval.fromStartEnd(new DateTime(2014,1,1), new DateTime(2014,7,1))
        .split(Period.MONTH, (x) => x.start);
      var ts = new TimeSeries.generate(6, (i) => new Obs(months[i], i));
      ts.add(new Obs(new DateTime(2014,7,1), 7));
      ts.retainWhere((obs) => obs.value > 2);
      expect(ts.values.toList()[0], 3);
      expect(ts.length, 4);
      var ts2 = new TimeSeries.generate(6, (i) => new Obs(months[i], i));
      ts2.removeWhere((Obs e) => e.value > 2);
      expect(ts2.length, 3);
    });
    
    
  });
  
  group('Interval TimeSeries tests: ', () {
    
    test('create monthly interval timeseries using fill', () {
      var index = Period.MONTH.seqFrom(new DateTime(2014,1), 12);
      var ts = new TimeSeries.fill(index, 1, period: Period.MONTH);
      expect(ts.length, 12);
      expect(ts.period, Period.MONTH);
    }); 
    
    test('adding an existing month throws StateError', () {
      var index = Period.MONTH.seqFrom(new DateTime(2014,1), 12);
      var ts = new TimeSeries.fill(index, 1);
      expect(() => ts.add(new Obs(new DateTime(2014,5), 5)), throwsStateError);
    }); 
        
    solo_test('adding a middle of the month day to an existing monthly timeseries throws', () {
      var index = Period.MONTH.seqFrom(new DateTime(2014,1), 12);
      var ts = new TimeSeries.fill(index, 1, period: Period.MONTH);
      expect(() => ts.add(new Obs(new DateTime(2015, 1, 5), 12)), throws);
    }); 
    
  });
  
  
  group('Aggregations/Expansion: ', () {
    
    test('aggregate an hourly timeseries to monthly', () {
      List<DateTime> hrs = new Year(2014).split(Period.HOUR, (x) => x.start);
      var ts = new TimeSeries.fill(hrs, 1);
      
      // FIXME if the timeseries is an interval timeseries, you don't have 
      // ts.first.index.year as toMonthly wants!  How to fix?
      //print(ts.first.index.start.year);
   
      TimeSeries res = ts.toMonthly((List obs) => obs.length);
//      expect(res.join(""),
//        "{Jan14, 744}{Feb14, 672}{Mar14, 743}{Apr14, 720}{May14, 744}{Jun14, 720}{Jul14, 744}{Aug14, 744}{Sep14, 720}{Oct14, 744}{Nov14, 721}{Dec14, 744}");
    });
    
    test('expand a monthly timeseries to hourly data', () {
      var ts = new TimeSeries(period: Period.MONTH);
      ts.addAll([new Obs(new DateTime(2014,3), 1.0),
                 new Obs(new DateTime(2014,2), 2.0)]);
      //var hrs = new Month(2014, 1).expand(new Duration(hours: 1));
      
      // FIXME make sure that when you addAll you add time-ordered values ony!    
      //var res = ts.expand((Obs e) => new TimeSeries.fill(Period.HOUR.se.index, e.value));
      //res.forEach((e) => print(e));      
    });
    
  });
 

  
}
