@TestOn("vm")

library datetime.utils_test;

import 'package:test/test.dart';
import 'package:demos/datetime/utils.dart';

tests() {

  test('Current month', () {
    expect(currentMonth(new DateTime(2014,1,14)).toString(), "2014-01-01 00:00:00.000");
  });
  test('Next month', () {
    expect(nextMonth(new DateTime(2014,1,14)).toString(), "2014-02-01 00:00:00.000");
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


}



main() => tests();

