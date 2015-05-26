library test_median;

import 'package:test/test.dart';
import 'package:demos/math/stats/median.dart';


testNumericQuantile() {
  List x = [3, 1, 5, 9, 4, 2, 7];
  Quantile q = new Quantile(x);
  test('min', () {
    var res = new List.generate(7, (i) => i).map((e) => q.minK(e));
    expect(res, [1,2,3,4,5,7,9]);
  });

  var y = [3, 1, double.NAN, 8]..sort();
  print(y);

}





main() {
  print("Hi");

  List x = 'KRATELEPUIMQCXOS'.split("");
  //x.sort();
  print(x);  
  
  Quantile q = new Quantile(x);
  //q.sort();
  print(q.x);
  
  print( q.minK(15) );

  var y = 0x1 << 10;
  print(y);

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