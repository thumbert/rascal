import 'dart:math';


main() {
  
  // Euler Mascheroni constant
  num EM = 0.57721566490153286060651209008240243104215933593992;
  
  int N  = 10000;
  
  var base = new List<double>.generate(N, (int i) => 1.0/(i+1));
  
  double lim = base.fold(0.0, (a,b) => a+b) - log(N);
  
  print("lim = " + lim.toString());
  print("error = " + (lim - EM).toString());
  
  
}