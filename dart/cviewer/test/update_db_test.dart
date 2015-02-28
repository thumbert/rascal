library update_db_test;

import 'dart:io';
import 'dart:async';
import 'package:intl/intl.dart';

import 'package:cviewer/mongo/nepool_bindingconstraints.dart';
import 'package:cviewer/utils.dart';

main() {
  DateFormat fmt = new DateFormat('yyyyMMdd');
  DateTime start = new DateTime.utc(2015,2,27);
  DateTime end   = new DateTime.utc(2015,2,28);
  List<DateTime> days = seqDays(start, end);
  print(days);

  BindingConstraints bc = new BindingConstraints();
  //bc.prepareCollection();

  bc.db.open().then((_) {
    return Future.forEach(days, (day) {
      String yyyymmdd = fmt.format(day);
      return bc.oneDayDownload( yyyymmdd).then((_) {
        return bc.oneDayMongoInsert(yyyymmdd);
      });
    });
  }).then((_) {
    bc.db.close();
  }).then((_) {
    print('Done!');
  });





//  print(days);
//  print(days.first);

  //String yyyymmdd = '20150101';
  //bc.oneDayDownload( yyyymmdd );
  //bc.oneDayJsonRead( yyyymmdd );
  //bc.oneDayMongoInsert( yyyymmdd );



}