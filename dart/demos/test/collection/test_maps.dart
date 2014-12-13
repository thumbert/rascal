library test_maps;
import 'dart:collection';

/**
 * an unmodifiable map view
 */
t1() {
  Map m = {"A": 1, "B": 2};
  var mv = new UnmodifiableMapView(m);
  
  print(m["A"] == 1);  // true
  m["C"] = 3;          // add another entry
  print(mv);           // {A: 1, B: 2, C: 3} it gets reflected in the view 
  // mv["D"] = 4;      // throws
}

main() {
  t1();
  
}
