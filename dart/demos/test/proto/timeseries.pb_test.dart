
import 'package:test/test.dart';
import 'package:fixnum/fixnum.dart';
import 'package:timezone/standalone.dart';
import 'package:demos/src/generated/timeseries.pb.dart';
import 'package:demos/src/generated/timeseries.pbgrpc.dart';


tests() async {
  group('Protobuf timeseries', () {
    var location = getLocation('US/Eastern');
    test('Create timeseries', () {
      var hourly = TimeInterval()..interval = TimeInterval_Interval.HOURLY;
      var ts = NumericTimeSeries()
        ..name = 'isone_da_congestion_4000'
        ..tzLocation = 'US/Eastern'
        ..timeInterval = hourly;
      ts.observation.add(
          NumericTimeSeries_Observation()
          ..start = Int64(TZDateTime(location, 2018, 1, 1).millisecondsSinceEpoch)
          ..value = 0.12);
      ts.observation.add(
          NumericTimeSeries_Observation()
          ..start = Int64(TZDateTime(location, 2018, 1, 1, 1).millisecondsSinceEpoch)
          ..value = 0.22);
      expect(ts.observation.length, 2);
    });
    test('LMP component', (){
      var comp = LmpComponent()..component = LmpComponent_Component.CONGESTION;
      expect(comp.component.toString(), 'CONGESTION');
    });
  });
}

main() async {
  await initializeTimeZone();
  tests();
}