library finance.transaction;

import 'package:demos/finance/security.dart';

abstract class Transaction {
  DateTime tradeDate;
  String traderName;
  String bookName;
  num commission;
  BuySell type;

  num value();

  int _sign() {
    int res;
    switch (type) {
      case BuySell.buy:
        res = 1;
        break;
      case BuySell.sell:
        res = -1;
        break;
    }
    return res;
  }
}


abstract class SimpleTransaction extends Transaction {
  num quantity;
  num fixedPrice;
  //Security security;
}


class EuropeanStockOptionTrade extends SimpleTransaction {
  EuropeanStockOption security;

  EuropeanStockOptionTrade(EuropeanStockOption this.security);

  num value() => _sign() * quantity * security.value();

}









