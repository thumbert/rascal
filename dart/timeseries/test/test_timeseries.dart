library test_timeseries;

import 'package:unittest/unittest.dart';
import 'package:timeseries/timeseries.dart';
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
    
    test('adding an existing index throws StateError', () {
      var index = Period.MONTH.seqFrom(new DateTime(2014,1), 12);
      var ts = new TimeSeries.fill(index, 1);
      expect(() => ts.add(new Obs(new DateTime(2014,5), 5)), throwsStateError);
    }); 
    
    test('adding existing indexes with addAll throws StateError', () {
      var index = Period.MONTH.seqFrom(new DateTime(2014,1), 12);
      var ts = new TimeSeries.fill(index, 1);
      expect(() => ts.addAll(ts.data.sublist(3,4)), throwsStateError);
    }); 
    
    
    test('adding a middle of the month day to an existing monthly timeseries throws', () {
      var index = Period.MONTH.seqFrom(new DateTime(2014,1), 12);
      var ts = new TimeSeries.fill(index, 1, period: Period.MONTH);
      expect(() => ts.add(new Obs(new DateTime(2015, 1, 5), 12)), throws);
    }); 
    
  });
  
  
  group('Aggregations/Expansion: ', () {
    test('aggregate an hourly timeseries to monthly', () {
      List<DateTime> hrs = new Year(2014).split(Period.HOUR, (x) => x.start);
      var ts = new TimeSeries.fill(hrs, 1, period: Period.MONTH);
         
      TimeSeries res = ts.toMonthly((List obs) => obs.length);
      expect(res.join(""),
        "{2014-01-01 00:00:00.000, 744}{2014-02-01 00:00:00.000, 672}{2014-03-01 00:00:00.000, 743}{2014-04-01 00:00:00.000, 720}{2014-05-01 00:00:00.000, 744}{2014-06-01 00:00:00.000, 720}{2014-07-01 00:00:00.000, 744}{2014-08-01 00:00:00.000, 744}{2014-09-01 00:00:00.000, 720}{2014-10-01 00:00:00.000, 744}{2014-11-01 00:00:00.000, 721}{2014-12-01 00:00:00.000, 744}");
    });
    
    solo_test('expand a monthly timeseries to daily data', () {
      var ts = new TimeSeries(period: Period.MONTH, isUtc: true);
      ts.add(new Obs(new DateTime.utc(2014,3), 1.0));
      
      var tsDaily = ts.expand((obs) {
        var days = Period.DAY.seq(obs.index, Period.MONTH.next(obs.index));
        return new List.generate(days.length, (i) => new Obs(days[i], obs.value));
      });
      print(tsDaily);
      //var hrs = new Month(2014, 1).expand(new Duration(hours: 1));
      
      // FIXME make sure that when you addAll you add time-ordered values ony!    
      //var res = ts.expand((Obs e) => new TimeSeries.fill(Period.HOUR.se.index, e.value));
      //res.forEach((e) => print(e));      
    });
    
  });
 

  
}
