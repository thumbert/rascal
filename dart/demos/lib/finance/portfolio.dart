library finance.portfolio;

import 'package:tuple/tuple.dart';
import 'trade.dart';
import 'position.dart';
import 'security.dart';

/// A portfolio is a collection of positions (cash, stocks, options, etc.)
/// that originate from trades (transactions).
/// You keep track of individual trades, and you can look at the positions
/// which give you the average price for that particular security.
///
/// You can add a transaction (trades) to a portfolio.
class Portfolio {
  String name;

  /// an internal clock that keeps increasing every time you add a trade,
  /// to prevent adding trades in the past.
  DateTime _internalClock;

  /// keep a history of the positions in this portfolio
  Map<DateTime, List<Position>> positions = {};

  /// keep a history of the trades in this portfolio since inception
  Map<DateTime, List<Trade>> trades = {};

  /// Create a portfolio.  A portfolio has a list of trades and positions.
  /// Always fund the portfolio with some cash.
  Portfolio({this.name});

  /// add a given trade to the portfolio
  void add(Trade trade) {
    _internalClock ??= trade.transactionTime;
    if (trade.transactionTime.isBefore(_internalClock))
      throw ('You cannot add trades in the past');

    DateTime currentTime = trade.transactionTime;

    /// update the trades database
    trades.putIfAbsent(currentTime, () => []);
    trades[currentTime].add(trade);

//    if (trade.transactionTime == new DateTime(2016, 1, 3))
//      //print('here');

    /// update the positions list
    /// copy the positions forward

    if (currentPositions().isEmpty) {
      positions.putIfAbsent(currentTime, () => []);
    } else {
      positions.putIfAbsent(currentTime, () => currentPositions());
    }
    int ind = positions[currentTime]
        .map((position) => position.security.securityName)
        .toList()
        .indexOf(trade.security.securityName);
    Position position = new Position(trade.security,
        signQuantity(trade.buySell) * trade.quantity, trade.price);
    if (ind == -1) {
      positions[currentTime].add(position);
    } else {
      /// check first if the security already exists in the portfolio
      var newPosition = positions[currentTime][ind].add(position);
      if (newPosition.quantity !=0)
        positions[currentTime][ind] = newPosition;
      else {
        /// remove an empty position
        positions[currentTime].removeAt(ind);
      }
    }

    /// if the trade is not a payment trade (cash) need to adjust the cash line
    if (trade.security.securityName != 'CASH') {
      Position cash = positions[currentTime].first;
      var amount = trade.cashLeg;
      Position newCash = cash.add(new Position(cash.security, amount, 1));
      positions[currentTime][0] = newCash;
    }

    /// reset the _internalClock
    _internalClock = trade.transactionTime;
  }

  /// return the current positions in the portfolio according to the
  /// internal clock.
  List<Position> currentPositions() {
    var keys = positions.keys.toList()..sort();
    if (keys.isEmpty) return [];
    DateTime maxTime = keys.last;
    return positions[maxTime];
  }

  /// Get the positions as of a given time.
  /// If the asOfDate is after last trade added, positions = currentPositions,
  /// otherwise, it is searching for the last available timestamp.
  List<Position> getPositions(DateTime asOfDate) {
    if (positions.isEmpty) return [];
    var tStamps = positions.keys.toList().reversed;
    DateTime pick = tStamps.firstWhere((dt) => dt.isBefore(asOfDate) || dt.isAtSameMomentAs(asOfDate));
    return positions[pick];
  }

  /// Calculate the value of this portfolio as of a given time
  num value(DateTime asOfDate) {
    List _positions = getPositions(asOfDate);
    if (_positions.isEmpty) return 0;
    /// get the last positions right before or at the asOfDate
    return _positions
        .map((position) => position.value(asOfDate))
        .reduce((a, b) => a + b);
  }

  /// Calculate the deltas for this portfolio
  List<Tuple2<String,num>> delta(DateTime asOfDate) {
    List _positions = getPositions(asOfDate);
    if (_positions.isEmpty) return [];
    var aux = _positions
        .skip(1)   /// always have some cash in the first spot
        .expand((position) => position.delta(asOfDate));
    Map<Security, List<Tuple2>> gAux = new Map();
    aux.forEach((Tuple2 v) => gAux.putIfAbsent(v.item1, () => []).add(v));

    List res = [];
    gAux.keys.forEach((Security s) {
      num delta = gAux[s].map((e) => e.item2).reduce((a,b)=>a+b);
      res.add(new Tuple2(s,delta));
    });

    return res;
  }

}
