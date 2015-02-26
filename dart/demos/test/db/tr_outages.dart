library tr_outages;

import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'dart:async';

final Db db = new Db('mongodb://127.0.0.1/myiso');
// will create db if not existing already
final dateFormat = new DateFormat("MM/dd/yyyy HH:mm:ss");
final csvCodec = new CsvCodec();

/**
 * Get all the relevant files
 */
List<File> list_files() {

  var dir = new Directory("../../tmp");
  return dir.listSync().where((entity) =>
  ((entity is File) && (entity.path.contains(new RegExp("outages_st_"))))
  ).toList();

}

/**
 * Insert one short term outage report file into the database
 */
Future process_file(File file) {
  DbCollection coll;

  return db.open().then((_) {
    print("Connection open");

    db.ensureIndex("trx_outages", keys: {
        "ReportTime": -1,
        "PlannedStart": 1,
        "Company1": 1,
        "EquipmentDescription": 1
    });
    coll = db.collection("trx_outages");

    return coll.count().then((value) {
      print("Before Insertion:  Number of documents in collection trx_outages is $value");
    }).then((_) {
      return read_file(file).then((entries) {
        // need to check by ReportTime if I've entered them before!
        return coll.count(where.eq("ReportTime", entries.first["ReportTime"])).then((v) {
          print("Found $v entries for ReportTime = ${entries.first["ReportTime"]}");
          if (v == 0) {
            print("Inserting ...");
            coll.insertAll(entries);
          } else {
            print("Not inserting anything");
          }
        });
      });
    }).then((_) {

      print("Closing the db");
      db.close();
    });
  });

}

/**
 * A List of rows, each row is a Map.
 */
Future<List<Map>> read_file(File file) {

  print("reading file " + file.path);

  return file.readAsString().then((contents) {
    var res = csvCodec.decoder.convert(contents, eol: "\n");
    var data = res.where((List row) => row[0] == "D" && row[7] == "Line") // keep only the lines
    .map((List row) => make_entry(row));

    return data.toList();
  });

}


/**
 * Make a map useful for db insertion by converting timestamps to DateTime, etc.
 * list is one row with outage data
 */
Map make_entry(List list) {
  list.removeAt(0); // get rid of the H, C, D, T first column
  list.removeAt(2); // get rid of the "Hour Ending" column
  var entry = new Map.fromIterables(
      [
          "ReportTime",
          "ApplicationNumber",
          "Company1",
          "Company2",
          "Station",
          "EquipmentType",
          "EquipmentDescription",
          "Voltage",
          "PlannedStart",
          "PlannedEnd",
          "ActualStart",
          "ActualEnd",
          "Status",
          "RequestType",
          "EconomicFlag",
          "MtoFlag",
          "OverrunFlag"],
      list);

  entry["ReportTime"] = _toDateTime(entry["ReportTime"]);
  entry["PlannedStart"] = _toDateTime(entry["PlannedStart"]);
  entry["PlannedEnd"] = _toDateTime(entry["PlannedEnd"]);
  entry["ActualStart"] = _toDateTime(entry["ActualStart"]);
  entry["ActualEnd"] = _toDateTime(entry["ActualEnd"]);

  return entry;
}


DateTime _toDateTime(String value) {

  DateTime datetime;
  try {
    datetime = dateFormat.parse(value);
  } catch (e) {
    //print("Failed to parse datetime: $value");
  }

  return datetime;
}


main() {


  var files = list_files();
  print(files);

  //files.forEach((file) => process_file(file, db));

  Future.forEach(files, process_file);


  //process_file(new File('../../tmp/outages_st_20141022.csv'), db);


}


// db.trx_outages.ensureIndex({"ApplicationNumber": 1, "ReportDate": -1, "PlannedStart": 1, "EquipmentDescription": 1, "Status": 1, "ActualStart": 1}, {unique: true})
// db.trx_outages.ensureIndex({"ApplicationNumber": 1, "ReportDate": -1}, {unique: true})
// db.trx_outages.ensureIndex({"hashKey": 1}, {unique: true})
//db.ensureIndex("trx_outages", keys: {'hashKey' : 1}, unique: true);  // need only once
