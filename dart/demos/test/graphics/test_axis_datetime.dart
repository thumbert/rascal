library graphics.test_axis_datetime;

import 'package:test/test.dart';
import 'package:demos/graphics/axis_datetime_utils.dart';

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

}

main() {
  test_header();
  test_axis_datetime();
}