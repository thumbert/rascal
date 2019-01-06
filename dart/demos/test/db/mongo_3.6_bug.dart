


import 'package:mongo_dart/mongo_dart.dart';
import 'package:test/test.dart';

aggTest() async {
  group('mongo 3.6.2 bug', (){
    List data = [
      {'type': 'A', 'date': '2017-01-01'},
      {'type': 'AA', 'date': '2017-01-01'},
      {'type': 'B', 'date': '2017-01-02'},
      {'type': 'D', 'date': '2017-01-04'},
      {'type': 'C', 'date': '2017-01-03'},
    ];

    Db db = new Db('mongodb://127.0.0.1/test');
    DbCollection coll = db.collection("agg_bug");

    setUp(() async {
      await db.open();
      await coll.insertAll(data);
    });
    tearDown(() async {
      await coll.remove({});
      await db.close();
    });
    test('check data', () async {
      var res = await coll.count();
      expect(res, 5);
    });
    test('find max date', () async {
      List pipeline = [];
      pipeline.add({'\$group': {
        '_id': 0,
        'lastDay': {'\$max': '\$date'}}});
      Map res = await coll.aggregate(pipeline);
      var lastDay = res['result'][0]['lastDay'];
      expect(lastDay, '2017-01-04');
    });
  });
}


main() async {

  await aggTest();

}
