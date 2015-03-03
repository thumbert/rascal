library update_db_test;

//import 'dart:io';
//import 'dart:async';
//import 'package:intl/intl.dart';
import 'package:mongo_dart/mongo_dart.dart';


import 'package:cviewer/mongo/nepool_bindingconstraints.dart';
//import 'package:cviewer/utils.dart';


main() {

  DateTime start = new DateTime.utc(2015, 2, 26);
  DateTime end = new DateTime.utc(2015, 2, 28);
  List names = ['KR-EXP', 'NHSC-I'];

  BindingConstraints bc = new BindingConstraints();
  bc.db.open().then((_) {
    return bc.getBindingConstraints(start, end, constraintNames: null).then((List rows) {
      rows.forEach((row) => print(row));
    });
  }).then((_) => bc.db.close());

//  bc.updateDb();

//  List<DateTime> days = seqDays(start, end);
//  print(days);


//  bc.db.open().then((_) {
//    return bc.lastDayInserted();
//  }).then((v){
//    print(v);
//  }).then((_) => bc.db.close());


//  print(days);
//  print(days.first);

    //String yyyymmdd = '20150101';
    //bc.oneDayDownload( yyyymmdd );
    //bc.oneDayJsonRead( yyyymmdd );
    //bc.oneDayMongoInsert( yyyymmdd );


  }