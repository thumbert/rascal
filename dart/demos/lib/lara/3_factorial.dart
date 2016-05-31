/// Factorials


int factorial(int n) {
  int fac = 1;
  for ( var i = 2; i <= n; i++) {
    fac= fac*i;

  }
  return fac;
}


main(){



  for ( var i = 1; i<=30; i++){
    print("i=$i, factorial= ${factorial(i)}");
  }



}