import 'package:intl/intl.dart';
import 'dart:math';

/*
 * You have a set of N objects, each object has a score ${X_i}$.  You want to find 
 * the object with the maximum score but you don't want to scan all the objects 
 * (because they are too many, etc.)  You decide to inspect the first 1 to K 
 * objects and record their highest score, which you denote with $M_K$.  Then you 
 * keep inspecting new objects and decide to stop when you find an object with a 
 * score $X_i > M_K$.  What is the probability that you've found the object with 
 * the true maximum score $M = \max_{i} X_i$? 
 * 
 * 
 * Question: What is the optimal K?  What's the probability to find the best 
 * toilet using this algo?  How many toilets you end up visiting? 
 *   
 * https://www.youtube.com/watch?v=ZWib5olGbQ0
 */



int run_algo(List<int> x, K) {
  int best;
  
  if (K == (x.length - 1)) {
    // forced to chose the last toilet
    best = x.last;
    
  } else {
    int maxUpToK = x.take(K+1).fold(0, (a, b) {
      if (a >= b) return a; else return b;
    });

    best = x.sublist(K+1).firstWhere((e) => e > maxUpToK, 
        orElse: (){return x.last;});
  }

  return best;
}


main() {

  int N = 100;  // number of objects
  int S = 1000; // number of simulations
  var rand = new Random(1);
  
  
  var D2 = new NumberFormat("####.###", "en_US");
  
  // generate the scores, from 1:N
  List<int> x = new List.generate(N, (i) => i+1);
  
  List<List<int>> pick = new List.generate(S, (e) => new List.filled(N, 0)); 
  
  // loop over simulations
  for (int s = 0; s < S; s++) {
    x.shuffle(rand);
    // try different K values
    for (int K = 0; K < N; K++) {
      pick[s][K] = run_algo(x, K); 
    }
  }

  
  // the average pick over all the simulations
  List<num> avgPick  = new List.filled(N, 0.0);
  // the probability to get the Maximum value
  List<num> pMax = new List.filled(N, 0.0);  
  
  for (int K=0; K < N; K++) {
    num sum = 0;
    num count = 0;
    for (int s = 0; s < S; s++) {
      if (pick[s][K] == N) 
        count += 1.0;
      sum += pick[s][K];
    }
    pMax[K] = count/S;
    avgPick[K] = sum/S/N;
    //print("${K.toString().padLeft(3)}, ${D2.format(avg[K]).padRight(8,"0")}");
  }
  
  //////////////////////////////////////////////////////////////////////////
  // results
  print("\n\nAverage order of the selection: ");
  for (int K=0; K < N; K++) {
    print("${(K/N).toString().padLeft(3).padRight(4, "0")},  ${avgPick[K].toStringAsPrecision(3).padRight(5,"0")}");
  } 
  
  print("\n\nProbability to get the maximum: ");
  for (int K=0; K < N; K++) {
    print("${(K/N).toStringAsFixed(3)},  ${pMax[K].toStringAsFixed(4)}");    
  } 
  
  //print("Probability check: \sum{pMax}=${pMax.reduce((a,b)=>a+b)}");
  
  
}
