



main() {
  print('Hello');
  int n = 17;

  List x = new List.generate(n-1, (i)=> i+2);
  print(x);
  List primes = [];

  Set excluded = new Set();

  for (int i=0; i<x.length; i++) {
    if (excluded.contains(x[i]))
      continue;
    int multiple = 2*x[i];
    while (multiple < x.length) {
      excluded.add(multiple);
      multiple = multiple + x[i];
    }
    if (!excluded.contains(x[i])) {
      primes.add(x[i]);
    }
  }

  print(primes);


}