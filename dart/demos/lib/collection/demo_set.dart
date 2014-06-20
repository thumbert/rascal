

class Point {
  num x;      // Declare an instance variable (x), initially null.
  num y;      // Declare y, initially null.
  
  Point(this.x, this.y);

  toString() => "($x,$y)";
  
  bool operator ==(Point that) {
    return (x == that.x && y == that.y); 
  }

}


main() {
  var s1 = new Set.from([new Point(0,0), 
                         new Point(1,1)]); 
  var s2 = new Set.from([new Point(2,2), 
                         new Point(1,1)]); 

  print(s1.union(s2)); // {(0,0), (1,1), (2,2)}  correct!
  
}  