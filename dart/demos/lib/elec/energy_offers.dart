library elec.energy_offers;

import 'dart:io';
import 'dart:convert';
import 'package:either/either.dart';
import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:async';

final _log = new Logger("ingestor");



/*
* If you need to wipe out the entire data.  Be kind!
*/
clearTable() {
  Db db = new Db('mongodb://127.0.0.1/nepool');
  db.open().then((_) {
    DbCollection coll = db.collection('masked_energy_offers');
    return coll.drop();
  }).then((_) {
    _log.info("Emptied the masked_energy_offers collection!");
    db.close();
  });
}

Future<List<String>> getDaysInArchive() {
  Db db = new Db('mongodb://127.0.0.1/nepool');
  return db.open().then((_) {
    DbCollection coll = db.collection('masked_energy_offers');
    return coll.distinct('day');
  }).then((e) {
    List<String> days = e['values'];
    int noDays = days.length;
    _log.info("Found $noDays days in the archive");
    db.close();
    return days;
  });
}

Future<List<String>> getMonthsInArchive() {
  Db db = new Db('mongodb://127.0.0.1/nepool');
  return db.open().then((_) {
    DbCollection coll = db.collection('masked_energy_offers');
    return coll.distinct('day');
  }).then((e) {
    List<String> days = e['values'];
    List<String> months = new Set.from(days.map((e) => e.substring(0, 6)))
    .toList(growable: false);
    months.sort();
    int noMonths = months.length;
    _log.info("Found $noMonths months in the archive");
    db.close();
    return months;
  });
}

/*
* Aggregate the MustTake Energy and EcoMax by day for a given hour accross
* all the units in the pool.
*/
Future agg_byDay_mustTake_ecoMax({String hourEnding: "16", String day}) {
  Db db = new Db('mongodb://127.0.0.1/nepool');
  return db.open().then((_) {
    DbCollection coll = db.collection('masked_energy_offers');

    List pipeline = new List();
    var p1 = {
      "\$match": {
        //"day": "20130719",
        //"maskedAssetId": 60802,
        "hourEnding": hourEnding
      }
    };
    if (day != null) p1["\$match"]["day"] = day;

    var p2 = {
      "\$group": {
        "_id": "\$day",
        "totalMustTake": {"\$sum": "\$mustTakeEnergy"},
        "totalEcoMax": {"\$sum": "\$ecoMax"}
      }
    };
    var p3 = {"\$sort": {"_id": 1}};
    pipeline.add(p1);
    pipeline.add(p2);
    pipeline.add(p3);

    return coll.aggregate(pipeline);
  }).then((res) {
    List x = res[
    "result"]; // a List of maps with _id (day), totalMustTake, totalEcoMax
    //x.forEach((e) => print(e));
    db.close();
    return x;
  });
}

/*
* Filter the database by hourEnding, day, maskedAssetId.
*/
Future filterByDayHourAsset(
    {String hourEnding: "20", String day, int maskedAssetId}) {
  Db db = new Db('mongodb://127.0.0.1/nepool');
  return db.open().then((_) {
    DbCollection coll = db.collection('masked_energy_offers');
    Map filter = {};
    if (hourEnding != null) filter["hourEnding"] = hourEnding;
    if (day != null) filter["day"] = day;
    if (maskedAssetId != null) filter["maskedAssetId"] = maskedAssetId;
    return coll.find(filter).toList();
  }).then((res) {
    db.close();
    return res;
  });
}

///*
//* String month is in the format "yyyymm", e.g. "201401".
//*/
//ingestOneMonth(String month) {
//  Db db = new Db('mongodb://127.0.0.1/nepool');
//  db.open().then((_) {
//    DbCollection coll = db.collection('masked_energy_offers');
//    var ingestor = new Ingestor();
//    return ingestor.ingestMonth(month, coll);
//  }).then((_) {
//    _log.info("Finished ingesting the month " + month);
//    db.close();
//  });
//}

makeIndex() {
  Db db = new Db('mongodb://127.0.0.1/nepool');
  return db.open().then((_) {
    //Map keys = {"market": 1, "day": 1, "maskedAssetId": 1};
    return db
    .createIndex("masked_energy_offers",
    keys: {"market": 1, "maskedAssetId": 1, "day": 1, "hourEnding": 1},
    background: true)
    .then((_) {
      _log.info("created index");
    }).then((_) {
      db.close();
    });
  });
}


/**
 * Deal with downloading the data, massaging it, and loading it into mongo.
 */
class Archiver {
  String DIR =
  "/Downloads/Archive/DA_EnergyOffers/Json";

  Db db;
  DbCollection coll;
  Map<String,String> env;


  Archiver() {
    if (db == null)
      db = new Db('mongodb://127.0.0.1/nepool');

    coll = db.collection('energy_offers');
    env = Platform.environment;
  }

  /**
   * Read the files in the json format
   */
  List<Map> oneDayJsonRead(String yyyymmdd, {String version: "1.1"}) {

    String filename = env['HOME'] + DIR + "/da_energy_offers_$yyyymmdd.json";
    File file = new File(filename);
    if (file.existsSync()) {
      String aux = file.readAsStringSync();
      List<Map> input =
      JSON.decode(aux)['HbDayAheadEnergyOffers']['HbDayAheadEnergyOffer'];
      //print(res.first);
      return input.map((Map entry) => processOneEntry(entry)).toList();
    } else {
      throw 'Could not find file $filename';
    }
  }

  /**
   * Ingest one day offers of all generators in mongo
   */
  Future oneDayMongoInsert(String yyyymmdd) {
    List data;
    try {
      data = oneDayJsonRead(yyyymmdd);
    } catch (e) {
      return new Future.value(print('ERROR:  No energy offers for $yyyymmdd'));
    }

    print('Inserting $yyyymmdd into db');
    return coll.insertAll(data)
    .then((_) => print('--->  SUCCESS'))
    .catchError((e) => print('   ' + e.toString()));
  }

  /**
   * Process one entry corresponding to one unit, one hour.  Prepare the data for mongo.
   * Make fields:  hourBeginning, localDate, pqPairs=[p1,q1,p2,q2,...]
   */
  Map processOneEntry(Map entry) {
    List prices = [];
    List quantities = [];
    List segments = entry['Segments'];

    // if no segments -- Segments: []
    if (segments.first != '') {
      // multiple segments -- "Segments":[{"Segment":[{"@Number":"1","Price":204.02,"Mw":149.9},{"@Number":"2","Price":221.28,"Mw":104.6}]}]
      var aux = segments.first['Segment'];
      // only one segment -- Segments: [{Segment: {@Number: 1, Price: 0, Mw: 99}}]
      if (aux is Map)
        aux = [aux];  // wrap it in a List

      aux.forEach((Map e) {
        prices.add(e['Price']);
        quantities.add(e['Mw']);
      });
    }

    Map mongoEntry = {
      'beginDate': entry['BeginDate'],        // String
      'maskedParticipantId': entry['MaskedParticipantId'],
      'maskedAssetId': entry['MaskedAssetId'],
      'mustTakeEnergy': entry['MustTakeEnergy'],
      'maxDailyEnergy': entry['MaxDailyEnergy'],
      'economicMax': entry['EconomicMax'],
      'economicMin': entry['EconomicMin'],
      'coldStartPrice': entry['ColdStartPrice'],
      'intermediateStartPrice': entry['IntermediateStartPrice'],
      'hotStartPrice': entry['HotStartPrice'],
      'noLoadPrice': entry['NoLoadPrice'],
      'price': prices,
      'quantity': quantities,
      'claim10Mw': entry['Claim10Mw'],
      'claim30Mw': entry['Claim30Mw']
    };

    if (entry.containsKey('UnitStatus'))  // introduced sometimes in 2014?
      mongoEntry['unitStatus'] = entry['UnitStatus'];

    return mongoEntry;
  }


  Future oneDayDownload(String yyyymmdd) {
    File fileout = new File(env['HOME'] + DIR + "/da_energy_offers_$yyyymmdd.json");

    if (fileout.existsSync()) {
      return new Future.value(print('Day $yyyymmdd was already downloaded.'));

    } else {
      String URL = "https://webservices.iso-ne.com/api/v1.1/hbdayaheadenergyoffer/day/${yyyymmdd}";
      HttpClient client = new HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      client.addCredentials(Uri.parse(URL), "", new HttpClientBasicCredentials(env['ISO1_LOGIN'], env["ISO1_PASSWD"]));
      client.userAgent = "Mozilla/4.0";

      return client.getUrl(Uri.parse(URL))
      .then((HttpClientRequest request) {
        request.headers.set(HttpHeaders.ACCEPT, "application/json");
        return request.close();
      })
      .then((HttpClientResponse response) => response.pipe(fileout.openWrite()))
      .then((_) => print('Downloaded energy offers for day $yyyymmdd.'));
    }

  }


  setup() async {
    await db.open();
    await db.ensureIndex('energy_offers', keys: {'maskedAssetId': 1, 'localDate': 1},
        unique: true);
    await db.close();
  }
}


