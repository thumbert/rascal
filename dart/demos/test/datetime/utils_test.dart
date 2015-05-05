@TestOn("vm")

library datetime.utils_test;

import 'package:test/test.dart';
import 'package:demos/datetime/utils.dart';

tests() {

  test('Current month', () {
    expect(currentMonth(new DateTime(2014,1,14)).toString(), "2014-01-01 00:00:00.000");
  });
  test('Next day', () {
    expect(nextDay(new DateTime(2014,1,14,10)), new DateTime(2014,1,15));
  });
  test('Next month', () {
    expect(nextMonth(new DateTime(2014,1,14)).toString(), "2014-02-01 00:00:00.000");
  });
  test('Add months', () {
    expect(addMonths(new DateTime(2014,1)), new DateTime(2014,2));
    expect(addMonths(new DateTime(2014,1), step: 3), new DateTime(2014,4));
    expect(addMonths(new DateTime(2014,1), step: -3), new DateTime(2013,10));
    expect(addMonths(new DateTime(2014,1,10), step: 0), new DateTime(2014,1));
  });
  test('Previous month', () {
    expect(previousMonth(new DateTime(2014,1,14)).toString(), "2013-12-01 00:00:00.000");
  });
  test('Is begining of day?', (){
    expect(isBeginningOfDay(new DateTime(2015,1,11)), true);
    expect(isBeginningOfDay(new DateTime(2015,1,2,5)), false);
    expect(isBeginningOfDay(new DateTime(2015,1,1,1)), false);
  });
  test('Is begining of month?', (){
    expect(isBeginningOfMonth(new DateTime(2015,1,1)), true);
    expect(isBeginningOfMonth(new DateTime(2015,1,2)), false);
    expect(isBeginningOfMonth(new DateTime(2015,1,1,1)), false);
  });
  test('Is begining of year?', (){
    expect(isBeginningOfYear(new DateTime(2015,1,1)), true);
    expect(isBeginningOfYear(new DateTime(2015,1,2)), false);
    expect(isBeginningOfYear(new DateTime(2015,1,1,1)), false);
  });
  test('seqBy', (){
    var aux = seqBy(new DateTime(2015,1,1), new DateTime(2015,1,1,4), new Duration(hours: 1));
    //aux.forEach((e) => print(e));
    expect(aux.length, 5);
  });
  test('seqMonths', (){
    var aux = seqMonths(new DateTime(2015,1,4), new DateTime(2015,10));
    expect(aux.length, 10);
  });
  test('seqDays', (){
    var aux = seqDays(new DateTime(2015,1,30), new DateTime(2015,2,2));
    expect(aux.length, 4);
  });
  test('coverHours, 1Jan15, 8 hours', (){
    var aux = coverHours(new DateTime(2015,1), new DateTime(2015,1,2), 8);
    expect(aux, [new DateTime(2015,1), new DateTime(2015,1,1,8), new DateTime(2015,1,1,16), new DateTime(2015,1,2)]);
  });
  test('coverHours, 1Jan15-2Jan15 7:00, 5 hours', (){
    var aux = coverHours(new DateTime(2015,1), new DateTime(2015,1,2,7), 5);
    print(aux);
    expect(aux, [new DateTime(2015,1), new DateTime(2015,1,1,5), new DateTime(2015,1,1,10), new DateTime(2015,1,1,15),
    new DateTime(2015,1,1,20), new DateTime(2015,1,2), new DateTime(2015,1,2,5), new DateTime(2015,1,2,10)]);
  });
  test('coverDays, Jan15, 14 days', (){
    var aux = coverDays(new DateTime(2015,1), new DateTime(2015,2), 14);
    expect(aux, [new DateTime(2015,1), new DateTime(2015,1,15), new DateTime(2015,1,29), new DateTime(2015,2)]);
  });
  test('coverDays, 10Jan15 - 5Feb15, 7 days', (){
    var aux = coverDays(new DateTime(2015,1,10), new DateTime(2015,2,5), 7);
    expect(aux, [new DateTime(2015,1,8), new DateTime(2015,1,15),
      new DateTime(2015,1,22), new DateTime(2015,1,29), new DateTime(2015,2), new DateTime(2015,2,8)]);
  });
  test('coverMonths, 10Jan15 - 5Feb15, 1 month step', (){
    var aux = coverMonths(new DateTime(2015,1,10), new DateTime(2015,2,5), 1);
    expect(aux, [new DateTime(2015,1), new DateTime(2015,2), new DateTime(2015,3)]);
  });
  test('coverMonths, 1Jan15 - 1Mar15, 2 months step', (){
    var aux = coverMonths(new DateTime(2015,1), new DateTime(2015,3), 2);
    expect(aux, [new DateTime(2015,1), new DateTime(2015,3)]);
  });
  test('coverMonths, 1Jan15 - 10Mar15, 2 months step', (){
    var aux = coverMonths(new DateTime(2015,1), new DateTime(2015,3,10), 2);
    //print(aux);
    expect(aux, [new DateTime(2015,1), new DateTime(2015,3), new DateTime(2015,5)]);
  });
}



main() => tests();

