library datetime.utils_test;

import 'package:unittest/unittest.dart';
import 'package:demos/datetime/utils.dart';

tests() {

  test('Current month', () {
    expect(currentMonth(asOf: new DateTime(2014,1,14)).toString(), "2014-01-01 00:00:00.000");
  });
  test('Next month', () {
    expect(nextMonth(asOf: new DateTime(2014,1,14)).toString(), "2014-02-01 00:00:00.000");
  });
  test('Previous month', () {
    expect(previousMonth(asOf: new DateTime(2014,1,14)).toString(), "2013-12-01 00:00:00.000");
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
    expect(aux.length, 4);
  });


}



main(){
  tests();

}
