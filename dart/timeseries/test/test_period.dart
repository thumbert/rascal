library test_period;

import 'package:unittest/unittest.dart';
import 'package:timeseries/time/period.dart';

test_period() {
  
  group("Test Period: ", (){
    test("Equality of periods", () {
      Period p1 = Period.MONTH;
      Period p2 = Period.MONTH;
      expect(p1, p2);
      expect(p1 == p2, true);
    });
    
  });
  
  
  
  
}

main() => test_period();