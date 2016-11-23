library elec.temperature;

import 'dart:math' show max, min;
import 'package:date/date.dart';

Function _indexHdd = (num t) => max(65-t,0);
Function _indexCdd = (num t) => max(t-65,0);

enum IndexType {
  CDD,
  HDD
}
enum BuySell {
  Buy,
  Sell
}


class TemperatureLocation {
  String airportCode;
  List<num> getTemperature(Date startDate, Date endDate){}
}


class TemperatureSwap {
  num fixedLeg;
  num tick;
  num maxPayoff;
  IndexType indexType;
  Month month;
  BuySell buySell;

  Function _indexFun;
  List<num> temperatureObservations;

  /// Price a monthly temperature swap.
  /// [month] is the month for this swap
  /// [tick] is the quantity multiplier
  /// [indexType] CDD or HDD
  /// [maxPayoff] the maximum payoff for this swap
  ///
  TemperatureSwap(this.month, this.fixedLeg, this.tick, this.indexType, this.buySell,
      {this.maxPayoff: double.INFINITY}) {
    switch (indexType) {
      case IndexType.CDD:
        _indexFun = _indexCdd;
        break;
      case IndexType.HDD:
        _indexFun = _indexHdd;
        break;
    }

  }

  num value() {
    num floatingLeg = temperatureObservations.map((t) => _indexFun(t)).reduce((a,b)=>a+b);
    num res = max(tick * (floatingLeg - fixedLeg), maxPayoff);
    if (buySell == BuySell.Sell) res = -res;
    return res;
  }


}