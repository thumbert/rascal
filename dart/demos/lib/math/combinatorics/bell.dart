// library math.combinatorics.bell;

// import 'package:more/int_math.dart' show binomial;

// /**
//  * Calculate the Bell number of a given order n.
//  * Use the recurrence formula.
//  *  b(n) = \sum_{k} \binomial(n-1,k) b(k)
//  *  b(0) = 1
//  */
// int bell(int n) {
//   if (n < _bell.length) return _bell[n];
//   else {
//     /// need to calculate all the ones that are missing from the cache
//     int from = _bell.length;
//     for (int i=from; i<=n; i++) {
//       int res = 0;
//       for (int k=0; k<i; k++) {
//         res += binomial(i-1, k) * _bell[k];
//       }
//       _bell.add(res);
//     }
//   }

//   return _bell[n];
// }

// List<int> _bell = [1, 1, 2, 5, 15, 52];
// //List<int> _bell = [1, 1, 2, 5];