library elec.bucket;

abstract class Bucket {
  final H1 = new Duration(hours: 1);

  /// does this bucket contains the HourEnding dt?
  bool containsHourEnding(DateTime dt);

  /// does this bucket contains the HourBeginning dt?
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

abstract class _SimpleBucket extends Bucket {
  /// hour of the day, in HE convention that belong to this bucket
  Set<int> hours;
  Set<int> days;             /// day of the week, Monday==1, Sunday==7
  Set<int> seasonalMonths;
  bool includeHolidays;
  ///Calendar calendar;
}

abstract class _CompositeBucket extends Bucket {
  Set<Bucket> buckets;

  bool containsHourEnding(DateTime dt) =>
    buckets.any((Bucket bucket) => bucket.containsHourEnding(dt));

  bool containsHourBeginning(DateTime dt) =>
    buckets.any((Bucket bucket) => bucket.containsHourBeginning(dt));


}


class Bucket7x24 extends _SimpleBucket {
  final Set<int> hours = new Set.from(new List.generate(24, (i) => i));


  bool containsHourEnding(DateTime dt) => true;
}

class Bucket7x8 extends _SimpleBucket {
  final Set<int> hours = new Set.from([1,2,3,4,5,6,7,24]);
  bool containsHourEnding(DateTime dt) => hours.contains(dt.hour + 1);
}

class Bucket5x16 extends _SimpleBucket {
  final Set<int> hours = new Set.from(new List.generate(16, (i) => i+8));
  final Set<int> days  = new Set.from(new List.generate(5, (i) => i+1));

  bool containsHourEnding(DateTime dt) {
    bool res;
    int dayOfWeek = dt.weekday;
    if (dayOfWeek == 6 || dayOfWeek == 7) {
      /// you are not the right day of the week
      return false;
    } else {
      if (!hours.contains(dt.hour + 1)) {
        /// you are not the right hour of the day
        return false;
      } else {
        /// TODO: continue me
      }
    }

    return res;
  }
}

class Bucket2x16H extends _SimpleBucket {
  bool containsHourEnding(DateTime dt) {
    bool res;

    return res;
  }
}