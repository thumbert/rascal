library graphics.test_axis_datetime;

import 'package:test/test.dart';
import 'package:demos/graphics/axis_datetime_utils.dart';
import 'package:demos/graphics/axis_datetime.dart';


test_header() {
  group('datetime axis headers', () {
    test('year', () {
      expect(new Header(new DateTime(2015), HeaderType.YEAR).text, '2015');
    });
    test('month', () {
      expect(new Header(new DateTime(2015,3), HeaderType.MONTH).text, 'Mar15');
    });
    test('day', () {
      expect(new Header(new DateTime(2015,3,2), HeaderType.DAY).text, '2Mar15');
      expect(new Header(new DateTime(2015,3,12), HeaderType.DAY).text, '12Mar15');
    });
  });
}

test_axis_datetime() {
  group('datetime axis ticks', () {
    test('2 monthly headers, daily ticks (2015-01-01 to 2015-03-01), 7 days ticks', (){
      DateTimeAxis ax = new DateTimeAxis()
        ..start = new DateTime(2015,1)
        ..end = new DateTime(2015,3)
        ..calculateTicks();
      expect(ax.headerLabels, ['Jan15', 'Feb15']);
      print(ax.ticks);
      expect(ax.ticks.length, 9);
    });
    test('2 monthly headers, daily ticks (2015-01-16 to 2015-02-10), 7 days ticks', (){
      DateTimeAxis ax = new DateTimeAxis()
        ..start = new DateTime(2015,1,16)
        ..end = new DateTime(2015,2,10)
        ..calculateTicks();
      expect(ax.headerLabels, ['Jan15', 'Feb15']);
      print(ax.ticks);
      expect(ax.ticks.length, 5);
    });

    test('4 monthly headers (2015-01-01 to 2015-05-01), 14 days ticks', (){
      DateTimeAxis ax = new DateTimeAxis()
        ..start = new DateTime(2015,1)
        ..end = new DateTime(2015,5)
        ..calculateTicks();
      expect(ax.headerLabels, ['Jan15', 'Feb15', 'Mar15', 'Apr15']);
      print(ax.ticks);
      expect(ax.ticks.length, 9);
    });

  });

}

main() {
  test_header();
  test_axis_datetime();
}