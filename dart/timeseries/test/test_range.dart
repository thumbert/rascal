library test_range;

import 'package:unittest/unittest.dart';
import 'package:timeseries/range/range.dart';


test_range() {
    
  group("Test range generation: ", () {
    
    test("integer range 1 to 5 step 1", () {
      expect(Range.Int(1, 5).join(","), "1,2,3,4,5");
    });
    test("integer range 1 to 5 step 2", () {
      expect(Range.Int(1, 5, step: 2).join(","), "1,3,5");
    });
   
  });
  
}

main() => test_range();