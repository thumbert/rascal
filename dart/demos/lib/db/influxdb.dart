// library db.influxdb;


// import 'dart:async';
// import 'dart:io';
// import 'package:http/http.dart' as http;
// import 'package:http/src/response.dart';
// import 'package:http/src/base_client.dart';
// import 'package:http/src/client.dart';
// import 'package:http/src/streamed_response.dart';
// import 'package:http/src/base_request.dart';
// import 'dart:convert';
// import 'package:timezone/timezone.dart';
// //import 'package:cryptoutils/cryptoutils.dart';

// class InfluxDb {
//   String host;
//   int port;
//   String username;
//   String password;

//   static String _connectionString = "http://";
//   InfluxDbClient client;

//   InfluxDb(this.host, this.port, this.username, this.password) {
//     client = new InfluxDbClient(new Client(), username, password);
//   }

// //  createDb(String name) async {
// //    client.postSilentMicrotask("$_connectionString$host:$port/query?q=CREATE DATABASE \"$name\"");
// //  }

//   ///
//   /// curl -GET 'http://localhost:8086/query?db=test' --data-urlencode 'q=select * from isone_lmp_prices_1H where ptid='4000'"'
//   /// http://localhost:8086/query?db=test&q=select * from isone_lmp_prices_1H where ptid='4000'
//   Future<Response> select(String dbName, String query, {String epoch, String username, String password}) async {
//     return client.get("$_connectionString$host:$port/query?db=$dbName&q=$query",
//         headers: {'Content-Type': 'application/text'}
//     );
//   }

//   Future<Response> createDatabase(String dbName) async {
//     return client.postSilentMicrotask("$_connectionString$host:$port/query?q=CREATE DATABASE $dbName",
//         headers: {'Content-Type': 'application/text'});
//   }

//   Future<Response> dropDatabase(String dbName) async {
//     return client.postSilentMicrotask("$_connectionString$host:$port/query?q=DROP DATABASE $dbName",
//         headers: {'Content-Type': 'application/text'});
//   }

//   Future<Response> dropMeasurement(String name) async {
//     return client.postSilentMicrotask("$_connectionString$host:$port/query?q=DELETE MEASUREMENT \"$name\"",
//         headers: {'Content-Type': 'application/text'});
//   }

//   /// Return the databases in this instance of influxdb
//   ///  >curl -GET 'http://localhost:8086/query?' --data-urlencode 'q=SHOW DATABASES'
//   ///  this works http://localhost:8086/query?q=SHOW%20DATABASES
//   ///  It does not work with getSilentMicrotask, not sure why
//   Future<Response> showDatabases() async {
//     //return client.getSilentMicrotask("$_connectionString$host:$port/query?q=SHOW DATABASES",
//     return client.get("$_connectionString$host:$port/query?q=SHOW DATABASES",
//         headers: {'Content-Type': 'application/text'}
//         //headers: {'Content-Type': 'application/x-www-form-urlencoded'}
//     );
//   }

//   showMeasurements() async {
//     /// get silent microtask
//   }

//   /// Insert data into the database [dbName] with a timestamp precision [precision].
//   /// The precision can be one of [n,u,ms,s,m,h] for nanoseconds, microseconds,
//   /// milliseconds, seconds, minute, hour frequency respectively.
//   /// [data] needs to follow the line protocol, and have the timestamp in the
//   /// correct precision.
//   Future<Response> write(String dbName, String data, {String precision}) async {
//     String url = '$_connectionString$host:$port/write?db=$dbName';
//     if (precision != null)
//       url = url + '&precision=$precision';
//     return client.postSilentMicrotask(url,
//         headers: {'Content-Type': 'application/text'},
//         body: data);
//   }

// }

// class InfluxDbResponse {
//   Map<String, dynamic> _resJson;
//   List<String> _columns;
//   Location _location;

//   /// location keeps track of the timezone of the timestamps in the response.
//   InfluxDbResponse(Response response, this._location) {
//     _resJson = (((json.decode(response.body)['results'] as List)
//         .first as Map)['series'] as List).first;
//   }

//   List<String> get columns {
//     _columns ??= _resJson['columns'];
//     return _columns;
//   }

//   /// Get the values
//   List<List> get values => _resJson['values'];

//   Iterable<Map<String,dynamic>> toIterable() {
//     return (_resJson['values'] as List).map((e) {
//       e[0] = TZDateTime.parse(_location, e[0]);
//       return new Map.fromIterables(columns, e);
//     });
//   }
// }

// class InfluxDbClient extends BaseClient {
//   String userAgent;
//   Client _inner;
//   String _username;
//   String _password;

//   InfluxDbClient(this._inner, this._username, this._password);

//   Future<StreamedResponse> send(BaseRequest request) {
//     //request.headers["Authorization"] = "Basic ${CryptoUtils.bytesToBase64(UTF8.encode("$_username:$_password"))}";
//     //request.headers["Content-Type"] = "application/x-www-form-urlencoded";
//     return _inner.send(request);
//   }

//   Future<http.Response> getSilentMicrotask(url, {Map<String, String> headers}) async {
//     http.Response resp;
//     scheduleMicrotask(() async {
//       resp = await this.get(url, headers: headers);
//       if (resp.statusCode.toString() == '204')
//         print('--> Response successful!');
//       //print('Response get status: ${resp.statusCode}');
//       //print('Response body: ${resp.reasonPhrase}');
//     });

//     return resp;
//   }


//   postSilentMicrotask(url, {Map<String, String> headers, body, Encoding encoding}) async {
//     http.Response resp;
//     scheduleMicrotask(() async {
//       resp = await this.post(url, headers: headers, body: body, encoding: encoding);
//       if (resp.statusCode.toString() != '204')
//         throw 'Response for $url with headers $headers was not successful.';
// //        print('--> Response successful!');
// //      print('Response status: ${resp.statusCode}');
// //      print('Response body: ${resp.reasonPhrase}');
//     });

//     return resp;
//   }



// }