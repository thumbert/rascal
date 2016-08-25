library test.db.demo_influxdb;

import 'package:http/http.dart' as http;
import 'package:test/test.dart';
import 'package:date/date.dart';
import 'package:timezone/standalone.dart';

import 'package:demos/db/influxdb.dart';
import 'package:demos/elec/nepool_da_lmp_influx.dart';

basicOperations(InfluxDB db) {
  db.createDb( 'test' );

  test('write one point', () async {
    String data = 'cpu_load,host=server01,region=us-west value=0.64 1434055562000000000';
    await db.write('test', data);
  });

  test('write two points', () async {
    String data = 'isone_lmp_prices_1H,ptid=321,market=da lmp=63.24,congestion=0.0,loss=1.2 1420088400000000000' +
        '\nisone_lmp_prices_1H,ptid=322,market=da lmp=63.24,congestion=0.0,loss=1.2 1420088400000000000';
    await db.write('test', data);
  });

}

/// Check with
/// >show series from isone_lmp_prices_1H where ptid='4000'
/// >select * from isone_lmp_prices_1H where ptid='4000'
///
//insertOneDay2(InfluxDB db, Date day) async {
//  List<Map> data = oneDayRead( day );
//  String str = data.map((e) => makeLine(e)).join('\n');
//  await db.write('test', str);
//}


main() async {
  initializeTimeZoneSync();

  String host = 'localhost';
  int port = 8086;
  String username = 'root';
  String password = 'root';
  InfluxDB db = new InfluxDB(host, port, username, password);

//  String data = 'cpu_load,host=server01,region=us-west value=0.64 1434055562000000000';
//  await db.write('test', data);

  //insertOneDay(db);


  /// >create database test
  /// >use test
  /// >show series

  /// insertion is idempotent.  You insert the most recent data. (Great!)
  await insertOneDay(db, new Date(2015, 1, 2));






}