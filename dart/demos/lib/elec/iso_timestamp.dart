library elec.iso_timestamp;

import 'package:timezone/standalone.dart';

/**
 * Convert from an ISO tuple.
 * [localDate] is 'mm/dd/yyyy'
 * [hourEnding] is of the form '01', '02', '02X', '03', ... '24'
 * [Location] is the 'America/New York' location
 * Return an hour ending UTC DateTime
 *
 */
DateTime parseHourEndingStamp(String localDate, String hourEnding, {Location location}) {

  int year = int.parse(localDate.substring(6,10));
  int month = int.parse(localDate.substring(0,2));
  int day = int.parse(localDate.substring(3,5));

  int hourBeginning = int.parse(hourEnding.substring(0,2))-1;

  DateTime dt = new TZDateTime(location, year, month, day);

}