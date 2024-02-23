// library elec.outages_short_term;

// import 'dart:io';
// import 'dart:async';
// import 'package:mongo_dart/mongo_dart.dart';
// import 'package:csv/csv.dart';
// import 'package:intl/intl.dart';

// /**
//  * Deal with downloading the data, massaging it, and loading it into mongo.
//  */
// class Archiver {
//   String DIR;

//   Db db;
//   DbCollection coll;
//   Map<String, String> env;
//   DateFormat fmtS = new DateFormat('MM/dd/yyyy'); // short
//   DateFormat fmtL = new DateFormat('MM/dd/yyyy HH:mm:ss'); // long

//   Archiver({String this.DIR}) {
//     if (db == null) db = new Db('mongodb://127.0.0.1/nepool');

//     coll = db.collection('outages_short');
//     env = Platform.environment;
//     if (DIR == null) DIR = env['HOME'] + '/Downloads/Archive/Outages_Short/Csv';
//   }

//   updateDb({DateTime from, DateTime to}) {
//     if (from == null) {
//       //from =
//     }
//   }

//   /**
//    * Read and format the downloaded csv files into a List<Map> suitable for insertion
//    * into mongo.
//    */
//   List<Map> oneDayRead(String yyyymmdd) {
//     String filename = DIR + "/outages_shortterm_$yyyymmdd.csv";
//     var converter = new CsvToListConverter();
//     File file = new File(filename);
//     if (file.existsSync()) {
//       List<Map> aux = file
//           .readAsLinesSync()
//           .where((String row) => row.startsWith('"D"'))
//           .map((String row) => processOneEntry(converter.convert(row).first))
//           .toList();
//       //print(aux.take(6));

//       // add the spreadsheet row number to each mongo entry
//       new Iterable.generate(aux.length).forEach((i) => aux[i]['row'] = i);

//       return aux;
//     } else {
//       throw 'Could not find file for day $yyyymmdd';
//     }
//   }

//   /**
//    * Ingest one day offers of all generators in mongo
//    */
//   Future oneDayMongoInsert(String yyyymmdd) {
//     List data;
//     try {
//       data = oneDayRead(yyyymmdd);
//     } catch (e) {
//       print('ERROR:  No file for day $yyyymmdd');
//       return new Future.value(1);
//     }

//     print('Inserting day $yyyymmdd into db');
//     return coll
//         .insertAll(data)
//         .then((_) => print('--->  SUCCESS'))
//         .catchError((e) => print('   ' + e.toString()));
//   }

//   /**
//    * Process one entry corresponding to one row of the report.
//    * Prepare the data for mongo.
//    */
//   Map processOneEntry(List entry) {
//     // take only the report date.
//     String rD = (entry[1] as String).split(' ').first;

//     Map mongoEntry = {
//       'reportDate': fmtS.parse(rD).toUtc(),
//       'applicationNumber': entry[3],
//       'company1': entry[4],
//       'company2': entry[5],
//       'station': entry[6],
//       'equipmentType': entry[7],
//       'equipmentDescription': entry[8],
//       'voltage': entry[9],
//       'plannedStart': fmtL.parse(entry[10]).toUtc(),
//       'plannedEnd': fmtL.parse(entry[11]).toUtc(),
//       'status': entry[14],
//       'requestType': entry[15]
//     };
//     if (entry[12] != "") mongoEntry['actualStart'] =
//         fmtL.parse(entry[12]).toUtc();
//     if (entry[13] != "") mongoEntry['actualEnd'] =
//         fmtL.parse(entry[13]).toUtc();

//     return mongoEntry;
//   }

//   /**
//    * Download the file if not in the archive folder.  If file is already downloaded, no nothing.
//    */
//   Future oneDayDownload(String yyyymmdd) async {
//     File fileout = new File(DIR + "/outages_shortterm_$yyyymmdd.csv");

//     if (fileout.existsSync()) {
//       print('Day $yyyymmdd was already downloaded.');
//       return new Future.value(1);
//     } else {
//       String URL =
//           'http://www.iso-ne.com/transform/csv/outages?outageType=short-term&start=$yyyymmdd';
//       HttpClient client = new HttpClient();
//       HttpClientRequest request = await client.getUrl(Uri.parse(URL));
//       HttpClientResponse response = await request.close();
//       await response.pipe(fileout.openWrite());
//       print('Downloaded short term outages for day $yyyymmdd.');
//     }
//   }

//   /**
//    * Recreate the collection from scratch.
//    */
//   setup() async {
//     if (!new Directory(DIR).existsSync()) new Directory(DIR)
//         .createSync(recursive: true);
//     await oneDayDownload('20140101');

//     await db.open();
//     List<String> collections = await db.listCollections();
//     print('Collections in db:');
//     print(collections);
//     if (collections.contains('outages_short')) await coll.drop();
//     await oneDayMongoInsert('20140101');

//     // this indexing assures that I don't insert the same data twice
//     await db.ensureIndex('outages_short',
//         keys: {
//           'reportDate': 1,
//           'row': 1
//         },
//         unique: true);

//     // this indexing useful for analysis
//     await db.ensureIndex('outage_short', keys: {
//       'equipmentType': 1,
//       'voltage': 1,
//       'equipmentDescription': 1
//     });


//     await db.close();
//   }
// }
