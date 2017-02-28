library finance.trading_algorithm;

import 'security.dart';

/// Represent a trading algorithm.  The algorithm needs to come up with a
/// trading decision and then execute a transaction based on it.
class TradingAlgorithm {
  //final List<Decision> allowedDecisions;
  //TradingAlgorithm(this.allowedDecisions);
}


abstract class Decision {
  String name;
  int priority;
  BuySell buySell;
  int quantity;
  Security security;
}