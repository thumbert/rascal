library demo_mongo_async;

import 'package:mongo_dart/mongo_dart.dart';

/**
 * Show basic usage of the MongoDb from Dart
 */

// http://openmymind.net/mongodb.pdf

var data = [
  {'name': 'Aurora', 'gender': 'f', 'weight': 450},
  {'name': 'Barty', 'gender': 'm', 'weight': 550}
];

main() async {
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

  int n = await coll.count();
  print('there are $n documents in the collection');

  await db.close();
}

/// Find unique fields in a collection (distinct for several variables)
// var pipeline = [];
//     pipeline.add({
//       '\$group': {
//         '_id': {'zone': '\$zone', 'service': '\$service', 
//           'rateClass': '\$rateClass'},
//       }
//     });
//     var res = await coll.aggregateToStream(pipeline);
//     print(await res.toList());


