library elec.nepool_da_lmp_influx;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/src/response.dart';
import 'package:date/date.dart';
import 'package:timezone/standalone.dart';

import 'package:demos/elec/iso_timestamp.dart';
import 'package:demos/db/influxdb.dart';

/// Test how influx db works
/// 3 fields: lmp, congestion, loss  -- keep the prices
/// 3 tags: ptid, market (DA/RT), asOfTime
/// select * from isone_lmp_prices_1H where ptid='4000'
///

Map env = Platform.environment;
String DIR = env['HOME'] + '/Downloads/Archive/DA_LMP/Raw/Csv';
Location location = getLocation('America/New_York');
String dbName = 'test';
String measurement = 'isone_lmp_prices_1H';

/// Get the hour beginning DA LMP prices for a given ptid between a [start, end) TZDateTime interval.
/// http://localhost:8086/query?db=test&q=select * from isone_lmp_prices_1H where ptid='4000' limit 10
/// http://localhost:8086/query?db=test&q=select lmp from isone_lmp_prices_1H where ptid='4000' limit 10
Future<Response> getHourlyLmpByPtid(InfluxDb db, int ptid, {TZDateTime start, TZDateTime end,
  List component: const ['lmp', 'congestion', 'loss']}) async {
  String query = "select * from isone_lmp_prices_1H where ptid='$ptid'";
  if (component != const ['lmp', 'congestion', 'loss'])
    query = "select ${component.join(',')} from isone_lmp_prices_1H where ptid='$ptid'";
  if (start != null)
    query += " and time >= '${start.toUtc().toIso8601String()}'";
  if (end != null)
    query += " and time < '${end.toUtc().toIso8601String()}'";

  //print(query);
  return await db.select(dbName, query);
}

/// Get the data associated with one csv file into the db.  Timestamp is hour
/// beginning.
///
Future insertOneDay(InfluxDb db, Date day) async {
  List<Map> data = _oneDayRead( day );
  String str = data.map((e) => _makeLine(e)).join('\n');
  await db.write(dbName, str);
}

/// Insert a range of days into influxdb
/// return 0 for success
Future<int> insertDayRange(InfluxDb db, Date start, Date end) async {
  List<Date> range = new TimeIterable(start, end).toList();
  Iterable<Future> ins = range.map((day) {
    print('Inserting day $day');
    return insertOneDay(db, day);
  });
  return Future.wait(ins).then((_) => 0);
}


/// Return the range of DA result days inserted into influxdb
/// A map of this form: {first: 2015-01-01, last: 2015-01-03}
///
Future<Map<String,Date>> daysInserted(InfluxDb db) async {
  var first = db.select(dbName, 'select first(lmp) from isone_lmp_prices_1H').then((response) {
    var m = (((((JSON.decode(response.body)['results'] as List).first as Map)['series'] as List).first as Map)['values'] as List)[0][0];
    return new Date.fromDateTime(TZDateTime.parse(location, m));
  });
  var last = db.select(dbName, 'select last(lmp) from isone_lmp_prices_1H').then((response) {
    var m = (((((JSON.decode(response.body)['results'] as List).first as Map)['series'] as List).first as Map)['values'] as List)[0][0];
    return new Date.fromDateTime(TZDateTime.parse(location, m));
  });;

  return Future.wait([first, last]).then((List d) {
    return new Map.fromIterables(['first', 'last'], [d[0],d[1]]);
  });
}



/**
 * Read the csv file and prepare it for ingestion into mongo.
 * DateTimes need to be hourBeginning UTC, etc.
 */
List<Map<String,dynamic>> _oneDayRead(Date date) {
  File file = new File(DIR + "/WW_DALMP_ISO_${_yyyymmdd(date)}.csv");
  if (file.existsSync()) {
    List<String> keys = ['hourBeginning', 'ptid', 'Lmp_Cong_Loss'];

    List<Map> data = file
        .readAsLinesSync()
        .map((String row) => row.split(','))
        .where((List row) => row.first == '"D"')
        .map((List row) {
      return new Map.fromIterables(keys, [
        parseHourEndingStamp(_unquote(row[1]), _unquote(row[2]), location),
        int.parse(_unquote(row[3])), // ptid
        [
          num.parse(row[6]),
          num.parse(row[8]),
          num.parse(row[9])
        ] // LMP, Congestion, Losses
      ]);
    }).toList();

    return data;
  } else {
    throw 'Could not find file for day $date';
  }
}

/// Make a String line ready to insert into the db using the line protocol
/// The line will look something like this:
/// 'isone_lmp_prices_1H,ptid=321,market=da lmp=63.24,congestion=0.0,loss=1.2 1420088400000000000'
/// so the measurement is 'isone_lmp_prices_1H', the tag keys are: 'market', 'ptid', and the
/// field keys are 'lmp', 'congestion', 'loss'
///
String _makeLine(Map row) {
  return '$measurement,ptid=${row['ptid']},market=da' +
      ' lmp=${row['Lmp_Cong_Loss'][0]},congestion=${row['Lmp_Cong_Loss'][1]},loss=${row['Lmp_Cong_Loss'][2]}' +
      ' ${row['hourBeginning'].millisecondsSinceEpoch*1000000}';
}



String _unquote(String x) => x.substring(1, x.length - 1);


String _yyyymmdd(Date date) {
  var mm = date.month.toString().padLeft(2, '0');
  var dd = date.day.toString().padLeft(2, '0');
  return '${date.year}$mm$dd';
}