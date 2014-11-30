library rect;


/** Interface representing size and position of an element */
class Rect {
  final num x;
  final num y;
  final num width;
  final num height;

  const Rect([this.x = 0, this.y = 0, this.width = 0, this.height = 0]);
  const Rect.size(this.width, this.height) : x = 0, y = 0;
  const Rect.position(this.x, this.y) : width = 0, height = 0;

  bool operator==(Rect other) =>
      isSameSizeAs(other) && isSamePositionAs(other);

  bool isSameSizeAs(Rect other) =>
      other != null && width == other.width && height == other.height;

  bool isSamePositionAs(Rect other) =>
      other != null && x == other.x && y == other.y;

  bool contains(num otherX, num otherY) =>
      otherX >= x && otherX <= x + width &&
      otherY >= y && otherY <= y + height;

  String toString() => '$x, $y, $width, $height';
}


main(){
  
  var r = new Rect();
  print(r);
  // r.width = 100;   // cannot do this because width is final
  
  // a rectangle of a different size
  var r2 = new Rect.size(100, 200);
  print(r2);
  
}