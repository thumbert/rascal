/*
 * From Ott's book, page 39
 * the logistic equation
 */

double next(double x, double r) => r*x*(1-x);

class Attractor {
  double r;
  List<double> x;
  
  Attractor(this.r, this.x);
}

logistic() {
  List<Attractor> res = [];
  
  double r = 3.5;
  while (r <= 4.0) {
    double x = 0.5;
    // get to the attractor
    for (int i=0; i<500; i++) {
      x = next(x, r);
    }
    
    // start recording the next 1000 points
    List<double> xAttr = new List(1000);
    xAttr[0] = x;
    for (int i=1; i<1000; i++) {
      xAttr[i] = next(xAttr[i-1], r);
    }
    res.add(new Attractor(r, xAttr));
    
    r += 0.01;
  }
  
  return res;
}

main() {
  
  // very fast, just an iteration over 51*1500 points
  List<Attractor> res = logistic();
  print(res.length.toString());
  
  res.first.x.forEach((e)=>print(e));
  
  print("Done");
}