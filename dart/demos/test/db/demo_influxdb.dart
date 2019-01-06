library test.db.demo_influxdb;

import 'package:elec_server/src/utils/timezone_utils.dart';

/// start influx with: influx -precision=rfc3339 to show pretty datetime labels!
/// >show databases
/// >use test
/// >show measurements
/// >show series from isone_lmp_prices_1H limit 10
/// >show series from isone_lmp_prices_1H where ptid='4000'
/// >select * from isone_lmp_prices_1H where ptid='4000' limit 10
/// >create database test
/// >insert ncdc_daily,station=CA007025280 tmin=12,tmax=21 18810101
/// >drop measurement ncdc_daily
/// >select count(TMAX) from ncdc_daily
/// >delete from ncdc_daily
///
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
  var res = json.decode(aux.body)['results'];
  res.forEach(print);

}

getOnePtid(InfluxDb db) async {
  var res = await getHourlyLmpByPtid(db, 4000, component: ['lmp'],
      start: new TZDateTime(location, 2015, 1, 1),
      end: new TZDateTime(location, 2015, 1, 2));

  var aux = new InfluxDbResponse(res, location).toIterable();
  aux.forEach(print);
}

getManyPtids(InfluxDb db) {
  List<int> ptids = new List.generate(8, (i) => 4000 + i);
  TZDateTime start = new TZDateTime(location, 2015,1,1);
  TZDateTime end = new TZDateTime(location, 2015,4,1);

  ptids.forEach((ptid) async {
    var res = await getHourlyLmpByPtid(db, 4000, component: ['congestion']);

  });

}


main() async {
  await initializeTimeZone();

  String host = 'localhost';
  int port = 8086;
  String username = 'root';
  String password = 'root';
  InfluxDb db = new InfluxDb(host, port, username, password);

//  await db.createDatabase('test');
//  await insertOneDay(db, new Date(2016, 1, 1));

  print(await insertDayRange(db, new Date(2017,1,1), new Date(2017,7,31)));

//  print(await daysInserted(db));
//
//  getOnePtid(db);

  //getManyPtids(db);


}