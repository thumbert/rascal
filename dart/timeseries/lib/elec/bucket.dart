library elec.bucket;

import 'package:timeseries/time/calendar.dart';
import 'package:timeseries/time/date.dart';

abstract class Bucket {
  final Duration H1 = new Duration(hours: 1);
  final Calendar calendar = new NercCalendar();
  String name;

  /**
   * Does this bucket contains the HourEnding dt?
   * [dt] needs to be an hour ending DateTime (0 min, 0 seconds, 0 millis)
   */
  bool containsHourEnding(DateTime dt);

  /**
   * Does this bucket contains the HourBeginning dt?
   */
  bool containsHourBeginning(DateTime dt) => containsHourEnding(dt.subtract(H1));

  /**
   * Count the number of Hour Ending hours between start and end that belong to this bucket.
   * [start] is an HourEnding DateTime
   * [end] is an HourEnding DateTime
   */
  int hoursIn(DateTime start, DateTime end) {
    int hrs = 0;
    var current = start;
    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      if (containsHourEnding(current))
        hrs += 1;
    }

    return hrs;
  }
}


class Bucket7x24 extends Bucket {
  String name = '7x24';
  bool containsHourEnding(DateTime dt) => true;
}

class Bucket7x8 extends Bucket {
  String name = '7x8';
  bool containsHourEnding(DateTime dt) {
    if (dt.hour >= 0 && dt.hour <=7)
      return true;

    return false;
  }
}

class Bucket5x16 extends Bucket {
  String name = '5x16';
  final Set<int> hours = new Set.from(new List.generate(16, (i) => i+8));
  final Set<int> days  = new Set.from(new List.generate(5, (i) => i+1));

  bool containsHourEnding(DateTime dt) {
    int dayOfWeek = dt.weekday;
    if (dayOfWeek == 6 || dayOfWeek == 7) {
      /// not the right day of the week
      return false;
    } else {
      if (!hours.contains(dt.hour)) {
        /// not at the right hour of the day
        return false;
      } else {
        if (calendar.isHoliday(new Date.fromDateTime(dt.subtract(H1))))
          /// it's a holiday
          return false;
        else
          return true;
      }
    }

    return false;
  }
}

class Bucket2x16H extends Bucket {
  String name = '2x16H';

  bool containsHourEnding(DateTime dt) {
    int dayOfWeek = dt.weekday;
    if (dayOfWeek == 6 || dayOfWeek == 7) {
      return true;
    } else {
      if (calendar.isHoliday(new Date.fromDateTime(dt.subtract(H1))))
        return true;
      else
        return false;
    }

    return false;
  }
}

class BucketOffpeak extends Bucket {
  String name = 'Offpeak';

  bool containsHourEnding(DateTime dt) {
    int dayOfWeek = dt.weekday;
    if (dayOfWeek == 6 || dayOfWeek == 7) {
      return true;
    } else {
      if (dt.hour >= 0 && dt.hour <= 7)
        return true;
      if (calendar.isHoliday(new Date.fromDateTime(dt.subtract(H1))))
        return true;
    }

    return false;
  }
}