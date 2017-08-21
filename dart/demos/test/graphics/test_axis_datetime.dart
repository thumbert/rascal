library graphics.test_axis_datetime;

import 'package:test/test.dart';
import 'package:demos/graphics/ticks_datetime.dart';


testTicksDateTime() {
  group('default datetime axis ticks', (){
    test('1 day', () {
      var start = new DateTime(2015,1,1);
      var end = new DateTime(2015,1,2);
      var freq = getTickFrequency(start, end);
      expect(freq, DateTimeTickFrequency.hour);
      var aux = defaultTicksDateTime(start, end);
      expect(aux.item1, DateTimeTickFrequency.hour);
      expect(aux.item2.length, 5);
      expect((aux.item2 as List)[1], new DateTime(2015,1,1,6));
    });
    test('1 day and 2 hours', (){
      var aux = defaultTicksDateTime(new DateTime(2015,1,1), new DateTime(2015,1,2,2));
      expect(aux.item1, DateTimeTickFrequency.hour);
      expect(aux.item2.length, 5);
      expect((aux.item2 as List)[1], new DateTime(2015,1,1,6));
      expect((aux.item2 as List).last, new DateTime(2015,1,2));
    });
    test('2 days', (){
      var aux = defaultTicksDateTime(new DateTime(2015,1,1), new DateTime(2015,1,3));
      expect(aux.item1, DateTimeTickFrequency.day);
      expect(aux.item2.length, 3);
      expect((aux.item2 as List)[1], new DateTime(2015,1,2));
      expect((aux.item2 as List).last, new DateTime(2015,1,3));
    });
    test('6 days', (){
      var aux = defaultTicksDateTime(new DateTime(2015,1,1), new DateTime(2015,1,6));
      expect(aux.item1, DateTimeTickFrequency.day);
      expect(aux.item2.length, 6);
      expect((aux.item2 as List)[1], new DateTime(2015,1,2));
      expect((aux.item2 as List).last, new DateTime(2015,1,6));
    });
    test('20 days', (){
      var aux = defaultTicksDateTime(new DateTime(2015,1,1), new DateTime(2015,1,20));
      expect(aux.item1, DateTimeTickFrequency.day);
      expect(aux.item2.length, 4);
      expect((aux.item2 as List)[1], new DateTime(2015,1,6));
      expect((aux.item2 as List).last, new DateTime(2015,1,16));
    });
    test('62 days', (){
      var aux = defaultTicksDateTime(new DateTime(2017,1,15), new DateTime(2017,3,18));
      expect(aux.item1, DateTimeTickFrequency.month);
      print(aux.item2);
      expect(aux.item2.length, 2);
      expect((aux.item2 as List)[1], new DateTime(2015,2,1));
      expect((aux.item2 as List).last, new DateTime(2015,3,1));
    });


  });
}

main() {
  testTicksDateTime();
}



//test_header() {
//  group('datetime axis headers', () {
//    test('year', () {
//      expect(new DateTimeAxisHeader(new DateTime(2015), HeaderType.YEAR).text, '2015');
//    });
//    test('month', () {
//      expect(new DateTimeAxisHeader(new DateTime(2015,3), HeaderType.MONTH).text, 'Mar15');
//    });
//    test('day', () {
//      expect(new DateTimeAxisHeader(new DateTime(2015,3,2), HeaderType.DAY).text, '2Mar15');
//      expect(new DateTimeAxisHeader(new DateTime(2015,3,12), HeaderType.DAY).text, '12Mar15');
//    });
//  });
//}
