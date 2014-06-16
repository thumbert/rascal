library test_cake_pattern;
import 'package:demos/other/cake_pattern.dart';

MapArchive makeTestArchive1() {
  var ar = new MapArchive();
  ar.insert('A', 1);
  ar.insert('B', 2);
  ar.insert('C', 3);
  
  return ar;
}

MapArchive makeTestArchive2() {
  var ar = new MapArchive();
  ar.insert('A', 4);
  ar.insert('B', 5);
  ar.insert('C', 6);
  
  return ar;
}



main() {

  
  pkgArchive = makeTestArchive1();
 
  var calc = new Calculator2();
  print(calc.addThemUp(['A', 'B', 'C']));
  
  pkgArchive = makeTestArchive2();
  print(calc.addThemUp(['A', 'B', 'C']));
   
  
}