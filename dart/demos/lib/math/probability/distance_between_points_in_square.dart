
import 'dart:math';

/// Calculate the distribution of the distance between two random points in the
/// unit square.
/// Don't know how to do it with pen and paper, so I will do it by
/// approximating the square with a grid of points and counting all the
/// possible distances.  Study how as the number of grid points n increases,
/// the discrete distribution converges to a continuum distribution.
///
///

/// Count the distances between all points of unit square grid, where grid
/// size is 1/n.
List<Length> countDistances(int n) {
  var out = <Length>[];
  /// First, there are integer lengths when you join points vertically and
  /// horizontally.  For example, there are 2*n*(n+1) segments of length 1/n.
  for (var i=1; i<=n; i++) {
    out.add(Length(i/n, 2*(n+1-i)*(n+1)));
  }
  /// Next, there are irrational lengths, when you join points across a diagonal.
  /// In general, for a segment which goes 'a' points horizontally and 'b'
  /// points vertically (or vice-versa) there are 4*(n+1-a)*(n+1-b) segments of
  /// length \sqrt{a^2 + b^2}.  The exception are the shortest and the
  /// largest diagonal segments.  There are 2*n^2 segments of size \sqrt{2}/n
  /// and there are exactly 4 segments of size \sqrt{2}.
  out.add(Length(sqrt(2)/n, 2*n*n));
  out.add(Length(sqrt(2), 4));
  for (var a=1; a<n; a++) {
    for (var b=a+1; b<n; b++) {
      // if (4*(n+1-a)*(n+1-b) == 120) {
      //   print('here');
      // }
      out.add(Length(sqrt(a*a + b*b)/n, 4*(n+1-a)*(n+1-b)));
    }
  }
  out.sort((a,b) => a.distance.compareTo(b.distance));
  return out;
}

void calculatePdf(List<Length> ls) {

}

num meanDistance(List<Length> ls) {
  var count = 0;
  var sum = 0.0;
  for (var e in ls) {
    sum += e.count * e.distance;
    count += e.count;
  }
  return sum/count;
}

class Length {
  Length(this.distance, this.count);
  final num distance;
  final int count;
}
