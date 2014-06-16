/*
 * Solve CP + IS + FUN = TRUE in base 10
 */

class Solution {
  List<int> _data;
  Solution(List<int> this._data);
  
  toString() => "  c=" + _data[0].toString() +
                ", e=" + _data[1].toString() +
                ", f=" + _data[2].toString() +
                ", i=" + _data[3].toString() +
                ", n=" + _data[4].toString() +
                ", p=" + _data[5].toString() +
                ", r=" + _data[6].toString() +
                ", t=" + _data[7].toString() +
                ", s=" + _data[8].toString() +
                ", u=" + _data[9].toString();
}

class Digits {
  int min;
  int max;
  
  Digits(int this.min, int this.max);
  
  List<int> range() {
    List<int> res = [];
    for (int i=min; i<= max; i++){
      res.add(i);
    }
    return res;
  }
  
  List<int> rangeWithout(List<int> x) {
    List<int> res = [];
    for (int i=min; i<= max; i++){
      if (!x.contains(i)) res.add(i);
    }
    return res;
  }
}

/*
 * Split an integer into a list of digits, e.g. 345 becomes [3,4,5]
 */
List<int> split10(int x) {
  return x.toString().split("").map((e) => int.parse(e)).toList(growable: false);
}
int ones(int x) => split10(x).last;
int tens(int x) {
  int res;
  if (x < 10) res = 0; else res = split10(x).reversed.toList(growable: false)[1];
  return res;
}


brute_force() {
  List<Solution> allSolutions = [];
  num counter = 0;
  for (int c in new Digits(1,9).range()) {
    for (int i in new Digits(1,9).rangeWithout([c])) {
      for (int p in new Digits(0,9).rangeWithout([c,i])) {
        for (int s in new Digits(0,9).rangeWithout([c,i,p])) {
          for (int n in new Digits(0,9).rangeWithout([c,i,p,s])) {
            for (int e in new Digits(0,9).rangeWithout([c,i,p,s,n])) {
              for (int u in new Digits(0,9).rangeWithout([c,i,p,s,n,e])) {
                for (int f in new Digits(1,9).rangeWithout([c,i,p,s,n,e,u])) {
                  for (int r in new Digits(0,9).rangeWithout([c,i,p,s,n,e,u,f])) {
                    int t = tens(f+tens(c+i+u));
                    counter += 1;
                    if (ones(p+s+n) == e && 
                        ones(c+i+u+tens(p+s+n)) == u &&
                        ones(f+tens(c+i+u)) == r &&
                        !([0,c,i,p,s,n,e,u,f].contains(t))
                       ) {
                      allSolutions.add(new Solution([c, e, f, i, n, p, r, t, s, u]));
                    };
                  }
                }
              }
            }
          }
        }
      }
    }
  } 
  print("Checked " + counter.toString() + " combinations.");
  return allSolutions;
}


main() {
 
  List<Solution> sols = brute_force();
  sols.forEach((e) => print(e));
  print("number of solutions: " + sols.length.toString());
  
  
}