library finance.security_test;

import 'package:demos/finance/security.dart';

europeanOptionTests() {
  EuropeanStockOption p1 = new EuropeanStockOption(
      new EuropeanStockOptionBuilder(
           BuySell.buy, OptionType.put, 30, new DateTime(2015, 3, 18)))
    ..asOfDate = new DateTime(2015, 1, 1)
    ..volatility = 0.3
    ..interestRate = 0.01;

  List prices = new List.generate(10, (i) => i + 30);
  prices.forEach((price) {
    p1..underlyingPrice = price;
    print(p1.value().toStringAsFixed(3));
  });



}

main() {
  europeanOptionTests();
}
