library test_median;

import 'package:unittest/unittest.dart';
import 'package:demos/math/stats/median.dart';


main() {
  print("Hi");

  List x = 'KRATELEPUIMQCXOS'.split("");
  //x.sort();
  print(x);  
  
  Quantile q = new Quantile(x);
  //q.sort();
  print(q.x);
  
  print( q.minK(15) );
  
//  test("k-th min element", () {
//    var res = [0, 3, 5, 15].map((k) => q.minK( k )).toList();
//    expect(res, ['A', 'E', 'K', 'X']);
//  });
  
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
//}