// library finance.security;

// import 'package:tuple/tuple.dart';
// import 'securities_database.dart';

// enum CallPut { call, put }
// enum BuySell { buy, sell }

// Function signQuantity = (BuySell buySell) => buySell == BuySell.buy ? 1 : -1;

// class Security {
//   SecDb db;
//   String securityName;
//   String securityType;
//   num quantityMultiplier;

//   Security(this.db, this.securityName, this.securityType,
//       {int this.quantityMultiplier: 1});
//   num value(DateTime asOfDate) => db.getValue(this, asOfDate);
//   List<Tuple2<Security,num>> delta(DateTime asOfDate) => db.getDelta(this, asOfDate);
// }

// class Stock implements Security {
//   String ticker;
//   String securityName;
//   String securityType = 'STOCK';
//   SecDb db;
//   num quantityMultiplier = 1;

//   Stock(this.db, this.ticker) : securityName = ticker {}
//   num value(DateTime asOfDate) => db.getValue(this, asOfDate);
//   List<Tuple2<Security,num>> delta(DateTime asOfDate) => db.getDelta(this,asOfDate);
// }

// class Call implements Security {
//   String securityName;
//   String securityType = 'CALL';
//   SecDb db;
//   CallPut callPut = CallPut.call;
//   num quantityMultiplier = 100;
//   Security underlier;

//   /// A simple european call
//   Call(this.db, this.securityName, this.underlier);
//   num value(DateTime asOfDate) => db.getValue(this,asOfDate);
//   List<Tuple2<Security,num>> delta(DateTime asOfDate) => db.getDelta(this, asOfDate);
// }

// class Put implements Security {
//   String securityName;
//   String securityType = 'PUT';
//   SecDb db;
//   CallPut callPut = CallPut.put;
//   num quantityMultiplier = 100;
//   Security underlier;

//   /// A simple european put
//   Put(this.db, this.securityName, this.underlier);
//   num value(DateTime asOfDate) => db.getValue(this,asOfDate);
//   List<Tuple2<Security,num>> delta(DateTime asOfDate) => db.getDelta(this, asOfDate);
// }



// //class EuropeanStockOptionBuilder extends Builder<EuropeanStockOption>
// //    with _OptionFields, Ticker, Strike, ExpirationDate {
// //  BuySell buySell;
// //  num notional;
// //  EuropeanStockOptionBuilder(BuySell buySell, OptionType typeCallPut,
// //      num strike, DateTime expirationDate,
// //      {String ticker, num premium, num notional: 1}) {
// //    if (strike < 0) throw 'The strike should be positive';
// //    this.strike = strike;
// //    this.expirationDate = expirationDate;
// //    this.typeCallPut = typeCallPut;
// //    this.buySell = buySell;
// //    this.ticker = ticker;
// //    this.premium = premium;
// //    this.notional = notional;
// //  }
// //  EuropeanStockOption build() {
// //    return new EuropeanStockOption._empty()
// //      ..buySell = buySell
// //      ..expirationDate = expirationDate
// //      ..strike = strike
// //      ..typeCallPut = typeCallPut
// //      ..premium = premium
// //      ..notional = notional
// //      ..ticker = ticker;
// //  }
// //}
// //
// //class EuropeanStockOption extends SimpleSecurity
// //    with _OptionFields, Ticker, Strike, ExpirationDate {
// //  EuropeanStockOption._empty();
// //  /**
// //   * Constructor
// //   */
// //  factory EuropeanStockOption(EuropeanStockOptionBuilder builder) =>
// //      builder.build();
// //
// //  double _timeToExpiration; // time to expiration in years -- simple rule for now
// //  num get timeToExpiration {
// //    if (_timeToExpiration == null) _timeToExpiration =
// //        expirationDate.difference(asOfDate).inDays / 365.25;
// //    if (_timeToExpiration < 0) _timeToExpiration = 0.0;
// //    return _timeToExpiration;
// //  }
// //
// //  num get quantity => notional * delta();
// //
// //  double _d1() {
// //    double d1;
// //    if (timeToExpiration == 0.0 || volatility == 0) d1 = double.INFINITY;
// //    else d1 = (log(underlyingPrice / strike) +
// //            (interestRate + 0.5 * volatility * volatility) * timeToExpiration) /
// //        (volatility * sqrt(timeToExpiration));
// //    return d1;
// //  }
// //
// //  double _nd1() => Phi(_d1());
// //
// //  double _d2() {
// //    double d2;
// //    if (timeToExpiration == 0 || volatility == 0) d2 = double.INFINITY;
// //    else d2 = (log(underlyingPrice / strike) +
// //                (interestRate + 0.5 * volatility * volatility) *
// //                    timeToExpiration) /
// //            (volatility * sqrt(timeToExpiration)) -
// //        volatility * sqrt(timeToExpiration);
// //    return d2;
// //  }
// //
// //  double _nd2() => Phi(_d2());
// //  double _dNd1() => exp(-0.5 * _d1() * _d1()) / sqrt(2 * PI);
// //
// //  void validate() {
// //    if (underlyingPrice == null) throw 'Underlying price has not been set';
// //    if (interestRate == null) throw 'Interest rate has not been set';
// //    if (asOfDate == null) throw 'Need to set the as of date';
// //    if (volatility == null) throw 'Volatility is not set';
// //  }
// //
// //  /**
// //   * Calculate the MtM on this option
// //   */
// //  num get mtm => _sign() * notional * (value() - premium);
// //