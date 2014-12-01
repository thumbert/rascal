library test_mongo_read;

import 'dart:async';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:convert';

Db db;

Future<List<Map>> from_mongo() {
  db = new Db("mongodb://127.0.0.1/aad");
  var coll = db.collection('googvis');

  return db.open().then((_) {
    return coll.find().toList();
  });
}

main(){
  from_mongo().then((List<Map> data){
    data.forEach((e) => print(e));
    print("and to json ...");
    String str = new JsonEncoder().convert(data);
    print(str);
    List<int> bytes = UTF8.encode(str);    
  }).then((_){
    db.close();
  });
  print('Done');
}