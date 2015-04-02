library interval_test;

import 'package:unittest/unittest.dart';
import 'package:cviewer/time/interval.dart';

interval_test() {
  test("create interval", () {
    var ival = new Interval(new DateTime(2015), new DateTime(2015,1,3));
    expect(ival.toString(), '2015-01-01 00:00:00.000 -> 2015-01-03 00:00:00.000');
  });

  solo_test('test contiguos hours', (){
    List ind = [1,  3,4,5,6,  10,  12,13,14];
    List hours = ind.map( (i) => new DateTime(2015).add(new Duration(hours: i))).toList();
    Interval.contiguosHours(hours).forEach((i) => print(i));
  });


}


main() => interval_test();