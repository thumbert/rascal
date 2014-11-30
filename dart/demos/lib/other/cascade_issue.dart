
library cascade_issue;

/**
 * Seems that functions cannot be used in method cascades ...  It works if you add parantheses ...
 */

class Chunk {  
  String name;
  List<Map> data;
  Function extractor;
  
  Chunk();
}

main() {
  
  var data = [{"Sepal.Length":5.1,"Sepal.Width":3.5,"Petal.Length":1.4,"Petal.Width":0.2,"Species":"setosa"},
              {"Sepal.Length":4.9,"Sepal.Width":3,"Petal.Length":1.4,"Petal.Width":0.2,"Species":"setosa"},
              {"Sepal.Length":4.7,"Sepal.Width":3.2,"Petal.Length":1.3,"Petal.Width":0.2,"Species":"setosa"},
              {"Sepal.Length":4.6,"Sepal.Width":3.1,"Petal.Length":1.5,"Petal.Width":0.2,"Species":"setosa"},
              {"Sepal.Length":5,"Sepal.Width":3.6,"Petal.Length":1.4,"Petal.Width":0.2,"Species":"setosa"},
              {"Sepal.Length":5.4,"Sepal.Width":3.9,"Petal.Length":1.7,"Petal.Width":0.4,"Species":"setosa"}];
  
  // fails if you use method cascades for extractor
  var chunk = new Chunk()
      ..data = data
      ..extractor = ((e) => e["Species"])         // doesn't like this
      ..name = "Iris";
  print( chunk.data.map(chunk.extractor) );  // this one fails 
  
  // if you don't use method cascades for extractor, it works OK
  var chunk2 = new Chunk()
      ..data = data;
  chunk2.extractor = (e) => e["Species"];
  chunk2.name = "Iris";
  print( chunk2.data.map(chunk2.extractor) );  // (setosa, setosa, setosa, setosa, setosa, setosa)
  
  
}