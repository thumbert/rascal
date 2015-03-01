library mongo.nepool_bindingconstraints;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:intl/intl.dart';
import 'package:cviewer/utils.dart';

class BindingConstraints {

  Db db;
  String DIR = '/Downloads/Archive/DA_BindingConstraints/Raw/';
  Map<String, String> env;
  final DateFormat fmt = new DateFormat("yyyy-MM-ddTHH:00:00.000-ZZZZ");

  // only parses into local times!

  BindingConstraints({this.db}) {
    if (db == null)
      db = new Db('mongodb://127.0.0.1/nepool');

    env = Platform.environment;
  }

  /**
   * Bring the db up to date.
   * Find the latest day in the archive and update from there to nextDay
   */
  updateDb() {


  }

  /**
   * Archive and Insert days between start, end.
   * Parameters start and end are midnight UTC DateTime objects.
   * For each day in the range of days, download and insert the data into the db.
   */
  insertDaysStartEnd(DateTime start, DateTime end) {
    List<DateTime> days = seqDays(start, end);
    DateFormat fmtDay = new DateFormat('yyyyMMdd');

    db.open().then((_) {
      return Future.forEach(days, (day) {
        String yyyymmdd = fmtDay.format(day);
        return oneDayDownload(yyyymmdd).then((_) {
          return oneDayMongoInsert(yyyymmdd);
        });
      });
    }).then((_) {
      db.close();
    }).then((_) {
      print('Done!');
    });

  }

  /**
   * Make the daily insertions idempotent, so you never insert the same data over
   * and over again.  You should run this only once when you set up the database.
   */
  prepareCollection() {
    return db.open().then((_) {
      return db.ensureIndex('binding_constraints', keys: {
          'hourEnding': 1, 'ConstraintName' : 1
      }, unique: true);
    }).then((_) {
      db.close();
    });
  }

  /**
   * Return the last day that was ingested in the db.
   * db.binding_constraints.aggregate([{$group: {_id: null, lastHour: {$max: '$hourEnding'}}}])
   */
  Future<DateTime> lastDayInserted() {
    DateTime lastDay;

    DbCollection coll = db.collection('binding_constraints');
    List pipeline = [];
    var group = {
        '\$group': {
            '_id': null, 'last': {
                '\$max': '\$hourEnding'
            }
        }
    };
    pipeline.add(group);
    return coll.aggregate(pipeline).then((v) {
      print('$v');
      Map aux = v['result'].first;
      lastDay = aux['last']; // a local datetime
      return new DateTime.utc(lastDay.year, lastDay.month, lastDay.day);
    });
  }

  /**
   * Inserts one day into the db.
   */
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
      return data = [];
      // on some days there are no constraints 2/17/2015
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