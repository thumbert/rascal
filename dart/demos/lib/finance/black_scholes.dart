library finance.blackscholes;

import 'dart:math';
import 'package:demos/math/special/erf.dart';

enum OptionType {
  call,
  put
}

/**
 * Calculate the price of a vanilla european option on a stock using the
 * Black-Scholes formula.
 *
 * [price] is the security price as of pricing date.
 *
 * [volatility] is the annualized volatility from pricing date to expiration.
 *
 * [time] is the time to expiration in years.
 *
 * [interestRate] is the interest rate from pricing date to expiration
 */
double blackScholes(num price, num volatility, num time,
                    num strike, num interestRate, OptionType type) {

  if (time < 0)
    throw 'Option has already expired (the argument $time is negative)!';
  if (volatility < 0)
    throw 'Volatility is not positive!';

  double d1, d2, res;
  if (time == 0 || volatility == 0) {
    d1 = double.INFINITY;
    d2 = double.INFINITY;
  } else {
    d1 = (log(price/strike) + (interestRate+0.5*volatility*volatility)*time)/(volatility*sqrt(time));
    d2 = d1 - volatility*sqrt(time);
  }

  double Nd1 = Phi(d1);
  double Nd2 = Phi(d2);

  switch (type) {
    case OptionType.call:
      if (time == 0) {
        res = max(price - strike, 0);
      } else {
        res = price*Nd1 - strike*Nd2*exp(-interestRate*time);
      }
      break;
    case OptionType.put:
      if (time == 0) {
        res = max(strike - price, 0);
      } else {
        res = strike*(1-Nd2)*exp(-interestRate*time) - price*(1-Nd1);
      }
      break;
  }

  return res;
}
