// library elec.temperature_archive;

// import 'dart:io';
// import 'dart:async';
// import 'dart:convert';
// import 'package:demos/db/influxdb.dart';
// import 'package:tuple/tuple.dart';

// /// Download and archive daily historical data from National Climatic Data Center
// /// USW00014739 == Boston Logan International airport code
// /// http://localhost:8086/query?db=test&q=select * from ncdc_daily limit 10
// ///
// ///

// Map env = Platform.environment;
// String DIR = env['HOME'] + '/Downloads/Archive/DA_LMP/Raw/Csv';
// String dbName = 'test';
// String measurement = 'ncdc_daily';

// String getDefaultArchiveDirectory() {
//   return Platform.environment['HOME'] + '/Downloads/Archive/Temperature';
// }

// num celsiusToFahrenheit(num celsius) => 9*celsius/5 + 32;

// /// Doesn't seem that you can do ftp using HttpClient, so just use wget
// /// Each recent year is about 200 MB of compressed data (large file) 33MM rows.
// Future<int>  downloadFileYear(int year) async {
//   String url = 'ftp://ftp.ncdc.noaa.gov/pub/data/ghcn/daily/by_year/$year.csv.gz';
//   File file = new File(getDefaultArchiveDirectory() + '/$year.csv.gz');
//   if (!file.existsSync()) {
//     return (await Process.run('wget', [url],
//       workingDirectory:  getDefaultArchiveDirectory())).exitCode;
//   } else {
//     return Future.value(0);
//   }
// }

// /// Insert data into influx
// /// [wban] is the WBAN code of the station, e.g. 'USW00014739' for Boston Logan airport.
// Future<List<String>> extractData(int year, String wban,
//     {List<String> variables: const ['TMAX', 'TMIN']}) async {
//   File file = new File('${getDefaultArchiveDirectory()}/$year.csv.gz');
//   // unzip the file first
//   Process.runSync('gunzip', [file.path]);

//   RegExp regexp = new RegExp(variables.join('|'));
//   LineSplitter ls = new LineSplitter();
//   File csv = new File('${getDefaultArchiveDirectory()}/$year.csv');

//   Stream stream = csv.openRead()
//       .transform(utf8.decoder)
//       .transform(ls)
//       .where((String line) => line.startsWith(wban))
//       .where((String line) => line.contains(regexp));

//   // group the observations by date for convenient insertion into influx
//   List res = [];
//   await for (String line in stream) {
//     res.add(line);
//   };

//   Process.run('gzip', ['${getDefaultArchiveDirectory()}/$year.csv']);

//   return res;
// }

// /// Insert the data from one yearly file into influx
// /// 'ncdc_daily,station=USW00014739 TMAX=33.08,TMIN=22.1 1420070400000000000'
// ///
// Future insertDataIntoInflux(List<String> x) async {
//   String host = 'localhost';
//   int port = 8086;
//   String username = 'root';
//   String password = 'root';
//   InfluxDb db = new InfluxDb(host, port, username, password);

//   /// transpose the line data (group several measurements on the same line)
//   /// the key is the Tuple2<stationId,date>, the values are maps with the
//   /// observations.
//   Map<Tuple2<String,String>, Map<String,num>> res = {};
//   x.forEach((String line) {
//     List aux = line.split(',');
//     num value = num.parse(aux[3]);
//     if (aux[2] == 'TMAX' || aux[2] == 'TMIN')
//       value = celsiusToFahrenheit(value/10);  // temperatures are in 1/10 degrees Celsius
//     var key = new Tuple2(aux[0],aux[1]);
//     if (!res.containsKey(key)) res[key] = {};
//     res[key][aux[2]] = value;
//   });

//   /// make the string for influxdb insertion
//   var aux = new StringBuffer();
//   res.forEach((k,v) {
//     DateTime dt = new DateTime.utc(int.parse(k.item2.substring(0,4)),
//       int.parse(k.item2.substring(4,6)), int.parse(k.item2.substring(6)));
//     aux.write('$measurement,station=${k.item1} ');
//     aux.write(v.keys.map((String name) => '$name=${v[name]}').join(','));
//     aux.write(' ${(dt.millisecondsSinceEpoch/3600000).round()}\n');
//   });
//   //print(aux);

//   /// use hourly precision (can't go lower)
//   return await db.write(dbName, aux.toString(), precision: 'h');
// }