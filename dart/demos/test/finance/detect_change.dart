import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:date/date.dart';
import 'package:demos/finance/yahoo.dart';
import 'package:elec_server/utils.dart';
import 'package:timeseries/timeseries.dart';
import 'package:timezone/data/latest_all.dart';
import 'package:timezone/timezone.dart';

String getFilename(String ticker) {
  return '/home/adrian/Downloads/Archive/Finance/StockPrices/Raw/${ticker}.csv';
}

Future<void> archiveData({
  required String ticker,
  required Date start,
  required Date end,
}) async {
  var prices = await getStockPrices(
    ticker: ticker,
    startDt: start.toDateTime(),
    endDt: end.toDateTime(),
  );
  final keys = prices.keys.toList();
  var data = <List<dynamic>>[
    ['millisecondsSinceEpoch', ...keys],
  ];
  final N = prices.values.first.length;
  for (var i = 0; i < N; i++) {
    data.add([
      prices['open']![i].interval.start.millisecondsSinceEpoch,
      ...keys.map((k) => prices[k]![i].value),
    ]);
  }
  var csv = const ListToCsvConverter().convert(data);
  final filename = getFilename(ticker);
  File(filename).writeAsStringSync(csv);
  var res = Process.runSync('gzip', ['-f', filename]);
  if (res.exitCode != 0) {
    throw StateError('Could not gzip $filename: ${res.stderr}');
  } 
}

Future<TimeSeries<num>> getData(String ticker) async {
  final file = File('${getFilename(ticker)}.gz');
  final bytes = await file.readAsBytes();
  final decoded = GZipCodec().decode(bytes);

  final csv = utf8.decode(decoded);
  final rows = const CsvToListConverter().convert(csv);
  final headers = rows.first.map((h) => h.toString()).toList();
  final data = rows.skip(1).map((r) {
    var map = <String, num>{};
    for (var i = 0; i < headers.length; i++) {
      map[headers[i]] = r[i] as num;
    }
    return map;
  }).toList();
  final location = getLocation('America/New_York');

  return TimeSeries.fromIterable(
    data.map((e) {
      final dt = TZDateTime.fromMillisecondsSinceEpoch(
        location,
        e['millisecondsSinceEpoch'] as int,
      );
      final interval = Interval(dt, dt);
      return IntervalTuple<num>(interval, e['adjustedClose']!);
    }).toList(),
  );
}

void makeChart(TimeSeries<num> prices) {
  var traces = [
    {
      'x': prices.map((dt) => dt.interval.start.toIso8601String()).toList(),
      'y': prices.values.toList(),
      'type': 'scatter',
      'mode': 'lines+markers',
      'name': 'Adjusted Close Price',
    },
  ];
  var layout = {
    'title': {'text': 'SPY Adjusted Close Prices (Jan 2025)'},
    'xaxis': {
      'title': {'text': 'Date'},
    },
    'yaxis': {
      'title': {'text': 'Price (USD)'},
    },
  };
  Plotly.now(traces, layout, version: '3.1.0');
}

Future<void> main() async {
  initializeTimeZones();
  // await archiveData(
  //   ticker: 'SPY',
  //   start: Date.utc(2012, 1, 1),
  //   end: Date.utc(2025, 9, 18),
  // );
  final prices = await getData('SPY');
  print(prices);

  // makeChart(prices);
}
