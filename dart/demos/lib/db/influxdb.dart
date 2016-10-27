library db.influxdb;


import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/src/response.dart';
import 'package:http/src/base_client.dart';
import 'package:http/src/client.dart';
import 'package:http/src/streamed_response.dart';
import 'package:http/src/base_request.dart';
import 'dart:convert';
import 'package:cryptoutils/cryptoutils.dart';

class InfluxDB {
  String host;
  int port;
  String username;
  String password;

  static String _connectionString = "http://";
  InfluxDBClient client;

  InfluxDB(this.host, this.port, this.username, this.password) {
    client = new InfluxDBClient(new Client(), username, password);
  }

//  createDb(String name) async {
//    client.postSilentMicrotask("$_connectionString$host:$port/query?q=CREATE DATABASE \"$name\"");
//  }

  query(String dbName, {String epoch, String username, String password}) async {

  }

  Future<Response> createDatabase(String dbName) async {
    return client.postSilentMicrotask("$_connectionString$host:$port/query?q=CREATE DATABASE $dbName",
        headers: {'Content-Type': 'application/text'});
  }

  Future<Response> dropDatabase(String dbName) async {
    return client.postSilentMicrotask("$_connectionString$host:$port/query?q=DROP DATABASE $dbName",
        headers: {'Content-Type': 'application/text'});
  }

  Future<Response> dropMeasurement(String name) async {
    return client.postSilentMicrotask("$_connectionString$host:$port/query?q=DELETE MEASUREMENT \"$name\"",
        headers: {'Content-Type': 'application/text'});
  }

  /// Return the databases in this instance of influxdb
  ///  >curl -GET 'http://localhost:8086/query?' --data-urlencode 'q=SHOW DATABASES'
  ///  this works http://localhost:8086/query?q=SHOW%20DATABASES
  ///  It does not work with getSilentMicrotask, not sure why
  Future<Response> showDatabases() async {
    //return client.getSilentMicrotask("$_connectionString$host:$port/query?q=SHOW DATABASES",
    return client.get("$_connectionString$host:$port/query?q=SHOW DATABASES",
        headers: {'Content-Type': 'application/text'}
        //headers: {'Content-Type': 'application/x-www-form-urlencoded'}
    );
  }

  showMeasurements() async {
    /// get silent microtask
  }

  /// Insert data into the database $dbName.  
  Future<Response> write(String dbName, String data) async {
    return client.postSilentMicrotask("$_connectionString$host:$port/write?db=$dbName",
        headers: {'Content-Type': 'application/text'},
        body: data);
  }

}

class InfluxDBClient extends BaseClient {
  String userAgent;
  Client _inner;
  String _username;
  String _password;

  InfluxDBClient(this._inner, this._username, this._password);

  Future<StreamedResponse> send(BaseRequest request) {
    //request.headers["Authorization"] = "Basic ${CryptoUtils.bytesToBase64(UTF8.encode("$_username:$_password"))}";
    //request.headers["Content-Type"] = "application/x-www-form-urlencoded";
    return _inner.send(request);
  }

  Future<http.Response> getSilentMicrotask(url, {Map<String, String> headers}) async {
    http.Response resp;
    scheduleMicrotask(() async {
      resp = await this.get(url, headers: headers);
      if (resp.statusCode.toString() == '204')
        print('--> Response successful!');
      print('Response get status: ${resp.statusCode}');
      print('Response body: ${resp.reasonPhrase}');
    });

    return resp;
  }


  postSilentMicrotask(url, {Map<String, String> headers, body, Encoding encoding}) async {
    http.Response resp;
    scheduleMicrotask(() async {
      resp = await this.post(url, headers: headers, body: body, encoding: encoding);
      if (resp.statusCode.toString() == '204')
        print('--> Response successful!');
      print('Response status: ${resp.statusCode}');
      print('Response body: ${resp.reasonPhrase}');
    });

    return resp;
  }



}