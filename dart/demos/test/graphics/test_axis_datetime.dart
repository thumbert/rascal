library graphics.test_axis_datetime;

import 'package:test/test.dart';
import 'package:demos/graphics/axis_datetime_utils.dart';

test_header() {
  group('datetime axis headers', () {
    test('year', () {
      expect(getHeader(new DateTime(2015), HeaderType.YEAR), '2015');
    });
    test('month', () {
      expect(getHeader(new DateTime(2015,3), HeaderType.MONTH), 'Mar15');
    });
    test('day', () {
      expect(getHeader(new DateTime(2015,3,2), HeaderType.DAY), '2Mar15');
      expect(getHeader(new DateTime(2015,3,12), HeaderType.DAY), '12Mar15');
    });
  });
}

test_axis_datetime() {

}

main() {
  test_header();
  test_axis_datetime();
}