
import 'dart:math';

import '../../../lib/math/probability/distance_between_points_in_square.dart';

void main() {
  var ls = countDistances(3);
  for (var e in ls) {
    print('${e.distance.toStringAsFixed(6)} : ${e.count}');
  }
  print('total segments: ${ls.map((e) => e.count).reduce((a, b) => a + b)}');
  print('total distinct distances: ${ls.length}');
  print('mean distance: ${meanDistance(ls)}');
  print('exact mean distance: ${(2 + sqrt(2) + 5*log(sqrt2 + 1))/15}');


}