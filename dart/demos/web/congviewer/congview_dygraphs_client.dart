library congview_client;

import 'dart:html' as html;
import 'package:chartjs/chartjs.dart';
import 'package:dygraphs_dart/dygraphs_dart.dart';
import 'package:timezone/browser.dart';

import 'dart:math' as math;
import 'package:demos/db/influxdb.dart';
import 'package:demos/elec/nepool_da_lmp_influx.dart';


/// get the data from influx
List<List> getData(InfluxDb db, List<int> ptids, TZDateTime start, TZDateTime end) async {
  var res = await getHourlyLmpByPtid(db, 4000, component: ['lmp'],
      start: new TZDateTime(location, 2015, 2),
      end: new TZDateTime(location, 2015, 2, 2));
  return res;
}

main() async {

  await initializeTimeZone();

  InfluxDb db = new InfluxDb('localhost', 8086, 'root', 'root');

  Location location = getLocation('US/Eastern');
  List<int> ptids = new List.generate(8, (i) => 4000 + i);
  TZDateTime start = new TZDateTime(location, 2015,1,1);
  TZDateTime end = new TZDateTime(location, 2015,4,1);

  getData()

  new Dygraph(html.querySelector('#canvas'), data, opt);


}
