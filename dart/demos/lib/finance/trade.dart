// library finance.trade;

// import 'security.dart';

// class Trade {
//   String tradeId;
//   DateTime transactionTime;
// //  String traderName;
// //  String bookName;
//   num commission;
//   BuySell buySell;
//   Security security;
//   /// transaction price
//   num price;
//   /// the quantity transacted
//   int quantity;

//   /// Represent a transaction, e.g.
//   /// BUY 100 shares, GOOG at $601.25
//   /// Of course, things could get more complicated, you can have more legs on the
//   /// trade.
//   Trade(this.transactionTime, this.buySell, this.quantity, this.security,
//       this.price);

//   /// the market value of this transaction at a given [asOfDate]
//   num value(DateTime asOfDate) {
//     if (asOfDate.isBefore(transactionTime))
//       throw 'Cannot value the trade before transactionTime';
//     return _sign()*quantity*security.quantityMultiplier*(security.value(asOfDate) - price);
//   }

//   /// the amount of cash spent to enter into this trade
//   /// negative if you buy something, positive if you sell something.
//   num get cashLeg =>  -_sign()*quantity*security.quantityMultiplier*price;

//   int _sign() => (buySell == BuySell.buy) ? 1 : -1;

//   Map toMap() {
//     Map res = {};
//     res['transactionTime'] = transactionTime;
//     res['buySell'] = buySell == BuySell.buy ? 'BUY' : 'SELL';
//     res['quantity'] = quantity;
//     res['security'] = security.securityName;
//     res['price'] = price;
//     return res;
//   }
// }
