import 'package:demos/finance/yahoo.dart';
import 'package:timezone/data/latest_all.dart';

Future<void> main() async {
  initializeTimeZones();
  var prices = await getStockPrices(
    ticker: 'QQQ',
    startDt: DateTime(2025, 1, 1),
    endDt: DateTime(2025, 2, 1),
  );
  print(prices);
}
