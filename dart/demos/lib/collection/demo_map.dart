library demo_map;


/**
 * Group by key
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
  
  Map<String,List<int>> res = new Map<String,List<int>>();  
  String key;

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


/**
 * Aggregate a map of lists
 */
make2() {
  Map<String, List<int>> m2 = new Map();
  m2['A'] = [1];
  m2['B'] = [1,1];
  m2['C'] = [1,1,1];
  m2['D'] = [1,1,1,1];
  
  Map<String,int> agg = new Map();
  for (String key in m2.keys) {
    print("On key " + key);
    print("Values: " + m2[key].toString());
    agg[key] = m2[key].fold(0, (a, b) => a + b);
  }
  agg.forEach((String k, int v) => print("(" + k + "," + v.toString() +")"));
  print("Done aggregating");
}


make3() {
  List x = ["Jan", "Feb", "Mar"];
  var y = new Map.fromIterables(x, new List.generate(x.length, (i) => i));
  print(y);
}


Map sortMapByKey(Map x){
    Map y = {};
    var sKeys = x.keys.toList()..sort();
    sKeys.forEach((k) => y[k] = x[k]);
    return y;
  }

main() {
  
  
  // group by key
  //make1();
  
  // how to aggregate a Map of Lists.  
  //make2();
  
  // make a map from a list, with values the index of the list
  //make3();  // {Jan: 0, Feb: 1, Mar: 2}
  
  //make4();
  
  // can I have a map with a null key? -- YES
  Map x = {"A": [1,2], null: [2,3], "C": [4,5,6]};
  print(x);       // {A: [1, 2], null: [2, 3], C: [4, 5, 6]}  
  print(x.keys);  // (A, null, C)
  print(x[null]); // [2,3]
  
  /// sort a map by keys
  Map x1 = {4: 'D', 1: 'A', 3: 'C', 2: 'B'};
  print(sortMapByKey(x1));
  
}
