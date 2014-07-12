import 'package:intl/intl.dart';

/*
 * Find the best toilet in a large group of N toilets using the following algorithm. 
 * Decide the number of toilets to inspect beforehand, K.  From K+1, choose the 
 * best toilet better than all previous ones.  If you get to N before you find a 
 * better toilet (which means the best toilet was in the first 1:K), you chose the 
 * last toilet. 
 * 
 * Questions, what is the optimal K?  What's the probability to find the best 
 * toilet using this algo?  How many toilets you end up visiting? 
 *   
 * https://www.youtube.com/watch?v=ZWib5olGbQ0
 */



int run_algo(List<int> x, K) {
  Map<String,int> res = {};
  int best;
  
  if (K == (x.length - 2)) {
    // forced to chose the last toilet
    best = x.last;
    
  } else {
    int maxUpToK = x.take(K).fold(0, (a, b) {
      if (a >= b) return a; else return b;
    });

    best = x.sublist(K).firstWhere((e) => e > maxUpToK, 
        orElse: (){return x.last;});
  }

  return best;
}


main() {

  int N = 100; // number of toilets
  int S = 4000; // number of simulations

  var D2 = new NumberFormat("###.##", "en_US");
  
  
  List<int> x = new List.generate(N, (i) => i);
  List<List<int>> res = new List.generate(S, (e) => new List.filled(N-2, 0)); 
  
  
  for (int s = 0; s < S; s++) {
    x.shuffle();
    for (int K = 1; K < (N - 1); K++) {
      res[s][K-1] = run_algo(x, K); 
    }
  }

  // calcualate the average over all the simulations
  List<num> avg = new List.filled(N-2, 0.0);
  for (int K=0; K < (N-2); K++) {
    num sum =0;
    for (int s = 0; s < S; s++) {
      sum += res[s][K];
    }
    avg[K] = sum/S;
    print("${K.toString().padLeft(3)}, ${D2.format(avg[K]).padRight(5,"0")}");
  }
  
  var D3 = new NumberFormat("###.###", "en_US");
  print("Test 1.2 is ${D2.format(1.2).padRight(6, "0")}");
  
}
