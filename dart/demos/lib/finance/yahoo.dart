library finance.yahoo;

import 'dart:io';
import 'dart:convert';
import 'dart:async';

import 'package:date/date.dart';
import 'package:timeseries/timeseries.dart';
import 'package:timezone/timezone.dart';

enum QuoteFrequency { hourly, daily, weekly, monthly }

final freqMap = <QuoteFrequency, String>{
  QuoteFrequency.hourly: '1h',
  QuoteFrequency.daily: '1d',
  QuoteFrequency.weekly: '1wk',
  QuoteFrequency.monthly: '1mo',
};

/// https://query2.finance.yahoo.com/v8/finance/chart/QQQ?period1=1735689600&period2=1760486400&interval=1d
String _yahooJsonUrl(
  String ticker,
  DateTime from,
  DateTime to,
  QuoteFrequency freq,
) {
  return 'https://query2.finance.yahoo.com/v8/finance/chart/$ticker?period1=${from.millisecondsSinceEpoch ~/ 1000}&period2=${to.millisecondsSinceEpoch ~/ 1000}&interval=${freqMap[freq]}&events=history';
}

class Olhc {
  Olhc(
    this.datetime,
    this.open,
    this.low,
    this.high,
    this.close,
    this.volume,
    this.adjustedClose,
  );

  final TZDateTime datetime;
  final num open;
  final num low;
  final num high;
  final num close;
  final num volume;
  final num adjustedClose;

  @override
  String toString() {
    return 'Olhc(datetime: $datetime, open: $open, low: $low, high: $high, close: $close, volume: $volume, adjustedClose: $adjustedClose)';
  }
}

Future<Map<String, TimeSeries<num>>> getStockPrices({
  required String ticker,
  required DateTime startDt,
  required DateTime endDt,
  QuoteFrequency freq = QuoteFrequency.daily,
}) async {
  String url = _yahooJsonUrl(ticker, startDt, endDt, freq);
  // print(url);
  HttpClientRequest request = await HttpClient().getUrl(Uri.parse(url));
  HttpClientResponse response = await request.close();
  String res = await response.transform(utf8.decoder).join();

  final keys = <String>[
    'date',
    'open',
    'high',
    'low',
    'close',
    'volume',
    'adjustedClose',
  ];
  final location = getLocation('America/New_York');

  final data = json.decode(res);
  if (data['chart']['error'] != null) {
    throw Exception('Yahoo Finance API returned error: '
        '${data['chart']['error']['description']}');
  }

  final timestamps = data['chart']['result'][0]['timestamp'] as List;
  final index = timestamps
      .map((ts) => TZDateTime.fromMillisecondsSinceEpoch(location, ts * 1000))
      .toList();
  final intervals = index.map((e) => Interval(e, e));
  final out = <String, TimeSeries<num>>{};
  for (var i = 1; i < keys.length - 1; i++) {
    out[keys[i]] = TimeSeries<num>.from(
      intervals,
      data['chart']['result'][0]['indicators']['quote'][0][keys[i]].cast<num>(),
    );
  }
  out['adjustedClose'] = TimeSeries<num>.from(
    intervals,
    data['chart']['result'][0]['indicators']['adjclose'][0]['adjclose']
        .cast<num>(),
  );

  return out;
}
