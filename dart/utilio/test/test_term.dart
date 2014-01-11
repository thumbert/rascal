library test_term;

import 'package:unittest/unittest.dart';
import 'package:utilio/term.dart';

main() {
  group("Parse term:", () {
    test("'2004'", () {
      Term exp = new TermParser().start.parse('2004');
      expect(exp, new Term(new DateTime(2004), new DateTime(2005)));
    });
          
    test("'Jan12'", () {
      var exp = new TermParser().start.parse('Jan12');
      expect(exp, new Term(new DateTime(2012,1), new DateTime(2012,2)));
    });
    
    
//    test("A month TermParse('AUG12')", () {
//      var exp = new TermParser().start.parse('AUG12');
//      expect(exp, new Term(new DateTime(2012,8), new DateTime(2012,9)));
//    });
         
  });
  
}