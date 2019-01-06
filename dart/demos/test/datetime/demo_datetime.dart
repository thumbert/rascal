library test.format_datetime;

import 'package:intl/intl.dart';
import 'package:test/test.dart';
import 'package:timezone/standalone.dart';


Location location = getLocation('US/Eastern');

/**
 * Example of parsing different formats
 */
parsingDateTimes() {

  test('parse 2014-01-01 09:00:00 directly', () {
    var dt2 = DateTime.parse("2014-01-01 09:00:00");
    expect(dt2.toString(), '2014-01-01 09:00:00.000');
    //print(dt2.isUtc);        // false
    //print(dt2.timeZoneName); // "EST"
  });

//  var fmt1 = new DateFormat("yyyy-MM-ddTHH");
//  print(fmt1.parse("2015-01-01T10").toString() == "2015-01-01 10:00:00.000");
//
//  var fmt2 = new DateFormat("yyyy-MM-ddTHH:mm:ss");
//  print(fmt2.parse("2015-01-01T10:12:34").toString() == "2015-01-01 10:12:34.000");

  test('parse yyyy-MM-ddTHH:mm:ss.SSS', (){
    var fmt3 = new DateFormat("yyyy-MM-ddTHH:mm:ss.SSS");
    expect(fmt3.parse("2015-01-01T10:12:34.389").toString(), "2015-01-01 10:12:34.389");
  });

  test('parse yyyy-MM-ddTHH:mm:ss.SSS-ZZZZ with offset is parsed by TZDateTime.parse()', (){
    // not working with intl package Dart does not understand offsets.
    // Everything gets parsed into local time!
    TZDateTime dt = TZDateTime.parse(location, '2015-03-30T10:00:00.000-04:00');
    expect(dt.timeZoneOffset, new Duration(hours: -4));
    expect(dt.hour, 10);
  });


  //print(fmt1.parse("2015-01-01T00:00:00.000-05:00"));

}


formatDateTimes() {
  DateFormat fmt = new DateFormat('yyyyMMdd');
  print(fmt.format(new DateTime(2015,1,3)));  // '20150103'

}


main() async {
  await initializeTimeZone();

  parsingDateTimes();

  //final DateFormat fmt = new DateFormat("yyyy-MM-ddTHH:00:00.000-ZZZZ");


//  var fmt4 = new DateFormat("yyyy-MM-ddTHH:mm:ss.SSS-ZZZZ");
//  print(fmt4.parse("2015-01-01T10:00:00.000-0600",false));



//  var dt = new DateTime(2014,1,1,9);
//  print(dt.toString());  // 2014-01-01 09:00:00.000
//
//  var fmt = new DateFormat("dMMMyy");
//  print(fmt.format(dt2));  //1Jan14
//
//  var dt3 = DateTime.parse("2014-01-01");
//  print(dt3); // 2014-01-01 00:00:00.000


}