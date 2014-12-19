library test_period;

import 'package:unittest/unittest.dart';
import 'package:timeseries/time/period.dart';
import 'package:timeseries/time/year.dart';
import 'package:timeseries/time/month.dart';

test_period() {
  
  group("Test Period: ", (){
    test("Equality of periods", () {
      Period p1 = Period.MONTH;
      Period p2 = Period.MONTH;
      expect(p1, p2);
      expect(p1 == p2, true);
    });  
  });
  
  group("Test Period: ", (){
    test("Next period", () {
      Period month = Period.MONTH;
      expect(month.next(new DateTime(2014,3)), new DateTime(2014,4));
      expect(Period.DAY.next(new DateTime(2014,3,10)), new DateTime(2014,3,11));
      expect(month.next(new DateTime.utc(2014,3)), new DateTime.utc(2014,4));
    });  
  });
  
  group("Test Period: ", (){
    test("Monthly sequences", () {
      Period month = Period.MONTH;
      var months = month.seq(new DateTime(2014), new DateTime(2015));
      expect(months.length, 12);
    });  
    test("Daily sequences", () {
      Period day = Period.DAY;
      var days = day.seq(new DateTime(2014,1), new DateTime(2014,2));
      expect(days.length, 31);
    });  
    test("Daily sequences (more)", () {
      Period day = Period.DAY;
      var days = day.seq(new DateTime(2014), new DateTime(2015));
      expect(days.length, 365);
    });  
    test("Daily sequences (utc)", () {
      Period day = Period.DAY;
      var days = day.seq(new DateTime.utc(2014,3), new DateTime.utc(2014,4));
      expect(days.length, 31);
    });  
    
    
  });
  
  
  
}

main() => test_period();