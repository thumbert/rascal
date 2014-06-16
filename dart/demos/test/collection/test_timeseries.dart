library test_timeseries;

import 'package:unittest/unittest.dart';
import 'package:demos/collection/demo_timeseries.dart';
import 'dart:math';

main() {

  test("make one", () {
    var index = seq(new DateTime(2014), new DateTime(2014,12,31,23), 
        new Duration(hours: 1));
    var ts = new TimeSeries.fill(index, 1);
    expect(ts.length, 8760);
    //print(ts.first);
  });
  
  test("indexing speed is super fast!  Am I doing something wrong?!", () {
    var index = seq(new DateTime(2000), new DateTime(2015,12,31,23), 
            new Duration(hours: 1));
    TimeSeries ts = new TimeSeries.fill(index, 1);
    int max = ts.length;
    
    // generate a lot of indices
    var rnd = new Random(21);
    List<int> idx = new List.generate(1000000, (i) => rnd.nextInt(max), growable: false);
    //print(idx.take(5));
        
    Stopwatch watch = new Stopwatch()..start();
    var r1 = idx.map((i) => ts.obsAtSlow(index[i]));
    print("linear search takes ${watch.elapsed}");
    watch.reset();
    
    var r2 = idx.map((i) => ts.obsAt(index[i]));
    print("binary search takes ${watch.elapsed}");
    //print(r1.take(5));
    //print(r2.take(5));
    expect(r1.take(100), r2.take(100));    // full thing is too slow
  });
  
  test("filter elements", () {
    var index = seq(new DateTime(2014), new DateTime(2014,12,31,23), 
        new Duration(hours: 1));
    var ts = new TimeSeries.fill(index, 1);
    
    DateTime from = new DateTime(2014, 6);
    ts.retainWhere((e) => from.isBefore(e.index) || from == e.index);
    expect(ts.first, new Obs(from, 1));
  });
  
  
  
}