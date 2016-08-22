library elec.nepool_da_lmp_influx;

import 'dart:io';
import 'dart:async';
import 'package:date/date.dart';
import 'package:timezone/standalone.dart';

import 'package:demos/elec/iso_timestamp.dart';
import 'package:demos/db/influxdb.dart';

/// Test how influx db works
/// 3 fields: lmp, congestion, losses  -- keep the prices
/// 3 tags: ptid, market (DA/RT), asOfTime
///

Map env = Platform.environment;
String DIR = env['HOME'] + '/Downloads/Archive/DA_LMP/Raw/Csv';
//initializeTimeZoneSync();
Location location = getLocation('America/New_York');
String dbName = 'isone_lmp_prices_1H';


/// Get the data associated with one csv file into the db.  Timestamp is hour
/// beginning.
///
Future insertOneDay(InfluxDB db, Date day) {
  List<Map> data = oneDayRead( day );
  String str = data.map((e) => makeLine(e)).join('\n');
  return db.write(dbName, str);
}

/// Make a String line ready to insert into the db using the line protocol
/// The line will look something like this:
/// 'isone_lmp_prices_1H,ptid=321,market=da lmp=63.24,congestion=0.0,loss=1.2 1420088400000000000'
/// so the measurement is 'isone_lmp_prices_1H', the tag keys are: 'market', 'ptid', and the
/// field keys are 'lmp', 'congestion', 'loss'
///
String makeLine(Map row) {
  return '$dbName,ptid=${row['ptid']},market=da' +
      ' lmp=${row['Lmp_Cong_Loss'][0]},congestion=${row['Lmp_Cong_Loss'][1]},loss=${row['Lmp_Cong_Loss'][2]}' +
      ' ${row['hourBeginning'].millisecondsSinceEpoch*1000000}';
}


/**
 * Read the csv file and prepare it for ingestion into mongo.
 * DateTimes need to be hourBeginning UTC, etc.
 */
List<Map<String,dynamic>> oneDayRead(Date date) {
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

String _unquote(String x) => x.substring(1, x.length - 1);


String _yyyymmdd(Date date) {
  var mm = date.month.toString().padLeft(2, '0');
  var dd = date.day.toString().padLeft(2, '0');
  return '${date.year}$mm$dd';
}