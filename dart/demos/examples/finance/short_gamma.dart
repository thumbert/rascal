/// Investigate hedging PnL of a short gamma position
///
///
///

import 'package:tuple/tuple.dart';
import 'package:date/date.dart';
import 'package:dama/stochastic/gbm.dart';
import 'package:table/table.dart';
import 'package:demos/finance/security.dart';
import 'package:demos/finance/black_scholes.dart';
import 'package:demos/finance/securities_database.dart';
import 'package:demos/finance/trading_algorithm.dart';
import 'package:demos/finance/portfolio.dart';
import 'package:demos/finance/trade.dart';


/// Generate some fake historical data for the underlying,
/// the call and the put option.
/// The underlying is simulated as a GBM.  The call, put prices and deltas
/// are calculated with the BlackScholes model.
/// The [seed] is for the underlying price GBM
List<Map> mockHistoricalData(int seed) {
  Date start = new Date(2016, 1, 1);
  Date expirationDate = new Date(2016, 12, 18);
  Date end = expirationDate;
  num strike = 30;

  var call = new BlackScholes(CallPut.call, strike, expirationDate.toDateTime())
    ..volatility = 0.3  // annualized volatility
    ..interestRate = 0.01;
  var put = new BlackScholes(CallPut.put, strike, expirationDate.toDateTime())
    ..volatility = 0.3
    ..interestRate = 0.01;

  var days = new TimeIterable(start, end).toList();

  /// generate the underlying price (remember, daily volatility)
  var gbm = new GeometricBrownianMotion(30, 0, 0.02, seed);
  var res = days.map((day) {
    return {'day': day, 'underlyingPrice': _round2(gbm.next())};
  });

  /// calculate the price of the options, given the underlying price
  res = res.map((Map obs) {
    var asOfDate = (obs['day'] as Date).toDateTime();
    call.asOfDate = asOfDate;
    call.underlyingPrice = obs['underlyingPrice'];
    obs['callPrice'] = _round2(call.value());
    obs['callDelta'] = call.delta();

    put.asOfDate = asOfDate;
    put.underlyingPrice = obs['underlyingPrice'];
    obs['putPrice'] = _round2(put.value());
    obs['putDelta'] = put.delta();
    return obs;
  });

  return res.toList();
}

/// Select between different market scenarios.
/// See the global variable [scenarios] for choices.
List<Map> generateScenarios(int scenarioId) {
  Map<int,int> scenarioToSeed = {
    1 : 1,
    2 : 2,
    3 : 8
  };
  int seed = scenarioToSeed[scenarioId];
  return mockHistoricalData(seed);
}

List<Map> scenarios = [
  {'scenarioId': 1, 'description': 'Call expires in the money'},
  {'scenarioId': 2, 'description': 'Put expires in the money'},
  {'scenarioId': 3, 'description': 'Call and Put expire close to the money'},
];

class InMemoryDb implements SecDb {
  List<Map> hData;
  InMemoryDb(this.hData);
  num getValue(Security security, DateTime asOfDate) {
    Map e = hData.firstWhere((Map e) => e['day'] == Date.fromTZDateTime(asOfDate));
    if (security.securityName == 'CASH')
      return 1;
    else if (security.securityName == 'STOCK')
      return e['underlyingPrice'];
    else if (security.securityName == 'CALL')
      return e['callPrice'];
    else if (security.securityName == 'PUT')
      return e['putPrice'];
    else
      throw 'Unknown security with name ${security.securityName}';
  }
  List<Tuple2<Security,num>> getDelta(security, asOfDate) {
    Map e = hData.firstWhere((Map e) => e['day'] == new Date.fromTZDateTime(asOfDate));
    if (security.securityName == 'STOCK' || security.securityName == 'CASH')
      return [new Tuple2(security,1)];
    else if (security.securityName == 'CALL') {
      return [new Tuple2((security as Call).underlier, e['callDelta'])];
    }
    else if (security.securityName == 'PUT')
      return [new Tuple2((security as Put).underlier, e['putDelta'])];
    else
      throw 'Unknown security with name ${security.securityName}';
  }

}

/// Return the 4 securities: cash, stock shares, the calls, and the puts.
List<Security> getSecurities(SecDb db) {
  Stock stock = new Stock(db, 'STOCK');
  return [
    new Security(db, 'CASH', 'CASH'),
    stock,
    new Call(db, 'CALL', stock),
    new Put(db, 'PUT', stock)
  ];
}

class ShortGamma {
  SecDb db;
  Portfolio portfolio;
  List securities;
  Stock stock;

  /// manage a short gamma portfolio by constantly delta-hedging
  ShortGamma(this.db) {
    securities = getSecurities(db);
    stock = securities[1];
    DateTime start = new DateTime(2016, 1, 1);

    /// fund the portfolio at initial time with some cash
    portfolio = new Portfolio();
    Trade cash = new Trade(start, BuySell.buy, 10000, securities[0], 1);
    portfolio.add(cash);

    /// sell 10 calls
    num callPrice = db.getValue(securities[2], start);
    Trade trade1 = new Trade(start, BuySell.sell, 10, securities[2], callPrice);
    portfolio.add(trade1);

    /// sell 10 puts
    num putPrice = db.getValue(securities[3], start);
    Trade trade2 = new Trade(start, BuySell.sell, 10, securities[3], putPrice);
    portfolio.add(trade2);
  }

  /// run this algorithm from start to end
  void run(Date start, Date end) {
    List<Date> days = new TimeIterable(start, end).toList();
    days.forEach((Date day) {
      DateTime dt = day.toDateTime();
      num delta = portfolio.delta(dt).first.item2;
      print('day: $day, delta: $delta');
      if (delta.abs() > 10) {
        /// flatten the portfolio
        BuySell buySell = delta > 0 ? BuySell.sell : BuySell.buy;
        Trade trade = new Trade(dt, buySell, delta.round().abs(), stock, stock.value(dt));
        portfolio.add(trade);
        //print('trade: ${trade.buySell}, quantity: ${trade.quantity}');
      }
      print('   end of day portfolio value: ${portfolio.value(dt)}');
    });
  }
}

num _round2(num x) => (x*100).round()/100;


main() {

  var hData = generateScenarios(1);
  var table = new Table.from(hData);
  print(table.head());

  SecDb db = new InMemoryDb(hData);

  var algo = new ShortGamma(db);
  var positions = algo.portfolio.currentPositions();
  positions.forEach((p) => print(p.toMap()));
  print(algo.portfolio.delta(new DateTime(2016,1,1)));

  Date start = new Date(2016,1,2);
  Date end = new Date(2016,12,18);
  algo.run(start, end);
  // TODO: portfolio value is wrong



}

