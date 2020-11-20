library finance.european_option_test;

import 'package:timezone/standalone.dart';
import 'package:date/date.dart';
import 'package:elec/risk_system.dart';
import 'package:demos/finance/european_option.dart';
import 'package:test/test.dart';

tests() {
  group('Black-Scholes model', () {
    test('calculate daily vol', () {
      var timeToExpiration =
          (Date(2021, 1, 1).value - Date(2020, 11, 20).value) / 365;
      var mVol = 0.9795221;
      var cVol = 2.60;
      var dVol = dailyVolatility(mVol, cVol, timeToExpiration);
      print(dVol);
      expect(dVol.toStringAsFixed(4), '1.5767');
    });
    test('futures option', () {
      var c100 = EuropeanOption(CallPut.call, 100, Date(2021, 1, 15))
        ..underlyingPrice = 46.0
        ..asOfDate = Date(2020, 11, 19)
        ..volatility = 1.6231
        ..riskFreeRate = 0;
      print(c100.value());
      expect(c100.value() > 1, true);
    });
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
