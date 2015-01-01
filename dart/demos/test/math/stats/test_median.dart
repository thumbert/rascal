library test_median;

import 'package:demos/math/stats/median.dart';
import 'package:unittest/unittest.dart';

main() {
  print((22) >> 1);
  
  List x = 'KRATELEPUIMQCXOS'.split("");
  //x.sort();
  print(x);
  
  Quantile q = new Quantile();
  //print(q.partition(x, 0, x.length-1));
  //print(q.x);
  
  print(q.sort(x));
  
  
  
  test("median", () {
    //expect(quickSelect([5,4,2,1,3], 3), 3);
  });
}