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
 * Get the data from mongo.
 * query = {'constraintName': ['KR-EXP', 'NHSC-I'],
 *          'start': new DateTime(2015,1,1),
 *          'end': new DateTime(2015,3,1) }
 *
 */
Future<List<Map>> fromMongo(List<String> constraints, DateTime start, DateTime end) {
  SelectorBuilder sb = where;

  if (start != null)
    sb = sb.gte('start', start);
  if (end != null)
    sb = sb.gte('end', end);
  if (constraints != null)
    sb = sb.oneFrom('constraintName', constraints);

  sb = sb.excludeFields(['_id']);

  return bc.coll.find(sb).toList();
}

void handleGet(HttpRequest request) {
  Map params = request.uri.queryParameters;
  //print(params);
  DateTime start, end;
  List<String> constraints;

  if (params.containsKey('constraints'))
    constraints = params['constraints'].split('|');
  if (params.containsKey('start'))
    start = DateTime.parse(params['start']).toUtc();
  if (params.containsKey('end'))
    end = DateTime.parse(params['end']).toUtc();

  HttpResponse res = request.response;
  res.headers.add("Access-Control-Allow-Origin", "*, ");
  res.headers.add("Access-Control-Allow-Methods", "POST, GET, OPTIONS");
  res.headers.add("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");

  fromMongo(constraints, start, end).then((data) {
    print("writing data ...");
    //data.forEach((e) => print(e));
    request.response.statusCode = HttpStatus.OK;
    request.response.write(new JsonEncoder().convert(data)); // write a json string
    request.response.close();
  });
}