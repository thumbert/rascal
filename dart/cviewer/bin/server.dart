library server;

import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:async';
import 'dart:convert';
import 'package:cviewer/mongo/nepool_bindingconstraints.dart';

BindingConstraints bc = new BindingConstraints();

void main() {
  bc.db.open().then((_) {
    HttpServer.bind(InternetAddress.LOOPBACK_IP_V4, 4041)
    .then(listenForRequests)
    .catchError((e) => print(e.toString()));
  });
}

listenForRequests(HttpServer _server) {
  _server.listen((HttpRequest request) {
    if (request.method == 'GET') {
      handleGet(request);
    } else {
      request.response.statusCode = HttpStatus.METHOD_NOT_ALLOWED;
      request.response.write("Unsupported request: ${request.method}.");
      request.response.close();
    }
  }, onDone: () => print('No more requests.'), onError: (e) => print(e.toString()));
}

/**
 * Get the data.
 * query = {'constraintName': ['KR-EXP', 'NHSC-I'],
 *          'start': new DateTime(2015,1,1),
 *          'end': new DateTime(2015,3,1) }
 *
 */
Future<List<Map>> fromMongo(Map query) {
  SelectorBuilder sb = where;


  return ;
}

void handleGet(HttpRequest request) {
  //String params = request.uri.queryParameters['q'];
  //print(params);

  HttpResponse res = request.response;
  res.headers.add("Access-Control-Allow-Origin", "*, ");
  res.headers.add("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
  res.headers.add("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");

  fromMongo().then((data) {
    print("writing data ...");
    //data.forEach((e) => print(e));
    request.response.statusCode = HttpStatus.OK;
    request.response.write(new JsonEncoder().convert(data)); // write a json string
    request.response.close();
  });
}