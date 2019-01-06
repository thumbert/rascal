library demo_mongo;

import 'package:mongo_dart/mongo_dart.dart';

/**
 * Show basic usage of the MongoDb from Dart
 */

// http://openmymind.net/mongodb.pdf

unicornsTest() async {
  var data = [
    {'name': 'Aurora', 'gender': 'f', 'weight': 450},
    {'name': 'Barty', 'gender': 'm', 'weight': 550}
  ];

  print("Original data:");
  print(data);

  Db db = new Db('mongodb://127.0.0.1/test');
  DbCollection coll;

  await db.open();
  print("\nInsert original data (2 unicorns) in the db.");
  coll = db.collection("unicorns");
  await coll.remove({}); // clean up previous mess

  print("Force the index (the unicorn name) to be unique.");
  /** This guarantees that if you try to insert a unicorn with
     *  the same name as an already existing unicorn in the db,
     *  the insertion will fail.
     */
  db.ensureIndex('unicorns', keys: {'name': 1}, unique: true);

  data.forEach((uni) {
    coll.insert(uni);
  });

  int v = await coll.count();
  if (v == data.length) {
    print("\n${data.length} documents inserted OK.");
  }

  print('\nCalling unicorn Barty for inspection:');
  List res = await coll.find({'name': 'Barty'}).toList();
  print(res);

  print("\nFind a unicorn that doesn't exist (looking for Catherina)!");
  List cath = await coll.find({'name': 'Catherina'}).toList();
  if (cath.isNotEmpty) throw 'should not get here';

  print('\nInserting another unicorn with name Aurora (should not be allowed)');
  await coll.insert({'name': 'Aurora', 'gender': 'f', 'weight': 330}).then((_) {
  }, onError: (e) => print(e));

  /**
     * What happens when you insertAll and one of the entries has a conflict?
     * Devon makes it (no conflict), Aurora triggers an error and the execution stops.
     * Ellie doesn't make it in the db.
     */
  var aux = [
    {'name': 'Devon', 'gender': 'm', 'weight': 222},
    {'name': 'Aurora', 'gender': 'f', 'weight': 330},
    {'name': 'Ellie', 'gender': 'f', 'weight': 440}
  ];
  print(
      '\nInserting ${aux.length} unicorns with insertAll (Aurora should conflict): \n$aux.');
  await coll.insertAll(aux).then((_) {}, onError: (e) => print(e));

  int i = await coll.count();
  print('\nThere are now $i documents in the collection.');

  await coll.find().toList().then((List v) {
    var names = v.map((e) => e['name']).join(', ');
    print('Names of unicorns in db are: $names.  Ellie didn\'t make it.');
  });

  print('\nInserting Cathy, Ellie and Frank');
  var aux2 = [
    {'name': 'Cathy', 'gender': 'f', 'weight': 2500},
    {'name': 'Frank', 'gender': 'm', 'weight': 111},
    {'name': 'Ellie', 'gender': 'f', 'weight': 440}
  ];
  await coll.insertAll(aux2).then((_) {}, onError: (e) => print(e));

  var fattie = await coll
      .find(where.sortBy('weight', descending: true).limit(1))
      .toList();
  print('\nFind the fattest unicorn of them all (should be Cathy!):\n$fattie');

  /**
     * see: https://github.com/vadimtsushko/mongo_dart/blob/master/test/database_tests.dart
     * Aggregation pipeline example.
     * Find the max weight by gender
        db.unicorns.aggregate([
        {$group: {_id: '$gender', maxWeight: {$max: '$weight'}}}
        ])
     */
  List pipeline = [];
  var group = {
    '\$group': {
      '_id': '\$gender',
      'maxWeight': {'\$max': '\$weight'}
    }
  };
  pipeline.add(group);
  Map agg = await coll.aggregate(pipeline);
  print('\nFind the fattest unicorn by gender (Aggregation pipeline):');
  agg['result'].forEach((e) => print(e));

  print('Have an example on how to remove records ...');

  print("\nClosing the db");
  await db.close();
}

selectFromArray() async {
  List grades = [
    {
      "_id": 1,
      "semester": 1,
      "grades": [70, 87, 90]
    },
    {
      "_id": 2,
      "semester": 1,
      "grades": [90, 88, 92]
    },
    {
      "_id": 3,
      "semester": 1,
      "grades": [85, 100, 90]
    },
    {
      "_id": 4,
      "semester": 2,
      "grades": [79, 85, 80]
    },
    {
      "_id": 5,
      "semester": 2,
      "grades": [88, 88, 92]
    },
    {
      "_id": 6,
      "semester": 2,
      "grades": [95, 90, 96]
    }
  ];

  Db db = new Db('mongodb://127.0.0.1/test');
  DbCollection coll;

  await db.open();
  coll = db.collection("grades");
  await coll.remove({});
  await coll.insertAll(grades);

  print('Select all docs with midterm grades > 89');
  SelectorBuilder sb = where.gt('grades.1', 89);
  print(sb.toString());
  List res = await coll.find(sb).toList();
  res.forEach((e) => print(e));

  // db.grades.find({semester: 2}, {'grades.$': 1})  // does not work

  print('Select only the midterm grades for semester 2 (need to use the aggregate framework)');
  List pipeline = [];

  pipeline.add({'\$match': {'semester': 2}});
  //pipeline.add({'\$project': {'_id': 1, 'semester': 1, 'midgrade':  '\$grades.1'}});
  //pipeline.add({'\$project': {'_id': 1, 'semester': 1, 'midgrade':  {'\$grades': 1}}});

  List res2 = await coll.aggregateToStream(pipeline).toList();
  res2.forEach((e) => print(e));



  //await coll.remove();
  await db.close();
}

main() async {
  //unicornsTest();

  selectFromArray();
}
