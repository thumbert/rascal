library test_median;

import 'package:demos/math/stats/median.dart';

//import 'package:unittest/unittest.dart';
//import 'package:demos/math/stats/median.dart';

main() {
  print("Hi");

  List x = 'KRATELEPUIMQCXOS'.split("");
  //x.sort();
  print(x);
  
  
  Quantile q = new Quantile(x);
  q.sort();
  print(q.x);
  
}

//other() {
//  print((22) >> 1);
//  
//  
//  //print(q.partition(x, 0, x.length-1));
//  //print(q.x);
//  
//  //print(q.sort());
//  
//  
//  
////  test("median", () {
////    expect(quickSelect([5,4,2,1,3], 3), 3);
////  });
//}