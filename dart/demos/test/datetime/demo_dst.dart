library demo_dst;


makeData(DateTime start) {
  List<Map> res = [];

  var current = start;
  for (int i = 0; i < 5; i++) {
    res.add({
        'toString': current,
        'tz': current.timeZoneName,
        'toUtc.toString': current.toUtc(),
        'millis': current.millisecondsSinceEpoch
    });
    current = current.add(new Duration(minutes: 60));
  }

  return res;
}

main() {

  List data1 = makeData(new DateTime(2015, 3, 8));  // skip hour 02:00:00
  List data2 = makeData(new DateTime(2015, 11, 1)); // have 2
  List data = new List.from(data1)
    ..addAll(data2);
  data.forEach((e) => print(e));
}

//{toString: 2015-03-08 00:00:00.000, tz: EST, toUtc.toString: 2015-03-08 05:00:00.000Z, millis: 1425790800000}
//{toString: 2015-03-08 01:00:00.000, tz: EST, toUtc.toString: 2015-03-08 06:00:00.000Z, millis: 1425794400000}
//{toString: 2015-03-08 03:00:00.000, tz: EDT, toUtc.toString: 2015-03-08 07:00:00.000Z, millis: 1425798000000}
//{toString: 2015-03-08 04:00:00.000, tz: EDT, toUtc.toString: 2015-03-08 08:00:00.000Z, millis: 1425801600000}
//{toString: 2015-03-08 05:00:00.000, tz: EDT, toUtc.toString: 2015-03-08 09:00:00.000Z, millis: 1425805200000}
//{toString: 2015-11-01 00:00:00.000, tz: EDT, toUtc.toString: 2015-11-01 04:00:00.000Z, millis: 1446350400000}
//{toString: 2015-11-01 01:00:00.000, tz: EDT, toUtc.toString: 2015-11-01 05:00:00.000Z, millis: 1446354000000}
//{toString: 2015-11-01 01:00:00.000, tz: EST, toUtc.toString: 2015-11-01 06:00:00.000Z, millis: 1446357600000}
//{toString: 2015-11-01 02:00:00.000, tz: EST, toUtc.toString: 2015-11-01 07:00:00.000Z, millis: 1446361200000}
//{toString: 2015-11-01 03:00:00.000, tz: EST, toUtc.toString: 2015-11-01 08:00:00.000Z, millis: 1446364800000}
