library finance.portfolio_test;

import 'package:test/test.dart';
import 'package:tuple/tuple.dart';
import 'package:date/date.dart';
import 'package:demos/finance/portfolio.dart';
import 'package:demos/finance/trade.dart';
import 'package:demos/finance/position.dart';
import 'package:demos/finance/security.dart';
import 'package:demos/finance/securities_database.dart';


SecDb getDb1() {
  List hData = [
    {'day': new Date(2016,1,1), 'price': 30},
    {'day': new Date(2016,1,2), 'price': 40},
    {'day': new Date(2016,1,3), 'price': 50},
  ];
  return new InMemoryDb(hData);
}


class InMemoryDb implements SecDb {
  List<Map> hData;
  InMemoryDb(this.hData);
  num getValue(Security security, DateTime asOfDate) {
    Map e = hData.firstWhere((Map e) => e['day'] == new Date.fromTZDateTime(asOfDate));
    if (security.securityName == 'CASH')
      return 1;
    else if (security.securityName == 'STOCK')
      return e['price'];
    else
      throw 'Unknown security with name ${security.securityName}';
  }
  List<Tuple2<Security,num>> getDelta(Security security, DateTime asOfDate) {
    if (security.securityName == 'STOCK')
      return [new Tuple2(security, 1)];
    else if (security.securityName == 'CALL')
      return [new Tuple2((security as Call).underlier, 0.5)];
    else
      throw 'Unknown security with name ${security.securityName}';
  }
}

securityTests() {
  SecDb db = getDb1();
  group('Security tests:', () {
    test('Stock value', () {
      Stock stock = new Stock(db, 'STOCK');
      expect(stock.value(new DateTime(2016,1,1)), 30);
    });
  });
}


positionTests() {
  List hData = [
    {'day': new Date(2016,1,1), 'price': 30},
    {'day': new Date(2016,1,2), 'price': 40},
  ];
  var db = new InMemoryDb(hData);
  var stock = new Security(db, 'STOCK', 'STOCK');

  group('Positions test:', (){
    test('Add to an exiting long position', () {
      var p1 = new Position(stock, 100, 30);
      var p2 = new Position(stock, 100, 40);
      var p3 = p1.add(p2);
      expect(p3.averagePrice, 35);
      expect(p3.quantity, 200);
    });
    test('Sell from an existing position', () {
      var p1 = new Position(stock, 200, 30);
      var p2 = new Position(stock, -100, 40);
      var p3 = p1.add(p2);
      expect(p3.averagePrice, 30);
      expect(p3.quantity, 100);
    });
    test('Flatten an existing position', () {
      var p1 = new Position(stock, 100, 30);
      var p2 = new Position(stock, -100, 40);
      var p3 = p1.add(p2);
      expect(p3.averagePrice, 0);
      expect(p3.quantity, 0);
    });
    test('Add to a short position', () {
      var p1 = new Position(stock, -100, 30);
      var p2 = new Position(stock, -100, 40);
      var p3 = p1.add(p2);
      expect(p3.averagePrice, 35);
      expect(p3.quantity, -200);
    });
    test('Buy back part of a short position', () {
      var p1 = new Position(stock, -200, 30);
      var p2 = new Position(stock, 100, 40);
      var p3 = p1.add(p2);
      expect(p3.averagePrice, 30);
      expect(p3.quantity, -100);
    });

  });
}


portfolioTests() {
  List hData = [
    {'day': new Date(2016,1,1), 'price': 30},
    {'day': new Date(2016,1,2), 'price': 40},
    {'day': new Date(2016,1,3), 'price': 50},
    ];
  var db = new InMemoryDb(hData);
  var cash = new Security(db, 'CASH', 'CASH');
  var stock = new Security(db, 'STOCK', 'STOCK');
  var call = new Call(db, 'CALL', stock);

  group('Portfolio tests:', () {
    test('Add some cash on 1/1/2016', () {
      var portfolio = new Portfolio();
      var trade1 = new Trade(new DateTime(2016,1,1), BuySell.buy, 10000, cash, 1);
      portfolio.add(trade1);
      expect(portfolio.currentPositions().length, 1);
    });

    test('Fund and buy 100 shares on 1/1/2016', () {
      var portfolio = new Portfolio();
      var trade1 = new Trade(new DateTime(2016,1,1), BuySell.buy, 10000, cash, 1);
      portfolio.add(trade1);
      var trade2 = new Trade(new DateTime(2016,1,1), BuySell.buy, 100, stock, 30);
      portfolio.add(trade2);
      var positions = portfolio.currentPositions();
      //positions.forEach((p) => print(p.toMap()));
      expect(positions.length, 2);
      expect(positions.first.quantity, 7000);  /// after adjusting for the purchase
    });

    test('Buy another 100 shares on 1/2/2016', () {
      var portfolio = new Portfolio();
      var trade1 = new Trade(new DateTime(2016,1,1), BuySell.buy, 10000, cash, 1);
      portfolio.add(trade1);
      var trade2 = new Trade(new DateTime(2016,1,1), BuySell.buy, 100, stock, 30);
      portfolio.add(trade2);
      var trade3 = new Trade(new DateTime(2016,1,2), BuySell.buy, 100, stock, 40);
      portfolio.add(trade3);
      var positions = portfolio.currentPositions();
      //positions.forEach((p) => print(p.toMap()));
      expect(positions.length, 2);
      expect(positions.first.quantity, 3000);  /// after adjusting for the purchase
      expect(positions[1].averagePrice, 35);   /// the average purchase price
    });

    test('Sell 100 shares on 1/3/2016', () {
      var portfolio = new Portfolio();
      var trade1 = new Trade(new DateTime(2016,1,1), BuySell.buy, 10000, cash, 1);
      portfolio.add(trade1);
      var trade2 = new Trade(new DateTime(2016,1,1), BuySell.buy, 100, stock, 30);
      portfolio.add(trade2);
      var trade3 = new Trade(new DateTime(2016,1,2), BuySell.buy, 100, stock, 40);
      portfolio.add(trade3);
      var trade4 = new Trade(new DateTime(2016,1,3), BuySell.sell, 100, stock, 50);
      portfolio.add(trade4);
      var positions = portfolio.currentPositions();
      //positions.forEach((p) => print(p.toMap()));
      expect(positions.length, 2);
      expect(positions.first.quantity, 8000);  /// after adjusting for the sale
      expect(positions[1].quantity, 100);      /// 100 shares left
      expect(positions[1].averagePrice, 35);   /// the average price stays the same
      expect(portfolio.value(new DateTime(2016,1,3)), 13000);
    });

    test('Zero quantity positions are removed from the list', () {
      var portfolio = new Portfolio();
      var trade1 = new Trade(new DateTime(2016,1,1), BuySell.buy, 10000, cash, 1);
      portfolio.add(trade1);
      var trade2 = new Trade(new DateTime(2016,1,1), BuySell.buy, 100, stock, 30);
      portfolio.add(trade2);
      var trade3 = new Trade(new DateTime(2016,1,2), BuySell.sell, 100, stock, 40);
      portfolio.add(trade3);
      var positions = portfolio.currentPositions();
      expect(positions.length, 1);
      expect(positions.first.quantity, 11000);  /// after adjusting for the sale
    });

    test('A trade on a security with quantity multiplier', () {
      var portfolio = new Portfolio();
      var trade1 = new Trade(new DateTime(2016,1,1), BuySell.buy, 10000, cash, 1);
      portfolio.add(trade1);
      var trade2 = new Trade(new DateTime(2016,1,1), BuySell.buy, 10, call, 1.50);
      portfolio.add(trade2);
      var positions = portfolio.currentPositions();
      expect(positions.length, 2);
      expect(positions.first.quantity, 8500);
    });

    test('Delta aggregation on a stock + call position', () {
      var portfolio = new Portfolio();
      var trade1 = new Trade(new DateTime(2016,1,1), BuySell.buy, 10000, cash, 1);
      portfolio.add(trade1);
      var trade2 = new Trade(new DateTime(2016,1,1), BuySell.buy, 10, call, 1.50);
      portfolio.add(trade2);
      var trade3 = new Trade(new DateTime(2016,1,1), BuySell.buy, 100, stock, 30);
      portfolio.add(trade3);

      var positions = portfolio.currentPositions();
      expect(positions.length, 3);
      var deltas = portfolio.delta(new DateTime(2016,1,1));
      expect(deltas.length, 1);
      expect(deltas.first.item2, 600);
    });


  });


}


main() {
  securityTests();
  positionTests();
  portfolioTests();
}