library test.cointossing;

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

}