/// My first program
/// no!
/// to tabulate the value of coins
/// 5/12/2016


main() {
  print("im starting");

  /// total number of coins
  int N = 50;

  /// nn is the number of nickels
  for(int nn=0; nn<=N; nn++) {
    /// nd is the number of dimes
    int nd = N - nn;
    int value = 5*nn + 10*nd;
    print('nickels: $nn, dimes: $nd, value: $value');
  }

}

