library finance.european_option_test;


import 'package:timezone/standalone.dart';
import 'package:date/date.dart';
import 'package:elec/risk_system.dart';
import 'package:demos/finance/european_option.dart';
import 'package:test/test.dart';


tests() {
  group('Black-Scholes model', () {
    test('Call', () {
      var c1 = EuropeanOption(CallPut.call, 100, Date(2015, 1, 31))
        ..underlyingPrice = 100
        ..asOfDate = Date(2015, 1, 1)
        ..volatility = 0.25
        ..riskFreeRate = 0.03;
      expect(c1.value().toStringAsFixed(4), '2.9790');
      expect(c1.delta().toStringAsFixed(4), '0.5280');
      expect(c1.gamma().toStringAsFixed(4), '0.0555');
      expect(c1.vega().toStringAsFixed(4), '0.1141');
      expect(c1.theta().toStringAsFixed(4), '-0.0516');
      expect(c1.rho().toStringAsFixed(4), '0.0004');
      expect(c1.impliedVolatility(2.978962).toStringAsFixed(4), '0.2500');

//      var prices = List.generate(10, (i) => 95 + i );
//      prices.forEach((price) {
//        c1..underlyingPrice = price;
//        print(c1.value().toStringAsFixed(8));
//      });
    });
  });



}

main() async {
  await initializeTimeZone();
  tests();
}

