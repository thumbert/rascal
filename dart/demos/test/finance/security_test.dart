library finance.security_test;

import 'package:demos/finance/security.dart';

europeanOptionTests() {
  CallOption c1 = new CallOption('ACM', 30, new DateTime(2015, 3, 18))
    ..asOfDate = new DateTime(2015, 1, 1)
    ..volatility = 0.3
    ..interestRate = 0.01;

  List prices = new List.generate(10, (i) => i + 25);
  prices.forEach((price) {
    c1..underlyingPrice = price;
    print(c1.value().toStringAsFixed(8));
  });



}

main() {
  europeanOptionTests();
}
