library finance.blackscholes;

import 'dart:math';
import 'package:dama/special/erf.dart';
import 'security.dart';

class BlackScholes {
  final CallPut type;
  final DateTime expirationDate;
  final num strike;
  DateTime asOfDate;
  num interestRate;
  num underlyingPrice;
  num volatility;

  /// Implement the Black-Scholes model for European option on a stock.
  BlackScholes(this.type, this.strike, this.expirationDate) {}

  /// Calculate the value of this option.  Values for the [asOfDate], [underlyingPrice],
  /// [volatility], and [interestRate] can be set directly in the object.
  ///
  num value() {
    _validate();
    num res;
    num tExp = _timeToExpiration(asOfDate, expirationDate);
    switch (type) {
      case CallPut.call:
        if (tExp == 0) {
          res = max(underlyingPrice - strike, 0);
        } else {
          res = underlyingPrice *
              _nd1(
                  tExp, volatility, underlyingPrice, strike, interestRate) -
              strike *
                  _nd2(
                      tExp, volatility, underlyingPrice, strike, interestRate) *
                  exp(-interestRate * tExp);
        }
        break;
      case CallPut.put:
        if (tExp == 0) {
          res = max(strike - underlyingPrice, 0);
        } else {
          res = strike *
              (1 -
                  _nd2(tExp, volatility, underlyingPrice, strike,
                      interestRate)) *
              exp(-interestRate * tExp) -
              underlyingPrice *
                  (1 -
                      _nd1(tExp, volatility, underlyingPrice, strike,
                          interestRate));
        }
        break;
    }
    return res;
  }

  /// Calculate the delta of the option (sensitivity with respect to underlying
  /// price.)
  ///
  num delta() {
    _validate();
    num res;
    num tExp = _timeToExpiration(asOfDate, expirationDate);
    switch (type) {
      case CallPut.call:
        res = _nd1(tExp, volatility, underlyingPrice, strike, interestRate);
        break;
      case CallPut.put:
        res = -Phi(
            -_nd1(tExp, volatility, underlyingPrice, strike, interestRate));
        break;
    }
    return res;
  }

  void _validate() {
    if (underlyingPrice == null) throw 'Underlying price has not been set';
    if (interestRate == null) throw 'Interest rate has not been set';
    if (asOfDate == null) throw 'Need to set the as of date';
    if (volatility == null) throw 'Volatility is not set';
  }

  /// Calculate the gamma of the option (second derivative with respect to
  /// the underlying price.)
  double gamma() {
    _validate();
    num tExp = _timeToExpiration(asOfDate, expirationDate);
    double aux = volatility * underlyingPrice * sqrt(tExp);
    return _dNd1(tExp, volatility, underlyingPrice, strike, interestRate) / aux;
  }
//
//  /**
//   * Calculate the theta of the option (sensitivity with respect to time.)
//   */
//  double theta() {
//    double t1 =
//        -volatility * underlyingPrice * _dNd1() / (2 * sqrt(timeToExpiration));
//    double res;
//    switch (typeCallPut) {
//      case OptionType.call:
//        res = t1 -
//            interestRate *
//                strike *
//                exp(-interestRate * timeToExpiration) *
//                _nd2();
//        break;
//      case OptionType.put:
//        res = t1 -
//            interestRate *
//                strike *
//                exp(-interestRate * timeToExpiration) *
//                Phi(-_nd2());
//        break;
//    }
//    return _sign() * res;
//  }
//
//  /**
//   * Calculate the vega of the option (sensitivity with respect to volatility.)
//   */
//  double vega() =>
//    _sign() * underlyingPrice * sqrt(timeToExpiration) * _dNd1();
//
//  /**
//   * Calculate the sensitivity of the option with respect to interest rate
//   */
//  double rho() {
//    double res;
//    switch (typeCallPut) {
//      case OptionType.call:
//        res = strike *
//            timeToExpiration *
//            exp(-interestRate * timeToExpiration) *
//            _nd2();
//        break;
//      case OptionType.put:
//        res = strike *
//            timeToExpiration *
//            exp(-interestRate * timeToExpiration) *
//            Phi(-_nd2());
//        break;
//    }
//    return _sign() * res;
//  }

}

double _d1(num tExp, num volatility, num underlyingPrice, num strike,
    num interestRate) {
  double d1;
  if (tExp == 0.0 || volatility == 0)
    d1 = double.infinity;
  else
    d1 = (log(underlyingPrice / strike) +
        (interestRate + 0.5 * volatility * volatility) * tExp) /
        (volatility * sqrt(tExp));
  return d1;
}

double _nd1(num tExp, num volatility, num underlyingPrice, num strike,
    num interestRate) =>
    Phi(_d1(tExp, volatility, underlyingPrice, strike, interestRate));
double _d2(num tExp, num volatility, num underlyingPrice, num strike,
    num interestRate) {
  double d2;
  if (tExp == 0 || volatility == 0)
    d2 = double.infinity;
  else
    d2 = (log(underlyingPrice / strike) +
        (interestRate + 0.5 * volatility * volatility) * tExp) /
        (volatility * sqrt(tExp)) -
        volatility * sqrt(tExp);
  return d2;
}

double _nd2(num tExp, num volatility, num underlyingPrice, num strike,
    num interestRate) =>
    Phi(_d2(tExp, volatility, underlyingPrice, strike, interestRate));
double _dNd1(num tExp, num volatility, num underlyingPrice, num strike,
    num interestRate) {
  num d1 = _d1(tExp, volatility, underlyingPrice, strike, interestRate);
  return exp(-0.5 * d1 * d1) / sqrt(2 * pi);
}

num _timeToExpiration(DateTime asOfDate, DateTime expirationDate) {
  return max(0, expirationDate.difference(asOfDate).inDays / 365.25);
}


