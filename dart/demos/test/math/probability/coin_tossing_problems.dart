library test.cointossing;

import 'dart:math';
import 'package:dama/dama.dart';

/// Check if you do have the right pattern
bool match(List<String> x, List<String> pattern) {
  if (x.length < pattern.length) return false;
  for (int i = 1; i<=pattern.length; i++) {
    if  (x[x.length-i] != pattern[pattern.length-i]) return false;
  }
  return true;
}

/// Sample until the given pattern is met
List<String> takeUntil(DiscreteDistribution dist, List<String> pattern) {
  List<String> x = [];
  while (!match(x, pattern)) {
    x.add(dist.sample());
  }
  return x;
 }

/// The expected number of coin tosses until pattern HH shows up
/// is given by this sum:
/// \sum{i=0}{\infty} \frac{F_i (i+2)}{2^{i+2}} where F_i is the Fibonacci number
/// of order i.  F_0=1, F_1=1, F_2=2, F_3=3, F_4=5, etc.
/// You get to this expression by simple counting:
/// Pattern HH appears with probability 1/4 and has length 2
/// Pattern THH appears with probability 1/8 and has length 3,
/// Patterns TTHH, HTHH appear with probability 2/16 and have length 4, etc.
///
sumSeries({int nTerms: 1000}) {
  List<num> res = [1/2, 3/8];
  int f1 = 1;
  int f2 = 1;
  int aux;
  for (int i=3; i<nTerms; i++) {
    res.add((f1 + f2)*(i+1)/pow(2,i+1));
    aux = f2;
    f2 = f1 + f2;
    f1 = aux;
  }
  print('\nExpected number of tosses = 6, Actual = ${res.reduce((a,b)=>a+b)}');
}


/// Calculate the number of coin flips until the pattern
/// HH and HT happens.  Here are the results for 50000 runs.
///
///Summary of number of tosses until HH pattern happens
///{Min.: 2, 1st Qu.: 2.0, Median: 4.0, Mean: 5.99524, 3rd Qu.: 8.0, Max.: 61}
///
///Summary of number of tosses until HT pattern happens
///{Min.: 2, 1st Qu.: 2.0, Median: 3.0, Mean: 4.00142, 3rd Qu.: 5.0, Max.: 19}
///
///
expected_tosses_HH_HT() {
  var dist = new DiscreteDistribution(['H', 'T'], [0.5, 0.5]);
  int N = 50000;

  List<int> resHH = [];
  for (int i=0; i<N; i++) {
    var x = takeUntil(dist, ['H', 'H']);
    resHH.add(x.length);
  }
  print('\nSummary of number of tosses until HH pattern happens');
  print(summary(resHH));

  List<int> resHT = [];
  for (int i=0; i<N; i++) {
    var x = takeUntil(dist, ['H', 'T']);
    resHT.add(x.length);
  }
  print('\nSummary of number of tosses until HT pattern happens');
  print(summary(resHT));



  //res.forEach(print);
}

main() {
  expected_tosses_HH_HT();

  sumSeries(nTerms: 1000);

}