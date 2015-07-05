library elec.energy_offers;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:logging/logging.dart';
import 'package:mongo_dart/mongo_dart.dart';

final _log = new Logger("ingestor");
Db db = new Db('mongodb://127.0.0.1/nepool');
DbCollection coll = db.collection('energy_offers');

class EnergyOffers {
  Archiver arch = new Archiver();

  EnergyOffers() {}

  /**
   * Aggregate the MustTake Energy and EcoMax by day for a given hour across
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

  /**
   * Filter the database by beginDate, maskedAssetId or maskedParticipantId.
   * beginDate is a String in the ISO local time format, e.g.
   *   '2014-01-01T00:00:00.000-05:00'
   */
  Future<List<Map>> filterBy(
      {String beginDate, int maskedAssetId, int maskedParticipantId}) async {
    Map filter = {};
    List<Map> res;
    if (beginDate != null) filter['beginDate'] = beginDate;
    if (maskedAssetId != null) filter['maskedAssetId'] = maskedAssetId;
    await arch.db.open();
    res = await arch.coll.find(filter).toList();
    await arch.db.close();
    return res;
  }

  /**
   * Show distinct values the database by beginDate, maskedAssetId or maskedParticipantId.
   * beginDate is a String in the ISO local time format, e.g.
   *   '2014-01-01T00:00:00.000-05:00'
   */
  Future<List<Map>> distinct(
      {String beginDate, int maskedAssetId, int maskedParticipantId}) async {
    Map filter = {};
    List<Map> res;
    if (beginDate != null) filter['beginDate'] = beginDate;
    if (maskedAssetId != null) filter['maskedAssetId'] = maskedAssetId;
    await arch.db.open();
    res = await arch.coll.find(filter).toList();
    await arch.db.close();
    return res;
  }



  /**
 * Return the last inserted day in the archive as a String in the format yyyy-mm-dd.
 */
  Future<String> lastDayInArchive() async {
    List pipeline = [];
    var group = {
      '\$group': {'_id': null, 'lastHour': {'\$max': '\$beginDate'}}
    };
    pipeline.add(group);
    Map res = await coll.aggregate(pipeline);
    print(res);
    String aux = res['result'].first['lastHour'];
    return new Future.value(aux.substring(0, 10));
  }

  Future<List<String>> getDaysInArchive() {
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

  /**
   * Return the stack for a given timestamp.
   * beginDate is a String in the ISO local time format, e.g.
   *   '2014-01-01T00:00:00.000-05:00'
   */
  Future<List<Map>> getStack(String beginDate) async {
    var res;
    List pipeline = [];

    // first you filter by datetime
    Map match = {'\$match': {'beginDate': beginDate}};
    Map unwind = {'\$unwind': '\$offers'};

    //pipeline.add({'\$limit': 100});
    pipeline.add(match);
    pipeline.add({'\$project': {'_id': 0, 'maskedAssetId': 1,
      'economicMax': 1,
      'offers': 1}});
    pipeline.add(unwind);
    pipeline.add({'\$sort': {'offers.price': 1}});
    pipeline.add({
      '\$project': {
        'maskedAssetId': 1,
        'price': '\$offers.price',
        'quantity': '\$offers.quantity'
      }
    });

    await arch.db.open();
    res = await arch.coll.aggregate(pipeline);
    await arch.db.close();
    return res['result'];
  }

  /**
   * Get the units ecomax by assetId
   * beginDate is a String in the ISO local time format, e.g.
   *   '2014-01-01T00:00:00.000-05:00'
   */
  Future<List<Map>> ecomaxByAsset(String beginDate) async {
    var res;
    List pipeline = [];

    // first you filter by datetime
    pipeline.add({'\$match': {'beginDate': beginDate}});
    pipeline.add({'\$project': {'_id': 0, 'maskedAssetId': 1,
    'economicMax': 1, 'unitStatus':1}});
    pipeline.add({'\$group': {'_id': '\$maskedAssetId',
      'ecoMax': {'\$first': '\$economicMax'}
    }});
    pipeline.add({'\$sort': {'ecoMax': -1}});
    pipeline.add({'\$project': {'_id': 0,
      'maskedAssetId': '\$_id',
      'ecoMax': 1
    }});

    await arch.db.open();
    res = await arch.coll.aggregate(pipeline);
    await arch.db.close();
    return res['result'];
  }





}

/**
 * Deal with downloading the data, massaging it, and loading it into mongo.
 */
class Archiver {
  String DIR;

  Db db;
  DbCollection coll;
  Map<String, String> env;

  Archiver({String this.DIR}) {
    if (db == null) db = new Db('mongodb://127.0.0.1/nepool');

    coll = db.collection('energy_offers');
    env = Platform.environment;
    if (DIR == null)
      DIR = env['HOME'] + '/Downloads/Archive/DA_EnergyOffers/Json';
  }

  updateDb({DateTime from, DateTime to}) {
    if (from == null) {
      //from =
    }
  }

  /**
   * Read and format the downloaded json files into a List<Map> suitable for insertion
   * into mongo.
   */
  List<Map> oneDayJsonRead(String yyyymmdd, {String version: "1.1"}) {
    String filename = DIR + "/da_energy_offers_$yyyymmdd.json";
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
    return coll
        .insertAll(data)
        .then((_) => print('--->  SUCCESS'))
        .catchError((e) => print('   ' + e.toString()));
  }

  /**
   * Process one entry corresponding to one unit, one hour.  Prepare the data for mongo.
   * Make fields:  hourBeginning, localDate, pqPairs=[p1,q1,p2,q2,...]
   */
  Map processOneEntry(Map entry) {
    List pq = [];
    List segments = entry['Segments'];

    // if no segments -- Segments: []
    if (segments.first != '') {
      // multiple segments -- "Segments":[{"Segment":[{"@Number":"1","Price":204.02,"Mw":149.9},{"@Number":"2","Price":221.28,"Mw":104.6}]}]
      var aux = segments.first['Segment'];
      // only one segment -- Segments: [{Segment: {@Number: 1, Price: 0, Mw: 99}}]
      if (aux is Map) aux = [aux]; // wrap it in a List

      aux.forEach((Map e) {
        pq.add({'price': e['Price'], 'quantity': e['Mw']});
      });
    }

    Map mongoEntry = {
      'beginDate': entry['BeginDate'], // String
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
      'offers': pq,
      'claim10Mw': entry['Claim10Mw'],
      'claim30Mw': entry['Claim30Mw']
    };

    if (entry.containsKey('UnitStatus')) // introduced sometimes in 2014?
        mongoEntry['unitStatus'] = entry['UnitStatus'];

    return mongoEntry;
  }

  /**
   * Download the file if not in the archive folder.  If file is already downloaded, no nothing.
   */
  Future oneDayDownload(String yyyymmdd) {
    File fileout =
        new File(DIR + "/da_energy_offers_$yyyymmdd.json");

    if (fileout.existsSync()) {
      return new Future.value(print('Day $yyyymmdd was already downloaded.'));
    } else {
      String URL =
          "https://webservices.iso-ne.com/api/v1.1/hbdayaheadenergyoffer/day/${yyyymmdd}";
      HttpClient client = new HttpClient();
      client.badCertificateCallback = (cert, host, port) => true;
      client.addCredentials(Uri.parse(URL), "", new HttpClientBasicCredentials(
          env['ISO1_LOGIN'], env["ISO1_PASSWD"]));
      client.userAgent = "Mozilla/4.0";

      return client.getUrl(Uri.parse(URL)).then((HttpClientRequest request) {
        request.headers.set(HttpHeaders.ACCEPT, "application/json");
        return request.close();
      })
          .then((HttpClientResponse response) =>
              response.pipe(fileout.openWrite()))
          .then((_) => print('Downloaded energy offers for day $yyyymmdd.'));
    }
  }

  /**
   * Recreate the collection from scratch.
   */
  setup() async {
    if (!new Directory(DIR).existsSync())
      new Directory(DIR).createSync(recursive: true);
    await oneDayDownload('20140101');

    await db.open();
    List<String> collections = await db.listCollections();
    print(collections);
    if (collections.contains('energy_offers')) await coll.drop();
    await oneDayMongoInsert('20140101');
    await db.ensureIndex('energy_offers',
        keys: {'maskedAssetId': 1, 'beginDate': 1}, unique: true);
    await db.close();
  }
}
