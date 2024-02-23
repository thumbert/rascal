// library math.combinatorics.stirling2;

// //import 'package:more/int_math.dart';
// import 'dart:math';


// /**
//  * Calculate the Stirling numbers of the second kind using the recurrence formula.
//  */
// int stirling2(int n, int k) {
//   if (k > n) throw 'k cannot be greater than n';

//   List<List<int>> _s2 = [[1], [0,1], [0,1,1], [0,1,3,1]];
//   if (n <= 3) return _s2[n][k];

//   if (k == 0) return 0;

//   if (k == 1) return 1;

//   if (k == 2) return pow(2,n-1)-1;

//   int value;
//   for (int i=4; i<=n; i++) {
//     List row = [0, 1, pow(2,i-1)-1];
//     for (int j=3; j<=min(k,i); j++) {
//       if (j==i)
//         value = 1;
//       else
//         value = j*_s2[i-1][j] + _s2[i-1][j-1];
//       row.add(value);
//     }
//     _s2.add(row);
//   }

//   return value;
// }



// /**
//  * Calculate the Stirling numbers of the second kind using the saddle point
//  * approximation.
//  * http://oai.cwi.nl/oai/asset/2304/2304A.pdf
//  */
// num stirling2Asymptotic(int n, int k) {
//   num res;
//   Function _phi = (x) => -n*log(x) + k*log(exp(x) - 1);


//   return res;
// }

