library test_interval;

import 'package:unittest/unittest.dart';
import 'package:timeseries/time/interval.dart';
import 'package:intl/intl.dart';
import 'package:timeseries/time/date.dart';
import 'package:timeseries/time/month.dart';
import 'package:timeseries/time/year.dart';
import 'package:timeseries/time/period.dart';

test_interval () {
  
  group("Test Interval: ", () {
    
    test("Basic interval methods", () {
      Interval i1 = new Interval.fromStartEnd(new DateTime(2014,1), new DateTime(2014,2)); 
      Interval i2 = new Interval.fromStartEnd(new DateTime(2014,2), new DateTime(2014,3));
      expect(i1.isBefore(i2), true);
      expect(i2.isAfter(i1),  true);
      expect(i2.isBefore(i1), false);
      expect(i1.isAfter(i2),  false);
    });
    
    test("General interval of 3 hours", () {
      Interval i = new Interval.fromStartEnd(new DateTime(2014,1), new DateTime(2014,1,1,4));
      expect(i.toString(), "2014-01-01 00:00:00.000/2014-01-01 04:00:00.000");
    });
    
    test("Split a year into months", () {
      Interval i = new Year(2014).toInterval();
      var months = i.split(Period.MONTH, (x) => x);
      expect(months.length, 12);
    });
    
    test("Split interval Jan14-Apr14 into months", () {
      Interval i = new Interval.fromStartEnd(new DateTime(2014,1), new DateTime(2014,4));
      var months = i.split(Period.MONTH, (x) => x);
      expect(months.length, 3);
    });
    
    
   
     
    test("Month", () {
      Month m  = new Month(2014,1);
      Month m2 = new Month(2014,1);
      expect(m, m2);
      expect(m.toInterval().end, new DateTime(2014,2));
      expect(m.toString(), "Jan14");
      expect(m.next().toString(), "Feb14");
      expect(m.previous().toString(), "Dec13");
      expect(m.add(6), new Month(2014,7));
      expect(m.seqTo(new Month(2014,5), step: 2).map((e)=>e.toString()).join(','), "Jan14,Mar14,May14");
      expect(m.seqLength(3, step: 2).map((e)=>e.toString()).join(','), "Jan14,Mar14,May14");
            
      List<Month> x = [new Month(2014,3),
                       new Month(2014,1)];
      x.sort((a,b)=>a.compareTo(b));
      expect(x.map((e)=>e.toString()).join(','), "Jan14,Mar14");
      expect(m.year,2014);
      expect(m.month,1);
      
      Month m1 = new Month(2015,11);
      Month m3 = m1.add(1);                
      expect(m3.toString(), 'Dec15');
      expect(m3.year, 2015);
      expect(m3.toString(), 'Dec15');
      expect("Dec15: (${m3.year}, ${m3.month})", "Dec15: (2015, 12)");
      expect(m3.year, 2015);
      Month m4 = m3.add(1).subtract(1);
      expect("Dec15: (${m4.year}, ${m4.month})", "Dec15: (2015, 12)"); 
      
      List<Month> mths = m.seqLength(12);
      expect(mths.last.year, 2014);
    });
    
    
    test("Year", () {
      Year y1 = new Year(2013);
      Year y2 = new Year(2014);
      Year y3 = new Year.fromDateTime(new DateTime(2015));
      expect(y1.toString(), "2013");
      var months2 = y1.splitMonths();
      var months = y1
          .toInterval()
          .split(Period.MONTH, (x) => x)
          .map((x) => new Month.fromDateTime(x.start));
      expect(months.map((m)=> m.toString()).join(','), 
        "Jan13,Feb13,Mar13,Apr13,May13,Jun13,Jul13,Aug13,Sep13,Oct13,Nov13,Dec13");
      expect(y1.next(), y2);
      expect(y1.previous(), new Year(2012));
    });    
    
  });
  
}

main() =>  test_interval();
