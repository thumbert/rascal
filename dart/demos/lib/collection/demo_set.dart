library demo_set;

class Point {
  num x; // Declare an instance variable (x), initially null.
  num y; // Declare y, initially null.

  Point(this.x, this.y);

  toString() => "($x,$y)";

  bool operator ==(that) {
    return (x == that.x && y == that.y);
  }

}

class Ngram {
  String view;
  List<int> data;

  Ngram(List<int> data) {
    this.data = data;
    this.view = data.map((e) {
      if (e == 1) return "X"; else return " ";
    }).join("");
  }
  
  bool operator ==(that) {
    return view == that.view;
  }
}

main() {
  var s1 = new Set.from([new Point(0, 0), new Point(1, 1)]);
  var s2 = new Set.from([new Point(2, 2), new Point(1, 1)]);

  print(s1.union(s2)); // {(0,0), (1,1), (2,2)}  correct!

  var g1 = new Ngram([1,1,0]);
  var g2 = new Ngram([1,1,0]);
  print("\"${g1.view}\"");
  print(g1 == g2);
  var s3 = new Set()..add([g1,g2]);
  print(s3.length == 1);  // true
  
}
