library demo_mongo_aggregation;

import 'package:test/test.dart';
import 'package:mongo_dart/mongo_dart.dart';

filterAndAggregateExample(
    DbCollection coll, String startDate, String endDate, String zone) async {
  List pipeline = [];
  pipeline.add({
    '\$match': {
      'timestamp': {
        '\$gte': DateTime.parse(startDate),
        '\$lte': DateTime.parse(endDate),
      }
    }
  });
  pipeline.add({
    '\$match': {
      'zone': {'\$eq': zone}
    }
  });
  pipeline.add({
    '\$group': {
      '_id': '\$timestamp',
      'customersOut': {'\$sum': '\$customersOut'},
      'totalCustomers': {'\$sum': '\$totalCustomers'}
    }
  });
  pipeline.add({
    '\$sort': {'_id': 1}
  });
//    pipeline.add({
//      '\$project': {'timestamp': '\$_id', 'customersOut': 1, 'totalCustomers': 1}
//    });
//    pipeline.add({
//      '\$project': {'_id': 0}
//    });

  Map v = await coll.aggregate(pipeline);
  print(v);
}

tests() async {
  group('mongo aggregation', () {
    /// An example of using the aggregation pipeline.  Aggregate timeserie
    /// by month and id.
    var data = [
      {'day': '2015-01-01', 'id': 'A', 'value': 1},
      {'day': '2015-01-02', 'id': 'A', 'value': 2},
      {'day': '2015-01-01', 'id': 'B', 'value': 3},
      {'day': '2015-01-02', 'id': 'B', 'value': 4},
      {'day': '2015-02-01', 'id': 'A', 'value': 5},
      {'day': '2015-02-02', 'id': 'A', 'value': 6},
      {'day': '2015-02-01', 'id': 'B', 'value': 7},
      {'day': '2015-02-02', 'id': 'B', 'value': 8},
    ];
    Db db = new Db('mongodb://127.0.0.1/test');
    DbCollection coll = db.collection("timeseries");
    setUp(() async {
      await db.open();
      await coll.drop();
      await coll.insertAll(data);
    });
    tearDown(() async {
      await db.close();
    });
    test('aggregate the values by month and id', () async {
      List pipeline = [];
      var project = {
        '\$project': {
          'id': 1,
          'value': 1,
          'month': {
            '\$substr': ['\$day', 0, 7]
          },
        }
      };
      var group = {
        '\$group': {
          '_id': {'month': '\$month', 'id': '\$id'},
          'avgValue': {'\$avg': '\$value'}
        }
      };
      pipeline.add(project);
      pipeline.add(group);
      /// simple aggregate doesn't work!
      var res = await coll.aggregateToStream(pipeline).toList();
      expect(res, [
        {
          '_id': {'month': '2015-02', 'id': 'B'},
          'avgValue': 7.5
        },
        {
          '_id': {'month': '2015-02', 'id': 'A'},
          'avgValue': 5.5
        },
        {
          '_id': {'month': '2015-01', 'id': 'B'},
          'avgValue': 3.5
        },
        {
          '_id': {'month': '2015-01', 'id': 'A'},
          'avgValue': 1.5
        },
      ]);
    });
  });
}

main() async {
  await tests();
}
