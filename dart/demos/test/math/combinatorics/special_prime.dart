/// find a prime that has a certain number patterns in it.
/// An anniversary prime!

import 'package:more/int_math.dart';
import 'package:more/iterable.dart';
import 'package:trotter/trotter.dart';

/// Find a prime that contains all the input tokens.
int findSpecialPrime(List<num> tokens) {
  int res;

  var digits = '0123456789'.split('').map((e) => int.parse(e));

  int maxAdditionalDigits = 3;
  for (int additionalDigit = 0;
      additionalDigit < maxAdditionalDigits;
      additionalDigit++) {
    print('Additional digit = $additionalDigit');
    var items = combinations(digits, additionalDigit, repetitions: true);
    for (var item in items) {
      var allTokens = tokens..addAll(item);
      var permutations = new Permutations(allTokens.length, allTokens);
//      for (var permutation in permutations) {
//        var n = num.parse(permutation.join());
//        print('trying number $n');
//        if (isProbablyPrime(n)) {
//          res = n;
//          return n;
//        }
//
//      }
    }
  }

  return res;
}

///
main() {
  int res = findSpecialPrime([1001, 505, 1207]);
  print('Number 50510011207 is prime!');
}
