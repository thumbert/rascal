library demo_mongo;

import 'package:mongo_dart/mongo_dart.dart';


// http://openmymind.net/mongodb.pdf

var data = [{
    'name': 'Aurora',
    'gender': 'f',
    'weight': 450
  }, {
    'name': 'Barty',
    'gender': 'm',
    'weight': 550
  },];


main() {

  Db db = new Db('mongodb://127.0.0.1/test');
  DbCollection coll;
  db.open().then((_) {
    print("Connection open");
    coll = db.collection("unicorns");
    coll.remove(); // clean up previous mess
    db.ensureIndex('unicorns', keys: {'name': 1}, unique: true);

    print("Insert data one by one");
    data.forEach((uni) {
      coll.insert(uni);
    });
  }).then((_) {
    return coll.count().then((v) {
      print("There are $v documents in the collection");
    });
  }).then((_) {
    print('Finding Barty for inspection:');
    return coll.find({
      'name': 'Barty'
    }).toList().then((e) {
      print(e);
    });
  }).then((_) {
    print("Find a u-corn that doesn't exist!");
    coll.find({'name': 'Catherina'}).toList().then((e) {
      //it does not get here EVER!
      print(e.length);
    });
    return coll.count({'name': 'Catherina'}).then((v){
      // it doesn't get here EVER!
      print("There are $v u-corns called Catherina!");
    });
  }).then((_) {
    //db.unicorns.ensureIndex({name: 1}, {unique: true})
    print('Inserting another Aurora u-corn (should not be allowed)');
    return 
      coll.insert({'name': 'Aurora', 'gender': 'f', 'weight': 330}).then((_){
      }, onError: (e) => print(e));
  }).then((_) {
    print("Closing the db");
    return db.close();
  });

}
