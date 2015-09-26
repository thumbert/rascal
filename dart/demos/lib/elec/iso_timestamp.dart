library elec.iso_timestamp;

import 'package:timezone/standalone.dart';

/**
 * Convert from an ISO tuple.
 * [localDate] is 'mm/dd/yyyy'
 * [hourEnding] is of the form '01', '02', '02X', '03', ... '24'
 * [Location] is the 'America/New York' location
 * Return an hour beginning UTC DateTime
 */
DateTime parseHourEndingStamp(
    String localDate, String hourEnding, Location location) {
  // this is hour beginning
  TZDateTime res = new TZDateTime(
      location,
      int.parse(localDate.substring(6, 10)),
      int.parse(localDate.substring(0, 2)),
      int.parse(localDate.substring(3, 5)),
      int.parse(hourEnding.substring(0, 2)) - 1).toUtc();

  if (hourEnding == '02X') {
    // you are at a transition point
    res = res.add(new Duration(hours: 1));
  }

  return res;
}
