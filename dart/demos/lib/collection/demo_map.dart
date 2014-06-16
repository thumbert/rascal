import 'dart:io';

/*
 * Play with maps
 */

make1(){
  Map<int,int> m1 = {
    1 : 1,
    2 : 4,
    3 : 9,
    4 : 16,
    5 : 25,
    6 : 36,
    7 : 49,
    8 : 64
  };  
  
  return m1;
}

make2() {
  Map<String, List<int>> m2 = new Map();
  m2['A'] = [1];
  m2['B'] = [1,1];
  m2['C'] = [1,1,1];
  m2['D'] = [1,1,1,1];
  
  return m2;
}

Function interpolateNumber(a, b) {
  if (a is String) {
    a = (a.length == 0) ? 0 : double.parse(a);
  }
  if (b is String) {
    b = (b.length == 0) ? 0 : double.parse(b);
  }
  b -= a;
  return (t) { return a + b * t; };
}


main() {
  
  var f = interpolateNumber(1, 10) (5);
  print(f.toString());
  
  
  Map<int,int> m1 = make1();
  
  Map<String, List<int>> m2 = make2();
  
  // how to aggregate a Map of Lists.  
  Map<String,int> agg = new Map();
  for (String key in m2.keys) {
    print("On key " + key);
    print("Values: " + m2[key].toString());
    agg[key] = m2[key].fold(0, (a, b) => a + b);
  }
  agg.forEach((String k, int v) => print("(" + k + "," + v.toString() +")"));
  print("Done aggregating");
  
  Map<String,List<int>> res = new Map<String,List<int>>();
  
  String key;
  
  Function newKey = (key) => {};
  
  m1.forEach((k,v) {
    if (k%2 == 0) {
      key = "even";
    } else {
      key = "odd";
    }
    if (res.containsKey(key)) {
      res[key].add(v);
    } else {
      res[key] = [v];
    }
  });
  
  res.forEach((k,v) {
    print("Key:" + k + " Values: " + v.join(","));
  });
  
  
  
  
  
}