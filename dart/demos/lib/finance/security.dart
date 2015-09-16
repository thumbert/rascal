library finance.security;

import 'dart:math';
import 'package:demos/math/special/erf.dart';

enum OptionType { call, put }
enum BuySell { buy, sell }

abstract class Security {}

abstract class SimpleSecurity implements Security {
  BuySell buySell;
  DateTime asOfDate;
  num quantity;
  num value();

  static final Map<BuySell, int> _signMap = {BuySell.buy: 1, BuySell.sell: -1};
  int _sign() => _signMap[buySell];
}

class Stock extends SimpleSecurity {
  Stock(BuySell buySell) {
    this.buySell = buySell;
  }
  num value() => 0.0;
}

abstract class Builder<T> {
  T build();
}

abstract class Strike {
  num strike;
}

abstract class ExpirationDate {
  DateTime expirationDate;
}

abstract class Ticker {
  String ticker;
}

class _OptionFields {
  OptionType typeCallPut;

  // market data
  DateTime asOfDate;
  num underlyingPrice;
  num interestRate;
  num _volatility;
  set volatility(num value) {
    if (value < 0) throw 'Volatility should not be negative';
    _volatility = value;
  }

  num get volatility => _volatility;

  num notional;
  num _premium;
  set premium(num value) {
    if (_premium != null) throw 'Premium has already been set';
    _premium = value;
  }

  num get premium => _premium;
}

class EuropeanStockOptionBuilder extends Builder<EuropeanStockOption>
    with _OptionFields, Ticker, Strike, ExpirationDate {
  BuySell buySell;
  num notional;
  EuropeanStockOptionBuilder(BuySell buySell, OptionType typeCallPut,
      num strike, DateTime expirationDate,
      {String ticker, num premium, num notional: 1}) {
    if (strike < 0) throw 'The strike should be positive';
    this.strike = strike;
    this.expirationDate = expirationDate;
    this.typeCallPut = typeCallPut;
    this.buySell = buySell;
    this.ticker = ticker;
    this.premium = premium;
    this.notional = notional;
  }
  EuropeanStockOption build() {
    return new EuropeanStockOption._empty()
      ..buySell = buySell
      ..expirationDate = expirationDate
      ..strike = strike
      ..typeCallPut = typeCallPut
      ..premium = premium
      ..notional = notional
      ..ticker = ticker;
  }
}

class EuropeanStockOption extends SimpleSecurity
    with _OptionFields, Ticker, Strike, ExpirationDate {
  EuropeanStockOption._empty();
  /**
   * Constructor
   */
  factory EuropeanStockOption(EuropeanStockOptionBuilder builder) =>
      builder.build();

  double _timeToExpiration; // time to expiration in years -- simple rule for now
  num get timeToExpiration {
    if (_timeToExpiration == null) _timeToExpiration =
        expirationDate.difference(asOfDate).inDays / 365.25;
    if (_timeToExpiration < 0) _timeToExpiration = 0.0;
    return _timeToExpiration;
  }

  num get quantity => notional * delta();

  double _d1() {
    double d1;
    if (timeToExpiration == 0.0 || volatility == 0) d1 = double.INFINITY;
    else d1 = (log(underlyingPrice / strike) +
            (interestRate + 0.5 * volatility * volatility) * timeToExpiration) /
        (volatility * sqrt(timeToExpiration));
    return d1;
  }

  double _nd1() => Phi(_d1());

  double _d2() {
    double d2;
    if (timeToExpiration == 0 || volatility == 0) d2 = double.INFINITY;
    else d2 = (log(underlyingPrice / strike) +
                (interestRate + 0.5 * volatility * volatility) *
                    timeToExpiration) /
            (volatility * sqrt(timeToExpiration)) -
        volatility * sqrt(timeToExpiration);
    return d2;
  }

  double _nd2() => Phi(_d2());
  double _dNd1() => exp(-0.5 * _d1() * _d1()) / sqrt(2 * PI);

  void validate() {
    if (underlyingPrice == null) throw 'Underlying price has not been set';
    if (interestRate == null) throw 'Interest rate has not been set';
    if (asOfDate == null) throw 'Need to set the as of date';
    if (volatility == null) throw 'Volatility is not set';
  }

  /**
   * Calculate the MtM on this option
   */
  num get mtm => _sign() * notional * (value() - premium);

  /**
   * Price the option using the BS model.
   */
  double value() {
    double res;
    switch (typeCallPut) {
      case OptionType.call:
        if (timeToExpiration == 0) {
          res = max(underlyingPrice - strike, 0);
        } else {
          res = underlyingPrice * _nd1() -
              strike * _nd2() * exp(-interestRate * timeToExpiration);
        }
        break;
      case OptionType.put:
        if (timeToExpiration == 0) {
          res = max(strike - underlyingPrice, 0);
        } else {
          res = strike * (1 - _nd2()) * exp(-interestRate * timeToExpiration) -
              underlyingPrice * (1 - _nd1());
        }
        break;
    }

    return res;
  }

  /**
   * Calculate the delta of the option (sensitivity with respect to underlying
   * price.)
   */
  double delta() {
    double res;
    switch (typeCallPut) {
      case OptionType.call:
        res = _nd1();
        break;
      case OptionType.put:
        res = -Phi(-_nd1());
        break;
    }
    return _sign() * res;
  }

  /**
   * Calculate the gamma of the option (second derivative with respect to
   * the underlying price.)
   */
  double gamma() {
    double aux = volatility * underlyingPrice * sqrt(timeToExpiration);
    return _sign() * _dNd1() / aux;
  }

  /**
   * Calculate the theta of the option (sensitivity with respect to time.)
   */
  double theta() {
    double t1 =
        -volatility * underlyingPrice * _dNd1() / (2 * sqrt(timeToExpiration));
    double res;
    switch (typeCallPut) {
      case OptionType.call:
        res = t1 -
            interestRate *
                strike *
                exp(-interestRate * timeToExpiration) *
                _nd2();
        break;
      case OptionType.put:
        res = t1 -
            interestRate *
                strike *
                exp(-interestRate * timeToExpiration) *
                Phi(-_nd2());
        break;
    }
    return _sign() * res;
  }

  /**
   * Calculate the vega of the option (sensitivity with respect to volatility.)
   */
  double vega() =>
    _sign() * underlyingPrice * sqrt(timeToExpiration) * _dNd1();

  /**
   * Calculate the sensitivity of the option with respect to interest rate
   */
  double rho() {
    double res;
    switch (typeCallPut) {
      case OptionType.call:
        res = strike *
            timeToExpiration *
            exp(-interestRate * timeToExpiration) *
            _nd2();
        break;
      case OptionType.put:
        res = strike *
            timeToExpiration *
            exp(-interestRate * timeToExpiration) *
            Phi(-_nd2());
        break;
    }
    return _sign() * res;
  }


}
