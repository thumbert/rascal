/* Study the marriage problem by Moivre. 
 * 2N balls in an urn, N numbered pairs of white and black balls.
 * Extract one ball at at time.  Calculate the expected number 
 * of pairs left in the urn after K balls have been extracted. 
 */


class Urn {
  late List<String> contents;
  List<String> extracted = [];

  int get size => contents.length;
  
  /**
   * Construct an urn with N pairs of two colored balls. 
   */ 
  Urn(int N) {
    contents = new List.generate(2*N, (i) {
      if (i % 2 == 0) {
        return "${i~/2}W";
      } else {
        return "${i~/2}B";        
      }
    });
    
    contents.shuffle();
  }
  
  // extract K elements from the Urn
  void extract(int K) {
    extracted.addAll(contents.take(K));
    contents.removeRange(0,K);
  }
  
  /**
   * count how many pairs are left in the urn
   */ 
  int pairs() {
    
    return 0;
  }
  
}

void probExtractOnePair(int N, {int simulations =  10000}) {
  List<int> res = new List.generate(simulations, (int i) {
    Urn urn = new Urn(N);
    urn.extract(2);
    if (urn.extracted[0][0] == urn.extracted[1][0]) { // same number, (for sure different color)
      return 1;
    } else {
      return 0;
    }
  });
  
  print("\n\nProbability to pick one pair:");
  print("Experimental: ${res.fold(0, (a,b)=>a+b)/simulations}");
  print("Theoretical:  ${1/(2*N-1)}");  
}


main() {
  Urn urn = new Urn(3);
  print("Urn contents: ${urn.contents}");
  
  print("extract 2 elements");
  urn.extract(2);
  print("Urn contents:  ${urn.contents}");
  print("Urn extracted: ${urn.extracted}");
  
  // extract one pair 
  probExtractOnePair(3, simulations: 20000);
  
  
}