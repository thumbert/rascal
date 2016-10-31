library test.db.demo_influxdb;

/// >show databases
/// >use test
/// >show measurements
/// >show series  -- may be too many
/// >show series from isone_lmp_prices_1H where ptid='4000'
/// >select * from isone_lmp_prices_1H where ptid='4000'
/// >create database test

/// Insertion is idempotent.  You insert the most recent data. (Great!)
/// What if there is a conflict with data for the same timestamp?
/// await insertOneDay(db, new Date(2015, 1, 2));

import 'package:http/http.dart';
import 'package:test/test.dart';
import 'package:date/date.dart';
import 'package:timezone/standalone.dart';
import 'dart:convert';

import 'package:demos/db/influxdb.dart';
import 'package:demos/elec/nepool_da_lmp_influx.dart';

basicOperations(InfluxDB db) {
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
        '\nisone_lmp_prices_1H,ptid=322,market=da lmp=63.24,congestion=0.0,loss=1.2 1420088400000000000';
    await db.write('test', data);
  });


}

select(InfluxDB db) async {

  Response aux = await db.select('test', "select * from isone_lmp_prices_1H where ptid='4000'");
  print(aux.body);
  List res = JSON.decode(aux.body)['results'];
  res.forEach(print);

}


/// Check with
_insertOneDay2(InfluxDB db, Date day) async {
  List<Map> data = oneDayRead( day );
  String str = data.map((e) => makeLine(e)).join('\n');
  await db.write('test', str);
}


main() async {
  initializeTimeZoneSync();

  String host = 'localhost';
  int port = 8086;
  String username = 'root';
  String password = 'root';
  InfluxDB db = new InfluxDB(host, port, username, password);

//  String data = 'cpu_load,host=server01,region=us-west value=0.64 1434055562000000000';
//  await db.write('test', data);


  await select(db);


  //insertOneDay(db);

  //await db.createDatabase('junk');
  //await db.dropDatabase('junk');
//  var res = await db.showDatabases();
//  print(res.body);











}