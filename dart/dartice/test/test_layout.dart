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
    
   group("exterior side calculation", (){
     var layout = new Layout(3,2);
     int nPanels = 5;
     expect(layout.getExteriorSides(0, nPanels), new Set.from([1,2]));
     expect(layout.getExteriorSides(1, nPanels), new Set.from([1,4]));
     expect(layout.getExteriorSides(2, nPanels), new Set.from([2]));
     expect(layout.getExteriorSides(3, nPanels), new Set.from([3,4]));
     expect(layout.getExteriorSides(4, nPanels), new Set.from([2,3,4]));
   });
  
   group("exterior side calculation again", (){
     var layout = new Layout(2,4);
     int nPanels = 5;
     expect(layout.getExteriorSides(0, nPanels), new Set.from([1,2]));
     expect(layout.getExteriorSides(1, nPanels), new Set.from([1,3]));
     expect(layout.getExteriorSides(3, nPanels), new Set.from([1,3,4]));
     expect(layout.getExteriorSides(4, nPanels), new Set.from([2,3,4]));
   });
   
   group("test where to put the ticks", (){
     var layout = new Layout(3,2);
     int nPanels = 5;
     expect(layout.axesWithTicks(0, new Set.from([1,2])), new Set.from([1,2]));
     expect(layout.axesWithTicks(1, new Set.from([1,4])), new Set<int>());
     expect(layout.axesWithTicks(2, new Set.from([2])), new Set<int>());
     expect(layout.axesWithTicks(3, new Set.from([3,4])), new Set.from([3,4]));
     expect(layout.axesWithTicks(4, new Set.from([2,3,4])), new Set.from([2]));
   });
   
   
  });
  
}

main() => test_layout();