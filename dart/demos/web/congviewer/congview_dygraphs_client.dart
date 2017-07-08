library congview_client;

//import 'dart:html' as html;
import 'dart:async';
//import 'package:chartjs/chartjs.dart';
//import 'package:dygraphs_dart/dygraphs_dart.dart';
//import 'package:timezone/browser.dart';
import 'dart:io';
import 'dart:convert';
import 'package:timezone/standalone.dart';



import 'dart:math' as math;
import 'package:demos/db/influxdb.dart';
import 'package:demos/elec/nepool_da_lmp_influx.dart';


/// get the data from influx
Future<List> getData(InfluxDb db, List<int> ptids, TZDateTime start, TZDateTime end) async {
  var res = await getHourlyLmpByPtid(db, 4000, component: ['lmp'],
      start: new TZDateTime(location, 2015, 1, 1),
      end: new TZDateTime(location, 2015, 1, 2));

  var aux = _formatResponse(new InfluxDbResponse(res, location));
  aux.forEach((print));
  return aux;
}

List _formatResponse(InfluxDbResponse res) {
  return res.toIterable().map((e) => [e['time'], e['lmp']]).toList();
}


main() async {
  Map env = Platform.environment;
  String tzdb = env['HOME'] + '/.pub-cache/hosted/pub.dartlang.org/timezone-0.4.3/lib/data/2015b.tzf';
  initializeTimeZoneSync(tzdb);



  InfluxDb db = new InfluxDb('localhost', 8086, 'root', 'root');

  Location location = getLocation('US/Eastern');
  List<int> ptids = new List.generate(8, (i) => 4000 + i);
  TZDateTime start = new TZDateTime(location, 2015,1,1);
  TZDateTime end = new TZDateTime(location, 2015,1,2);

  getData(db, [ptids], start, end);

  //new Dygraph(html.querySelector('#canvas'), data, opt);

}
