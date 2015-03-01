library demo_mongo;

import 'package:mongo_dart/mongo_dart.dart';

/**
 * Show basic usage of the MongoDb from Dart
 */

// http://openmymind.net/mongodb.pdf

var data = [{
    'name': 'Aurora',
    'gender': 'f',
    'weight': 450
}, {
    'name': 'Barty',
    'gender': 'm',
    'weight': 550
} ];


main() {
  print("Original data:");
  print(data);

  Db db = new Db('mongodb://127.0.0.1/test');
  DbCollection coll;

  db.open().then((_) {
    print("\nInsert original data (2 unicorns) in the db.");
    coll = db.collection("unicorns");
    coll.remove(); // clean up previous mess

    print("Force the index (the unicorn name) to be unique.");
    /** This guarantees that if you try to insert a unicorn with
     *  the same name as an already existing unicorn in the db,
     *  the insertion will fail.
     */
    db.ensureIndex('unicorns', keys: {
        'name': 1
    }, unique: true);

    data.forEach((uni) {
      coll.insert(uni);
    });


  }).then((_) {
    return coll.count().then((v) {
      if (v == data.length) {
        print("\n${data.length} documents inserted OK.");
      }
    });


  }).then((_) {
    print('\nCalling unicorn Barty for inspection:');
    return coll.find({
        'name': 'Barty'
    }).toList().then((e) {
      print(e);
    });


  }).then((_) {
    print("\nFind a unicorn that doesn't exist (looking for Catherina)!");
    coll.find({
        'name': 'Catherina'
    }).toList().then((e) {
      //it does not get here EVER!
      print("Found $e");
    });
    return coll.count({
        'name': 'Catherina'
    }).then((v) {
      // it doesn't get here EVER!
      print("There are $v unicorns called Catherina!");
    });


  }).then((_) {
    print('\nInserting another unicorn with name Aurora (should not be allowed)');
    return
      coll.insert({
          'name': 'Aurora', 'gender': 'f', 'weight': 330
      }).then((_) {
      }, onError: (e) => print(e));


  }).then((_) {
    /**
     * What happens when you insertAll and one of the entries has a conflict?
     * Devon makes it (no conflict), Aurora triggers an error and the execution stops.
     * Ellie doesn't make it in the db.
     */
    var aux = [{
        'name': 'Devon', 'gender': 'm', 'weight': 222
    }, {
        'name': 'Aurora', 'gender': 'f', 'weight': 330
    }, {
        'name': 'Ellie', 'gender': 'f', 'weight': 440
    }];
    print('\nInserting ${aux.length} unicorns with insertAll (Aurora should conflict): \n$aux.');
    return coll.insertAll(aux).then((_) {
    }, onError: (e) => print(e));


  }).then((_) {
    return coll.count().then((v) {
      print('\nThere are now $v documents in the collection.');
    });


  }).then((_) {
    return coll.find().toList().then((List v){
      var names = v.map((e) => e['name']).join(', ');
      print('Names of unicorns in db are: $names.  Ellie didn\'t make it.');
    });


  }).then((_) {
    print('\nInserting Cathy, Ellie and Frank');
    var aux = [{
        'name': 'Cathy', 'gender': 'f', 'weight': 2500
    }, {
        'name': 'Frank', 'gender': 'm', 'weight': 111
    }, {
        'name': 'Ellie', 'gender': 'f', 'weight': 440
    }];
    return coll.insertAll(aux).then((_) {
    }, onError: (e) => print(e));


  }).then((_) {
    return coll.find(where.sortBy('weight', descending: true).limit(1)).toList().then((v) {
      print('\nFind the fattest unicorn of them all:\n$v');
    });


  }).then((_) {
    /**
     * see: https://github.com/vadimtsushko/mongo_dart/blob/master/test/database_tests.dart
     * Aggregation pipeline example.
     * Find the max weight by gender
     db.unicorns.aggregate([
      {$group: {_id: '$gender', maxWeight: {$max: '$weight'}}}
     ])
    */
    List pipeline = [];
    var group = {'\$group': {'_id': '\$gender', 'maxWeight': {'\$max': '\$weight'}}};
    pipeline.add( group );
    return coll.aggregate(pipeline).then((v){
      print('\nFind the fattest unicorn by gender (Aggregation pipeline):');
      v['result'].forEach((e) => print(e));
    });


  }).then((_) {
    print("\nClosing the db");
    return db.close();
  });
}
