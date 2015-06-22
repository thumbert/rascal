library elec.energy_offers;

import 'dart:io';
import 'dart:convert';
//import 'package:either';
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

/*
* String month is in the format "yyyymm", e.g. "201401".
*/
ingestOneMonth(String month) {
  Db db = new Db('mongodb://127.0.0.1/nepool');
  db.open().then((_) {
    DbCollection coll = db.collection('masked_energy_offers');
    var ingestor = new Ingestor();
    return ingestor.ingestMonth(month, coll);
  }).then((_) {
    _log.info("Finished ingesting the month " + month);
    db.close();
  });
}

makeIndex() {
  Db db = new Db('mongodb://127.0.0.1/nepool');
  return db.open().then((_) {
    Map keys = {"market": 1, "day": 1, "maskedAssetId": 1};
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

  List<String> entryKeys = [
    'localDate',
    'hourBeginning',
    'MaskedParticipantId',
    'MaskedAssetId',
    'MustTakeEnergy',
    'MaxDialyEnergy',
    'EconomicMax',
    'EconomicMin',
    'ColdStartPrice',
    'IntermediateStartPrice',
    'HotStartPrice',
    'NoLoadPrice',
    'pqPairs',
    'claim10Mw',
    'claim30Mw',
    'UnitStatus'
  ];

  Archiver() {
    coll = db.collection('energy_offers');
    env = Platform.environment;
  }

  /**
   * Read the files in the json format
   */
  Either<List<Map>, String> oneDayJsonRead(String yyyymmdd) {
    String filename = env['HOME'] + DIR + "/da_energy_offers_$yyyymmdd.json";
    File file = new File(filename);
    if (file.existsSync()) {
      String aux = file.readAsStringSync();
      List<Map> input =
      JSON.decode(aux)['HbDayAheadEnergyOffers']['HbDayAheadEnergyOffer'];
      //print(res.first);
      List<Map> res = input.map((Map entry) => processOneEntry(entry)).toList();
      return new Right(res);
    } else {
      return new Left('file $file does not exist!');
    }
  }

  /**
   * Ingest one day offers of all generators in mongo
   */
  oneDayMongoInsert(String yyyymmdd) {}

  /**
   * Process one entry corresponding to one unit, one hour.  Prepare the data for mongo.
   * Make fields:  hourBeginning, localDate, pqPairs=[p1,q1,p2,q2,...]
   */
  processOneEntry(Map entry) {
    List entryValues = [

    ];

    return new Map.fromIterables(entryKeys, entryValues);
  }



  Map parseLine(String line) {
    Map entry = {};
    var x = line.split(",");
    entry["hourEnding"] = _unquote(x[1]);
    entry["maskedLeadParticipantId"] = _toNum(x[2]);
    entry["maskedAssetId"] = _toNum(x[3]);
    if (x[4] != '') entry["mustTakeEnergy"] = num.parse(x[4]);
    if (x[5] != '') entry["maximumDailyEnergy"] = num.parse(x[5]);
    if (x[6] != '') entry["ecoMax"] = num.parse(x[6]);
    if (x[7] != '') entry["ecoMin"] = num.parse(x[7]);
    if (x[8] != '') entry["coldStartupPrice"] = num.parse(x[8]);
    if (x[9] != '') entry["intermediateStartupPrice"] = num.parse(x[9]);
    if (x[10] != '') entry["hotStartupPrice"] = num.parse(x[10]);
    if (x[11] != '') entry["noLoadPrice"] = num.parse(x[11]);
    if (x[12] != '') {
      entry["offerPrice"] = [num.parse(x[12])]; // block 1
      entry["offerMW"] = [num.parse(x[13])];
    }
    if (x[14] != '') {
      entry["offerPrice"].add(num.parse(x[14])); // block 2
      entry["offerMW"].add(num.parse(x[15]));
    }
    if (x[16] != '') {
      entry["offerPrice"].add(num.parse(x[16])); // block 3
      entry["offerMW"].add(num.parse(x[17]));
    }
    if (x[18] != '') {
      entry["offerPrice"].add(num.parse(x[18])); // block 4
      entry["offerMW"].add(num.parse(x[19]));
    }
    if (x[20] != '') {
      entry["offerPrice"].add(num.parse(x[20])); // block 5
      entry["offerMW"].add(num.parse(x[21]));
    }
    if (x[22] != '') {
      entry["offerPrice"].add(num.parse(x[22])); // block 6
      entry["offerMW"].add(num.parse(x[23]));
    }
    if (x[24] != '') {
      entry["offerPrice"].add(num.parse(x[24])); // block 7
      entry["offerMW"].add(num.parse(x[25]));
    }
    if (x[26] != '') {
      entry["offerPrice"].add(num.parse(x[26])); // block 8
      entry["offerMW"].add(num.parse(x[27]));
    }
    if (x[28] != '') {
      entry["offerPrice"].add(num.parse(x[28])); // block 9
      entry["offerMW"].add(num.parse(x[29]));
    }
    if (x[30] != '') {
      entry["offerPrice"].add(num.parse(x[30])); // block 10
      entry["offerMW"].add(num.parse(x[31]));
    }
    entry["claim10"] = num.parse(x[32]);
    entry["claim30"] = num.parse(x[33]);

    return entry;
  }

  _unquote(String x) => x.replaceAll('"', "");
  _toNum(String x) => num.parse(x);

}


