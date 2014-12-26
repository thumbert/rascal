library test_layout;

import 'package:unittest/unittest.dart';
import 'package:dartice/plots/layout.dart';

test_layout() {
  group("Test lattice layout", () {
    test("to indices", (){
      Layout layout = new Layout(3,2);
      List idx = [0,1,2,3,4,5].map((panelNumber) => [layout.rowIndex(panelNumber), 
                                                  layout.colIndex(panelNumber)]).toList();
      expect(idx, [[0,0], [0,1], [1,0], [1,1], [2,0], [2,1]]);      
    });
    
    
    
  });
  
}

main() => test_layout();