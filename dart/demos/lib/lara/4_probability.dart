library lara;


main() {
  int N = 100000;
  List<String> x = ['Q', 'Q', 'Q', 'D', 'D', 'N'];

  int count = 0;
  for (int i = 0; i< N; i++) {
    x.shuffle();
    if (x[0] == x[1]) count += 1;
  }

  print('Theoretical is: ${4/15}');
  print('Sample is: ${count/N}');

}