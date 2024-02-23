library finance.yahoo;

import 'dart:io';
import 'dart:convert';
import 'dart:async';

enum QuoteFrequency { daily, weekly, monthly }

Future<List<Map>> downloadStockPrices(
    String ticker, DateTime startDt, DateTime endDt,
    {QuoteFrequency freq= QuoteFrequency.daily}) async {

  // http://real-chart.finance.yahoo.com/table.csv?s=AAPL&d=7&e=25&f=2015&g=d&a=11&b=12&c=1980&ignore=.csv
  Map freqMap = {
    QuoteFrequency.daily: 'd',
    QuoteFrequency.weekly: 'w',
    QuoteFrequency.monthly: 'm'
  };

  String url = 'http://real-chart.finance.yahoo.com/table.csv?s=$ticker' +
  '&a=${startDt.month-1}&b=${startDt.day}&c=${startDt.year}' +
  '&d=${endDt.month-1}&e=${endDt.day}&f=${endDt.year}' +
  '&g=${freqMap[freq]}&ignore=.csv';
  HttpClientRequest request = await new HttpClient().getUrl(Uri.parse(url));
  HttpClientResponse response = await request.close();
  String res = await response.transform(utf8.decoder).join();

  List keys = [
    'date',
    'open',
    'high',
    'low',
    'close',
    'volume',
    'adjustedClose'
  ];

  return res.split('\n').skip(1).where((row) => row.length > 10).map((row) {
    List elem = row.split(',');
    elem[0] = DateTime.parse(elem[0]);
    [1, 2, 3, 4, 5, 6].map((i) => elem[i] = num.parse(elem[i]));
    return new Map.fromIterables(keys, elem);
  }).toList();
}





