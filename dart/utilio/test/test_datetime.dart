library test_datetime;

import 'package:unittest/unittest.dart';
import 'package:utilio/datetime.dart';
import 'package:utilio/seq.dart';

main(){
  
  group("Testing next/current/previous month:", () {
    test("Current month from 2014-01-14", () {
      expect(new DateTime(2014, 1, 1), currentMonth(asOf: new DateTime(2014,1,14)));
    });
    test("Next month from 2014-01-14", () {
      expect(new DateTime(2014, 2, 1), nextMonth(asOf: new DateTime(2014,1,14)));
    });
    test("Previous month from 2014-01-14", () {
      expect(new DateTime(2013, 12, 1), previousMonth(asOf: new DateTime(2014,1,14)));
    });
    test("Current year from 2014-01-14", () {
      expect(new DateTime(2014), currentYear(asOf: new DateTime(2014,1,14)));
    });
    test("Add 3 years to 2014-01-14", () {
      expect(new DateTime(2017), addYears(new DateTime(2014,1,14), 3));
    });
    test("Go back 3 months from 2014-01-14", () {
      expect(new DateTime(2013,10), addMonths(new DateTime(2014,1,14), -3));
    });    
    
    
  });  
  
  
  
  group('sequence tests:', () {
    test('an integer range', () {
      expect(seqInt(0, 10, 2), [0, 2, 4, 6, 8, 10]);
    }); 
    test('a day range', () {
      expect(seqDay(new DateTime(2013,1), new DateTime(2013,1,10), 4), 
        [new DateTime(2013,1,1), new DateTime(2013,1,5), new DateTime(2013,1,9)]);
    }); 
    test('a monthly range', () {
      expect(seqMonth(new DateTime(2013,1), new DateTime(2014,3), 4), 
        [new DateTime(2013,1), new DateTime(2013,5), new DateTime(2013,9), new DateTime(2014,1)]);
    });
  });
  
 
  
//  group("Testing term:", () {
//  
//    test("A full year TermParse('2004')", () {
//      Term exp = new TermParser().start.parse('2004');
//      expect(exp, new Term(new DateTime(2004), new DateTime(2005)));
//    });
//    
//      
//    test("A month TermParse('Jan12')", () {
//      var exp = new TermParser().start.parse('Jan12');
//      print("parsed " + exp.toString());
//      expect(exp, new Term(new DateTime(2012,1), new DateTime(2012,2)));
//    });
//    
//    test("A month TermParse('AUG12')", () {
//      var exp = new TermParser().start.parse('AUG12');
//      expect(exp, new Term(new DateTime(2012,8), new DateTime(2012,9)));
//    });
//    
//  });
}  