library finance.security;

import 'dart:math';
import 'package:demos/math/special/erf.dart';
import 'package:date/date.dart';


enum OptionType { call, put }
enum BuySell { buy, sell }

/// A DbService is responsible for getting all the market data needed for
/// valuation.
Db db;


final Map<BuySell, int> _signMap = {BuySell.buy: 1, BuySell.sell: -1};
Function _sign = (BuySell buySell) => _signMap[buySell];
num _timeToExpiration(DateTime asOfDate, DateTime expirationDate) {
  return max(0, expirationDate.difference(asOfDate).inDays / 365.25);
}

abstract class Db {
  Db();

  /// get the value of this riskFactor as of a given time
  /// riskFactor can be something like 'VOLATILITY_GOOG', 'STOCKPRICE_GOOG'
  num getValue(DateTime asOfDate, String riskFactor);

}

class DataProvider {
}
abstract class PricingModel {
  DataProvider dataProvider;
  num value();
}

abstract class Security {
  String securityName;
  num value(DateTime asOfDate);
}

class Position {
  Security security;
  num quantity;

  Position(this.security, this.quantity);

  num value(DateTime asOfDate) {
    return quantity*security.value(asOfDate);
  }
}

class Transaction implements Position {
  Security security;
  num quantity;
  BuySell buySell;
  DateTime transactionTime;

  num value(DateTime asOfDate) {
    return quantity*security.value(asOfDate);
  }

}

class Stock implements Security {
  String ticker;
  String securityName;
  Stock(this.ticker): securityName=ticker {}
  num value(DateTime asOfDate) => db.getValue(asOfDate, 'STOCK PRICE_$ticker');
  num delta(DateTime asOfDate) => 1;
}

class StockOption {
  final OptionType optionType;
  final DateTime expirationDate;
  final num strike;
  PricingModel pricingModel;

  StockOption(this.optionType, this.strike, this.expirationDate){
    pricingModel = new BlackScholes(optionType, strike, expirationDate);
  }

  num value() => pricingModel.value();

}

class BlackScholes implements PricingModel {
  final OptionType optionType;
  final DateTime expirationDate;
  final num strike;
  DataProvider dataProvider;
  DateTime asOfDate;
  num interestRate;
  num underlyingPrice;
  num volatility;

  /// An European call option on a stock.
  /// TODO: Need to implement the put valuation, etc.
  BlackScholes(this.optionType, this.strike, this.expirationDate, this.dataProvider){}

//  set asOfDate(DateTime value) => _asOfDate = value;
//  set interestRate(num value) => _interestRate = value;
//  set underlyingPrice(num value) => _underlyingPrice = value;
//  set volatility(num value) => _volatility = value;


  /// Calculate the value of this option.  Values for the [underlyingPrice], [volatility],
  /// and [interestRate] can be set directly in the object.
  ///
  ///num value({DateTime asOfDate, num underlyingPrice, num volatility, num interestRate}) {
  num value() {
    asOfDate ??= _asOfDate;
    underlyingPrice ??= _underlyingPrice;
    volatility ??= _volatility;
    interestRate ??= _interestRate;

    num tExp = _timeToExpiration(asOfDate, expirationDate);
    num res;
    if (tExp == 0) {
      res = max(underlyingPrice - strike, 0);
    } else {
      res = underlyingPrice * _nd1(tExp, volatility, underlyingPrice, strike, interestRate) -
          strike * _nd2(tExp, volatility, underlyingPrice, strike, interestRate) * exp(-interestRate * tExp);
    }
    return res;
  }

   /// Calculate the delta of the option (sensitivity with respect to underlying
   /// price.)
  ///
  double delta({DateTime asOfDate, num underlyingPrice, num volatility, num interestRate}) {
    asOfDate ??= _asOfDate;
    underlyingPrice ??= _underlyingPrice;
    volatility ??= _volatility;
    interestRate ??= _interestRate;

    num tExp = _timeToExpiration(asOfDate, expirationDate);
    return _nd1(tExp, volatility, underlyingPrice, strike, interestRate);
  }
}

double _d1(num tExp, num volatility, num underlyingPrice, num strike, num interestRate) {
  double d1;
  if (tExp == 0.0 || volatility == 0) d1 = double.INFINITY;
  else d1 = (log(underlyingPrice / strike) +
      (interestRate + 0.5 * volatility * volatility) * tExp) /
      (volatility * sqrt(tExp));
  return d1;
}
double _nd1(num tExp, num volatility, num underlyingPrice, num strike, num interestRate) =>
    Phi(_d1(tExp, volatility, underlyingPrice, strike, interestRate));
double _d2(num tExp, num volatility, num underlyingPrice, num strike, num interestRate) {
  double d2;
  if (tExp == 0 || volatility == 0) d2 = double.INFINITY;
  else d2 = (log(underlyingPrice / strike) +
      (interestRate + 0.5 * volatility * volatility) *
          tExp) /
      (volatility * sqrt(tExp)) -
      volatility * sqrt(tExp);
  return d2;
}
double _nd2(num tExp, num volatility, num underlyingPrice, num strike, num interestRate) =>
    Phi(_d2(tExp, volatility, underlyingPrice, strike, interestRate));
double _dNd1(num tExp, num volatility, num underlyingPrice, num strike, num interestRate) {
  num d1 = _d1(tExp, volatility, underlyingPrice, strike, interestRate);
  return exp(-0.5 * d1 * d1) / sqrt(2 * PI);
}



//class _OptionFields {
//  OptionType typeCallPut;
//
//  // market data
//  DateTime asOfDate;
//  num underlyingPrice;
//  num interestRate;
//  num _volatility;
//  set volatility(num value) {
//    if (value < 0) throw 'Volatility should not be negative';
//    _volatility = value;
//  }
//
//  num get volatility => _volatility;
//
//  num notional;
//  num _premium;
//  set premium(num value) {
//    if (_premium != null) throw 'Premium has already been set';
//    _premium = value;
//  }
//
//  num get premium => _premium;
//}
//
//class EuropeanStockOptionBuilder extends Builder<EuropeanStockOption>
//    with _OptionFields, Ticker, Strike, ExpirationDate {
//  BuySell buySell;
//  num notional;
//  EuropeanStockOptionBuilder(BuySell buySell, OptionType typeCallPut,
//      num strike, DateTime expirationDate,
//      {String ticker, num premium, num notional: 1}) {
//    if (strike < 0) throw 'The strike should be positive';
//    this.strike = strike;
//    this.expirationDate = expirationDate;
//    this.typeCallPut = typeCallPut;
//    this.buySell = buySell;
//    this.ticker = ticker;
//    this.premium = premium;
//    this.notional = notional;
//  }
//  EuropeanStockOption build() {
//    return new EuropeanStockOption._empty()
//      ..buySell = buySell
//      ..expirationDate = expirationDate
//      ..strike = strike
//      ..typeCallPut = typeCallPut
//      ..premium = premium
//      ..notional = notional
//      ..ticker = ticker;
//  }
//}
//
//class EuropeanStockOption extends SimpleSecurity
//    with _OptionFields, Ticker, Strike, ExpirationDate {
//  EuropeanStockOption._empty();
//  /**
//   * Constructor
//   */
//  factory EuropeanStockOption(EuropeanStockOptionBuilder builder) =>
//      builder.build();
//
//  double _timeToExpiration; // time to expiration in years -- simple rule for now
//  num get timeToExpiration {
//    if (_timeToExpiration == null) _timeToExpiration =
//        expirationDate.difference(asOfDate).inDays / 365.25;
//    if (_timeToExpiration < 0) _timeToExpiration = 0.0;
//    return _timeToExpiration;
//  }
//
//  num get quantity => notional * delta();
//
//  double _d1() {
//    double d1;
//    if (timeToExpiration == 0.0 || volatility == 0) d1 = double.INFINITY;
//    else d1 = (log(underlyingPrice / strike) +
//            (interestRate + 0.5 * volatility * volatility) * timeToExpiration) /
//        (volatility * sqrt(timeToExpiration));
//    return d1;
//  }
//
//  double _nd1() => Phi(_d1());
//
//  double _d2() {
//    double d2;
//    if (timeToExpiration == 0 || volatility == 0) d2 = double.INFINITY;
//    else d2 = (log(underlyingPrice / strike) +
//                (interestRate + 0.5 * volatility * volatility) *
//                    timeToExpiration) /
//            (volatility * sqrt(timeToExpiration)) -
//        volatility * sqrt(timeToExpiration);
//    return d2;
//  }
//
//  double _nd2() => Phi(_d2());
//  double _dNd1() => exp(-0.5 * _d1() * _d1()) / sqrt(2 * PI);
//
//  void validate() {
//    if (underlyingPrice == null) throw 'Underlying price has not been set';
//    if (interestRate == null) throw 'Interest rate has not been set';
//    if (asOfDate == null) throw 'Need to set the as of date';
//    if (volatility == null) throw 'Volatility is not set';
//  }
//
//  /**
//   * Calculate the MtM on this option
//   */
//  num get mtm => _sign() * notional * (value() - premium);
//
//  /**
//   * Price the option using the BS model.
//   */
//  double value() {
//    double res;
//    switch (typeCallPut) {
//      case OptionType.call:
//        if (timeToExpiration == 0) {
//          res = max(underlyingPrice - strike, 0);
//        } else {
//          res = underlyingPrice * _nd1() -
//              strike * _nd2() * exp(-interestRate * timeToExpiration);
//        }
//        break;
//      case OptionType.put:
//        if (timeToExpiration == 0) {
//          res = max(strike - underlyingPrice, 0);
//        } else {
//          res = strike * (1 - _nd2()) * exp(-interestRate * timeToExpiration) -
//              underlyingPrice * (1 - _nd1());
//        }
//        break;
//    }
//
//    return res;
//  }
//
//  /**
//   * Calculate the delta of the option (sensitivity with respect to underlying
//   * price.)
//   */
//  double delta() {
//    double res;
//    switch (typeCallPut) {
//      case OptionType.call:
//        res = _nd1();
//        break;
//      case OptionType.put:
//        res = -Phi(-_nd1());
//        break;
//    }
//    return _sign() * res;
//  }
//
//  /**
//   * Calculate the gamma of the option (second derivative with respect to
//   * the underlying price.)
//   */
//  double gamma() {
//    double aux = volatility * underlyingPrice * sqrt(timeToExpiration);
//    return _sign() * _dNd1() / aux;
//  }
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
//
//
//}
