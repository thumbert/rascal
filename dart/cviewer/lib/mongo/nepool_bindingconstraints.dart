library mongo.nepool_bindingconstraints;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:intl/intl.dart';

class BindingConstraints {

  Db db;
  String DIR = '/Downloads/Archive/DA_BindingConstraints/Raw/';
  Map<String, String> env;
  final fmt = new DateFormat("yyyy-MM-ddTHH:00:00.000-ZZZZ");

  // only parses into local times!

  BindingConstraints({this.db}) {
    if (db == null)
      db = new Db('mongodb://127.0.0.1/nepool');

    env = Platform.environment;
  }

  prepareCollection() {
    return db.open().then((_) {
      return db.ensureIndex('binding_constraints', keys: {
          'hourEnding': 1, 'ConstraintName' : 1
      }, unique: true);
    }).then((_) {
      db.close();
    });
  }

//  DateTime lastDayInserted() {
//    db.open().then((_) {
//      DbCollection coll = db.collection('binding_constraints');
//      db.find(where.);
//    }).then((_) {
//      db.close();
//    });
//  }

  Future oneDayMongoInsert(String yyyymmdd) {
    List data = oneDayJsonRead(yyyymmdd);
    if (data.isEmpty)
      return new Future.value(print('No binding constraints for $yyyymmdd.  Skipping.'));

    DbCollection coll = db.collection('binding_constraints');
    print('Inserting $yyyymmdd into db');
    return coll.insertAll(data)
      .then((_) => print('--->  SUCCESS'))
      .catchError((e) => print(e));
  }

  /**
   * Read the json file and prepare it for ingestion into mongo.
   * DateTimes need to be hourEnding UTC, etc.
   */
  List<Map> oneDayJsonRead(String yyyymmdd) {
    List<Map> data;
    File filename = new File(env['HOME'] + DIR + "nepool_da_bc_${yyyymmdd}.json");
    Map aux = JSON.decode(filename.readAsStringSync());
    if (aux['DayAheadConstraints'] == "") {
      return data = [];                         // on some days there are no constraints 2/17/2015
    } else {
      data = aux['DayAheadConstraints']['DayAheadConstraint'];
    }

    data.forEach((Map row) {
      row['hourEnding'] = fmt.parse(row['BeginDate']).toUtc().add(new Duration(minutes: 60));
    });
    //data.forEach((e) => print(e));

    return data;
  }

  Future oneDayDownload(String yyyymmdd) {
    File fileout = new File(env['HOME'] + DIR + "nepool_da_bc_${yyyymmdd}.json");

    if (fileout.existsSync()) {
      return new Future.value(print('Day $yyyymmdd was already downloaded.'));
    } else {
      String URL = "https://webservices.iso-ne.com/api/v1.1/dayaheadconstraints/day/${yyyymmdd}";
      HttpClient client = new HttpClient();
      client.badCertificateCallback = (cert, host, port) {
        //print('Bad certificate connecting to $host:$port:');
        //_printCertificate(cert);
        //print('');
        return true;
      };
      client.addCredentials(Uri.parse(URL), "", new HttpClientBasicCredentials(env['ISO1_LOGIN'], env["ISO1_PASSWD"]));
      client.userAgent = "Mozilla/4.0";

      return client.getUrl(Uri.parse(URL))
      .then((HttpClientRequest request) {
        request.headers.set(HttpHeaders.ACCEPT, "application/json");
        return request.close();
      })
      .then((HttpClientResponse response) => response.pipe(fileout.openWrite()))
      .then((_) => 'Downloaded binding constraints for day $yyyymmdd.');
    }
  }


  _printCertificate(cert) {
//    print('${cert.issuer}');
//    print('${cert.subject}');
//    print('${cert.startValidity}');
//    print('${cert.endValidity}');
  }

}