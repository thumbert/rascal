library test_holiday;

import 'package:unittest/unittest.dart';
import 'package:timeseries/time/holiday.dart';
import 'package:intl/intl.dart';

test_holiday() {
  var fmt = new DateFormat("yyyy-MM-dd");

  group("Test Holidays: ", (){
    
    test("Thanksgiving", () {
      expect("2012-11-22", fmt.format(Holiday.thanksgiving(2012).day) );
      expect("2013-11-28", fmt.format(Holiday.thanksgiving(2013).day) );
      expect("2014-11-27", fmt.format(Holiday.thanksgiving(2014).day) );
      expect(Holiday.thanksgiving(2014).name, "Thanksgiving");
    });
    
    test("MLK", (){
      expect("2012-01-16", fmt.format(Holiday.martinLutherKing(2012).day) );
      expect("2013-01-21", fmt.format(Holiday.martinLutherKing(2013).day) );
      expect("2014-01-20", fmt.format(Holiday.martinLutherKing(2014).day) );
      expect(Holiday.martinLutherKing(2014).name, "Martin Luther King");
    });
      
    test("Memorial Day", (){
      expect("2012-05-28", fmt.format(Holiday.memorialDay(2012).day) );
      expect("2013-05-27", fmt.format(Holiday.memorialDay(2013).day) );
      expect("2014-05-26", fmt.format(Holiday.memorialDay(2014).day) );
      expect(Holiday.memorialDay(2014).name, "Memorial Day");
    });

    test("Labor Day", (){
      expect("2012-09-03", fmt.format(Holiday.laborDay(2012).day) );
      expect("2013-09-02", fmt.format(Holiday.laborDay(2013).day) );
      expect("2014-09-01", fmt.format(Holiday.laborDay(2014).day) );
      expect(Holiday.laborDay(2014).name, "Labor Day");
    });
   
    
    
    
  });
  
  
  
  
}

main() => test_holiday();