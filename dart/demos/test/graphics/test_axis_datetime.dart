library graphics.test_axis_datetime;

import 'package:test/test.dart';
import 'package:demos/graphics/axis_datetime_utils.dart';
import 'package:demos/graphics/axis_datetime.dart';


test_header() {
  group('datetime axis headers', () {
    test('year', () {
      expect(new DateTimeAxisHeader(new DateTime(2015), HeaderType.YEAR).text, '2015');
    });
    test('month', () {
      expect(new DateTimeAxisHeader(new DateTime(2015,3), HeaderType.MONTH).text, 'Mar15');
    });
    test('day', () {
      expect(new DateTimeAxisHeader(new DateTime(2015,3,2), HeaderType.DAY).text, '2Mar15');
      expect(new DateTimeAxisHeader(new DateTime(2015,3,12), HeaderType.DAY).text, '12Mar15');
    });
  });
}

test_axis_datetime() {
  group('datetime axis ticks', () {
    test('2 months (2015-01-01 to 2015-03-01), 7 days tick separation', (){
      DateTimeAxis ax = new DateTimeAxis()
        ..start = new DateTime(2015,1)
        ..end = new DateTime(2015,3)
        ..calculateTicks();
      expect(ax.headers.map((h) => h.text).toList(), ['Jan15', 'Feb15']);
      //print(ax.ticks);
      expect(ax.ticks.length, 10);
      expect(ax.ticks.map((dt) => dt.day).toList(), [1,8,15,22,29,1,8,15,22,1]);
    });
    test('2 months (2015-01-16 to 2015-02-10), 7 days tick separation', (){
      DateTimeAxis ax = new DateTimeAxis()
        ..start = new DateTime(2015,1,16)
        ..end = new DateTime(2015,2,10)
        ..calculateTicks();
      expect(ax.headers.map((h) => h.text).toList(), ['Jan15', 'Feb15']);
      //print(ax.ticks);
      expect(ax.ticks.length, 6);
      expect(ax.ticks.map((dt) => dt.day).toList(), [15,22,29,1,8,15]);

    });
    test('4 months (2015-01-01 to 2015-05-01), 14 days tick separation', (){
      DateTimeAxis ax = new DateTimeAxis()
        ..start = new DateTime(2015,1)
        ..end = new DateTime(2015,5)
        ..calculateTicks();
      expect(ax.headers.map((h) => h.text).toList(), ['Jan15', 'Feb15', 'Mar15', 'Apr15']);
      print(ax.ticks);
      expect(ax.ticks.length, 12);
      expect(ax.ticks.map((dt) => dt.day).toList(), [1,15,29,1,15,1,15,29,1,15,29,1]);
    });
    test('6 months (2015-01-01 to 2015-07-01), 1 month tick separation', (){
      DateTimeAxis ax = new DateTimeAxis()
        ..start = new DateTime(2015,1)
        ..end = new DateTime(2015,7)
        ..calculateTicks();
      expect(ax.headers.map((h) => h.text).toList(), ['2015']);
      //print(ax.ticks);
      expect(ax.ticks.length, 7);
      expect(ax.ticks.map((dt) => dt.month).toList(), [1,2,3,4,5,6,7]);
    });
    test('6 months (2014-10-10 to 2015-03-15), 1 month tick separation', (){
      DateTimeAxis ax = new DateTimeAxis()
        ..start = new DateTime(2014,10,10)
        ..end = new DateTime(2015,3,15)
        ..calculateTicks();
      expect(ax.headers.map((h) => h.text).toList(), ['2014', '2015']);
      //print(ax.ticks);
      expect(ax.ticks.length, 7);
      expect(ax.ticks.map((dt) => dt.month).toList(), [10,11,12,1,2,3,4]);
    });
    test('15 months (2014-01-10 to 2015-03-15), 3 month tick separation', (){
      DateTimeAxis ax = new DateTimeAxis()
        ..start = new DateTime(2014,1,10)
        ..end = new DateTime(2015,3,15)
        ..calculateTicks();
      expect(ax.headers.map((h) => h.text).toList(), ['2014', '2015']);
      //print(ax.ticks);
      expect(ax.ticks.length, 6);
      expect(ax.ticks.map((dt) => dt.month).toList(), [1,4,7,10,1,4]);
    });
    test('4 years (2012-01-10 to 2015-03-15), 6 month tick separation', (){
      DateTimeAxis ax = new DateTimeAxis()
        ..start = new DateTime(2012,1,10)
        ..end = new DateTime(2015,3,15)
        ..calculateTicks();
      expect(ax.headers.map((h) => h.text).toList(), ['2012', '2013', '2014', '2015']);
      print(ax.ticks);
      expect(ax.ticks.length, 8);
      expect(ax.ticks.map((dt) => dt.month).toList(), [1,7,1,7,1,7,1,7]);
    });
  });

}

main() {
  test_header();
  test_axis_datetime();
}