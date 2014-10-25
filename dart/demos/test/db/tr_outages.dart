library tr_outages;

import 'package:mongo_dart/mongo_dart.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';


final dateFormat = new DateFormat("MM/dd/yyyy HH:mm:ss");
final csvCodec = new CsvCodec();


read_file(File file) {

  print("reading file " + file.path);

  return file.readAsString().then((contents) {
    var res = csvCodec.decoder.convert(contents, eol: "\n");
    var data = res.where((row) => row[0] == "D" && row[7] == "Line") // keep only the lines
    .map((List row) => make_entry(row.sublist(1))); // ignore the first column

    return data.toList();
  });

}


/**
 * Make a map useful for db insertion by converting timestamps to DateTime, etc.
 * list is one row with outage data   
 */
make_entry(List list) {
  var entry =
      new Map.fromIterables(
          [
              "ReportDate",
              "HourEnding",
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

  entry["ReportDate"] = _toDateTime(entry["ReportDate"]);
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


  var file = new File('../../tmp/outages_st_20141021.csv');

  Db db = new Db('mongodb://127.0.0.1/myiso');  // will create db if not existing already
  //db.ensureIndex("trx_outages", keys: {"ApplicationNumber": 1, "ReportDate": -1, "PlannedStart": 1, 
  //  "EquipmentDescription": 1}, unique: true);
  // db.trx_outages.ensureIndex({"ApplicationNumber": 1, "ReportDate": -1, "PlannedStart": 1, "EquipmentDescription": 1, "Status": 1, "ActualStart": 1}, {unique: true})
  // db.trx_outages.ensureIndex({"ApplicationNumber": 1, "ReportDate": -1}, {unique: true})
  
  
  db.open().then((_) {
    print("Connection open");
     DbCollection trxout = db.collection("trx_outages");
     
     trxout.count().then((value){
       
       print("Before Insertion:  Number of documents in collection trx_outages is $value");
       
       return read_file(file).then((entries) {
        
        //print(entries);
        return trxout.insertAll(entries).then((_){
          return trxout.count().then((value){
            print("After Insertion:  Number of documents in collection trx_outages is $value");          
          });
        });       
    });
  }).then((_){
    
    print("Closing the db");
    db.close();
    });
  });
}


// db.unicorns.insert({name: 'Aurora', gender: 'f', weight: 450})

