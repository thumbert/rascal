library test.db.demo_influxdb;

/// >show databases
/// >use test
/// >show measurements
/// >show series from isone_lmp_prices_1H limit 10
/// >show series from isone_lmp_prices_1H where ptid='4000'
/// >select * from isone_lmp_prices_1H where ptid='4000' limit 10
/// >create database test

/// Insertion is idempotent.  You insert the most recent data. (Great!)
/// What if there is a conflict with data for the same timestamp?
/// await insertOneDay(db, new Date(2015, 1, 2));

import 'dart:io';
import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:date/date.dart';
import 'package:timezone/standalone.dart';
import 'dart:convert';

import 'package:demos/db/influxdb.dart';
import 'package:demos/elec/nepool_da_lmp_influx.dart';

basicOperations(InfluxDb db) {
  test('create/delete database', () async {
    await db.createDatabase('junk');
    Response res = await db.showDatabases();
    print(res.body);
    await db.dropDatabase('junk');

  });

  test('write one point', () async {
    String data = 'cpu_load,host=server01,region=us-west value=0.64 1434055562000000000';
    await db.write('test', data);
  });

  test('write two points', () async {
    String data = 'isone_lmp_prices_1H,ptid=321,market=da lmp=63.24,congestion=0.0,loss=1.2 1420088400000000000' +
        '\\nisone_lmp_prices_1H,ptid=322,market=da lmp=63.24,congestion=0.0,loss=1.2 1420088400000000000';
    await db.write('test', data);
  });


}

select(InfluxDb db) async {

  Response aux = await db.select('test', "select * from isone_lmp_prices_1H where ptid='4000'");
  print(aux.body);
  List res = JSON.decode(aux.body)['results'];
  res.forEach(print);

}

getOnePtid(InfluxDb db) async {
  var res = await getHourlyLmpByPtid(db, 4000, component: ['lmp'],
      start: new TZDateTime(location, 2015, 2),
      end: new TZDateTime(location, 2015, 2, 2));

  var aux = new InfluxDbResponse(res, location).toIterable();
  aux.forEach(print);
}

getManyPtids(InfluxDb db) {
  List<int> ptids = new List.generate(8, (i) => 4000 + i);
  TZDateTime start = new TZDateTime(location, 2015,1,1);
  TZDateTime end = new TZDateTime(location, 2015,4,1);

  var it = ptids.forEach((ptid) async {
    var res = await getHourlyLmpByPtid(db, 4000, component: ['congestion']);

  });

}


main() async {
  Map env = Platform.environment;
  String tzdb = env['HOME'] + '/.pub-cache/hosted/pub.dartlang.org/timezone-0.4.3/lib/data/2015b.tzf';
  initializeTimeZoneSync(tzdb);

  String host = 'localhost';
  int port = 8086;
  String username = 'root';
  String password = 'root';
  InfluxDb db = new InfluxDb(host, port, username, password);

  // print(TZDateTime.parse(location, '2015-02-01T05:00:00Z'));

  // print(await insertDays(db, new Date(2015,3,3), new Date(2015,3,31)));

  print(await daysInserted(db));

  //getOnePtid(db);

  getManyPtids(db);


}