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


// extract one "column"
make4() {
  var m4 = [{"Sepal.Length":5.1,"Sepal.Width":3.5,"Petal.Length":1.4,"Petal.Width":0.2,"Species":"setosa"},
  {"Sepal.Length":4.9,"Sepal.Width":3,"Petal.Length":1.4,"Petal.Width":0.2,"Species":"setosa"},
  {"Sepal.Length":4.7,"Sepal.Width":3.2,"Petal.Length":1.3,"Petal.Width":0.2,"Species":"setosa"},
  {"Sepal.Length":4.6,"Sepal.Width":3.1,"Petal.Length":1.5,"Petal.Width":0.2,"Species":"setosa"},
  {"Sepal.Length":5,"Sepal.Width":3.6,"Petal.Length":1.4,"Petal.Width":0.2,"Species":"setosa"},
  {"Sepal.Length":5.4,"Sepal.Width":3.9,"Petal.Length":1.7,"Petal.Width":0.4,"Species":"setosa"}];
  
  print(m4.map((e) => e["Species"]));
  
  var fun = (e) => e["Species"];
  print(m4.map( fun ));
  
  
  
}

main() {
  
  
  // group by key
  //make1();
  
  // how to aggregate a Map of Lists.  
  //make2();
  
  // make a map from a list, with values the index of the list
  //make3();  // {Jan: 0, Feb: 1, Mar: 2}
  
  make4();
  
  
  
}