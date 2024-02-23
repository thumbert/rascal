// library finance.position;

// import 'package:tuple/tuple.dart';

// import 'security.dart';


// class Position {
//   Security security;
//   num quantity;
//   /// the volume weighted average price
//   num averagePrice;

//   /// Represent a position in a security.  The quantity can be positive or
//   /// negative.
//   Position(this.security, this.quantity, this.averagePrice) {}

//   /// An empty position (can be generated after liquidating an existing position)
//   Position.empty(Security security): this(security, 0, 0);

//   /// Create another position by combining two positions in the same security.
//   Position add(Position other) {
//     if (security.securityName != other.security.securityName)
//       throw 'Only positions in the same security are addititve';
//     if (other.quantity == 0)
//       return this;
//     num totalQuantity = quantity + other.quantity;
//     num avgPrice;
//     if (totalQuantity == 0)
//       return new Position.empty(security);
//     else {
//       if (quantity * other.quantity > 0) {
//         /// add in the same direction
//         avgPrice = (quantity*averagePrice + other.quantity*other.averagePrice)/totalQuantity;
//       } else {
//         /// sell from an existing position, or buy back from a short position
//         /// price remains the same
//         avgPrice = averagePrice;
//       }
//       return new Position(security, totalQuantity, avgPrice);
//     }
//   }

//   /// the market (liquidation) value of this position
//   num value(DateTime asOfDate) {
//     return quantity * security.quantityMultiplier * security.value(asOfDate);
//   }

//   /// return the delta of this position
//   List<Tuple2<Security,num>> delta(DateTime asOfDate) {
//     return security.delta(asOfDate).map((Tuple2 e) =>
//       new Tuple2(e.item1, quantity*security.quantityMultiplier*e.item2)).toList();
//   }

//   /// the unrealized P&L on this position
//   num pnl(DateTime asOfDate) {
//     return value(asOfDate) - quantity*security.quantityMultiplier*averagePrice;
//   }

//   Map toMap() {
//     return {
//       'security': security.securityName,
//       'quantity': quantity,
//       'averagePrice': averagePrice
//     };
//   }
// }

