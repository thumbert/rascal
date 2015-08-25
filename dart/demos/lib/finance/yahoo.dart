library finance.yahoo;

import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'package:csv/csv.dart';

Future<List<Map>> download_yahoo(String ticker, DateTime startDt,
               DateTime endDt) async {

  // http://real-chart.finance.yahoo.com/table.csv?s=AAPL&d=7&e=25&f=2015&g=d&a=11&b=12&c=1980&ignore=.csv

  String url = 'http://real-chart.finance.yahoo.com/table.csv?s=AAPL&d=7&e=25&f=2015&g=d&a=11&b=12&c=1980&ignore=.csv';
  HttpClientRequest request = await new HttpClient().getUrl(Uri.parse(url));
  HttpClientResponse response = await request.close();
  String res = await response.transform(UTF8.decoder).join();

  List<Map> rows = [];
  List keys = ['date', 'open', 'high', 'low', 'close', 'volume', 'adjustedClose'];
  List<List> aux = new CsvToListConverter(eol: '\n').convert(res);
  aux.skip(1).forEach((List row) => rows.add(new Map.fromIterables(keys, row)));
}