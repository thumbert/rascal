library msgpack_test;

/**
 * Compare how much smaller a serialization with msgpack is compared with JSON.
 * How about compressing it first?
 *
 */

import 'dart:io';
import 'package:msgpack/msgpack.dart';

// load one day of DAM prices
List<Map> loadData() {
  Map env = Platform.environment;
  File file = new File(env['HOME'] + '/Downloads/Archive/DA_LMP/WW_DALMP_ISO_20150306.csv');
  List keys = ['hourEnding', 'ptid', 'congestionComponent'];

  List<Map> data = file.readAsStringSync()
    .split('\n')
    .map((String row) => row.split(','))
    .where((List row) => row[0] == '"D"')
    .map((List row) {
      String dt = unquote(row[1]);
      return new Map.fromIterables(keys, [
        new DateTime(int.parse(dt.substring(6,10)), int.parse(dt.substring(0,2)), int.parse(dt.substring(3,5)), int.parse(unquote(row[2]))),
        int.parse(unquote(row[3])),
        num.parse(row[8])
      ]);
  }).toList();
  data.take(5).forEach((e)=>print(e));

  return data;
}

String unquote(String x) => x.substring(1,x.length-1);

class CongMessage extends Message {
  int dt;
  int ptid;
  num congcomponent;

  CongMessage(this.dt, this.ptid, this.congcomponent);

  static CongMessage fromList(List f) => new CongMessage(f[0], f[1], f[2]);

  List toList() => [dt, ptid, congcomponent];
}

class TestMessage extends Message {
  int a;
  String b;
  Map<int, String> c;

  TestMessage(this.a, this.b, this.c);

  static TestMessage fromList(List f) => new TestMessage(f[0], f[1], f[2]);

  List toList() => [a, b, c];
}



main() {

  List<Map> data = loadData();

  Packer packer = new Packer();

  var c1 = new CongMessage(data[0]['hourEnding'].millisecondsSinceEpoch,
    data[0]['ptid'], data[0]['congestionComponent']);

  Message message = new TestMessage(1, "one", {2: "two"});
  List<int> encoded = packer.pack(message);

//  var encoded = packer.pack(c1);
  print(encoded.length);


}