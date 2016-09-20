library test.cointossing;

import 'package:dama/dama.dart';

/// when do you have the right pattern
bool isDone(List<String> path, Function fun)  => fun(path);

Function patternHH = (List<String> path) => path.last == 'H' && path[path.length-1] == 'H';
Function patternHT = (List<String> path) => path.last == 'T' && path[path.length-1] == 'H';


/// Calculate the number of coin flips until the pattern
/// HH and HT happens.
expected_tosses_HH_HT() {
  var dist = new DiscreteDistribution(['H', 'T'], [0.5, 0.5]);
  int N = 10;

  List<int> stepsHH = [];
  List<int> stepsHT = [];
  String current = dist.sample();
  for (int i=0; i<N; i++) {
    String previous = current;
    current = dist.sample();

  }

}

main() {


}