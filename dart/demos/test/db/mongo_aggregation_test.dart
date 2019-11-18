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
      {'day': '2015-02-07', 'id': 'B', 'value': 8},
    ];
    var db = Db('mongodb://127.0.0.1/test');
    var coll = db.collection("timeseries");
    setUp(() async {
      await db.open();
      await coll.drop();
      await coll.insertAll(data);
    });
    tearDown(() async {
      await db.close();
    });
    test('calculate average values by month and id', () async {
      var pipeline = [
        {
          '\$project': {
            'id': 1,
            'value': 1,
            'month': {
              '\$substr': ['\$day', 0, 7]
            },
          }
        },
        {
          '\$group': {
            '_id': {'month': '\$month', 'id': '\$id'},
            'avgValue': {'\$avg': '\$value'}
          }
        },
      ];
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
    test('get last document with date < asOfDate for a given id', () async {
      /// so for id: B, if asOfDate = '2015-02-06' return
      /// {'day': '2015-02-01', 'id': 'B', 'value': 7},
      /// This is useful to have for a marks database.
      var pipeline = [
        {
          '\$match': {
            'id': {'\$eq': 'B'},
            'day': {'\$lte': '2015-02-06'},
          }
        },
        {
          '\$sort': {'day': -1},
        },
        {
          '\$limit': 1,
        },
      ];
      var aux = await coll.aggregateToStream(pipeline).toList();
      expect(aux.first['day'], '2015-02-01');
    });
  });
}

main() async {
  await tests();
}
