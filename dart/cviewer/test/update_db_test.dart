library update_db_test;

import 'dart:io';
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:cviewer/mongo/nepool_bindingconstraints.dart';
import 'package:cviewer/utils.dart';

//updateBindingConstraints(){
//  BindingConstraints bc = new BindingConstraints();
////bc.prepareCollection();
//
//
//}

main() {
  DateTime start = new DateTime.utc(2015,2,27);
  DateTime end   = new DateTime.utc(2015,2,28);
  List<DateTime> days = seqDays(start, end);
  print(days);

  BindingConstraints bc = new BindingConstraints();
  bc.db.open().then((_) {
    return bc.lastDayInserted();
  }).then((v){
    print(v);
  }).then((_) => bc.db.close());



//  print(days);
//  print(days.first);

  //String yyyymmdd = '20150101';
  //bc.oneDayDownload( yyyymmdd );
  //bc.oneDayJsonRead( yyyymmdd );
  //bc.oneDayMongoInsert( yyyymmdd );



}