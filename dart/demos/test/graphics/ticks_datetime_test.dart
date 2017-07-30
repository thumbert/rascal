library test.ticks_datetime;

import 'dart:io';
import 'package:test/test.dart';
import 'package:date/date.dart';
import 'package:timezone/standalone.dart';

import 'package:demos/graphics/ticks_datetime.dart';
import 'package:demos/graphics/tick_utils.dart';

void testTicksDateTime(){
  group('datetime ticks:', (){

    test('interval of several years, not boe/eoy', (){
      DateTime start = new DateTime(2011,3,1);
      DateTime end = new DateTime(2013,1,3);
      var ticks = defaultTicksDateTime(start, end, tickCoverType: TickCoverType.overcover);
      expect(ticks.item2.length, 4);
      var ticks2 = defaultTicksDateTime(start, end, tickCoverType: TickCoverType.undercover);
      expect(ticks2.item2.length, 2);
    });

    test('interval of 12 months, Mar11-Jan12', (){
      DateTime start = new DateTime(2011,3,1);
      DateTime end = new DateTime(2012,1,3);
      var ticks = defaultTicksDateTime(start, end, tickCoverType: TickCoverType.overcover);
      expect(ticks.item2.length, 12);
    });

    test('interval of 2 months, Dec16-Jan17', (){
      DateTime start = new DateTime(2016,12,1);
      DateTime end = new DateTime(2017,1,3);
      var ticks = defaultTicksDateTime(start, end, tickCoverType: TickCoverType.overcover);
      var dts = ticks.item2;
      expect(dts, [new DateTime(2016,12), new DateTime(2017,1), new DateTime(2017,2)]);
      expect(ticks.item2.length, 3);
    });

    test('interval of 1 month, Dec16', (){
      DateTime start = new DateTime(2016,12,1);
      DateTime end = new DateTime(2016,12,27);
      var ticks = defaultTicksDateTime(start, end, tickCoverType: TickCoverType.overcover);
      var res = new TimeIterable(new Date(2016, 12, 1), new Date(2016, 12, 27))
        .map((Date e) => e.toDateTime()).toList();
      expect(ticks.item2, res);
      expect(ticks.item2.length, 27);
    });

    test('interval of 3 days, 30Dec16-1Jan17', (){
      DateTime start = new DateTime(2016,12,30);
      DateTime end = new DateTime(2017,1,1);
      var ticks = defaultTicksDateTime(start, end, tickCoverType: TickCoverType.overcover);
      var res = new TimeIterable(new Date.fromDateTime(start), new Date.fromDateTime(end))
          .map((Date e) => e.toDateTime()).toList();
      expect(ticks.item2, res);
      expect(ticks.item2.length, 3);
    });

    test('interval of 1 day, 1Jan15', (){
      Location location = getLocation('US/Eastern');
      DateTime start = new TZDateTime(location,2015,1,1);
      DateTime end = new TZDateTime(location,2015,1,1,23,59,59);
      var ticks = defaultTicksDateTime(start, end, tickCoverType: TickCoverType.undercover);
      var res = new TimeIterable(new Hour.beginning(start), new Hour.beginning(end))
          .map((Hour e) => e.start.millisecondsSinceEpoch).toList();
      expect(ticks.item2.map((e) => e.millisecondsSinceEpoch).toList(), res);
      expect(ticks.item2.length, 24);
    });


    test('interval of 5 hours over 2 days , 31Dec16 22:00-1Jan17 2:00', (){
      Location location = getLocation('US/Eastern');
      DateTime start = new TZDateTime(location,2016,12,31,22);
      DateTime end = new TZDateTime(location,2017,1,1,2);
      var ticks = defaultTicksDateTime(start, end, tickCoverType: TickCoverType.overcover);
      var res = new TimeIterable(new Hour.beginning(start), new Hour.beginning(end))
          .map((Hour e) => e.start.millisecondsSinceEpoch).toList();
      expect(ticks.item2.map((e) => e.millisecondsSinceEpoch).toList(), res);
      expect(ticks.item2.length, 5);
    });


  });

}


main() {
  Map env = Platform.environment;
  String tzdb = env['HOME'] + '/.pub-cache/hosted/pub.dartlang.org/timezone-0.4.3/lib/data/2015b_all.tzf';
  initializeTimeZoneSync(tzdb);

  testTicksDateTime();

}