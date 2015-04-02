library time.interval;

class Interval {
  DateTime start;
  DateTime end;
  Interval(DateTime this.start, DateTime this.end){
    ///assert(!start.isAfter(end));
  }

  toString() => "${start.toString()} -> ${end.toString()}";

  static final Duration H1 = new Duration(hours: 1);

  static List<Interval> contiguosHours(List<DateTime> hours) {
    List<Interval> res = [];

    DateTime start = hours.first;
    DateTime end = hours.first;
    DateTime nextHour = start.add(H1);
    for (var hour in hours.skip(1)) {
      if (nextHour != hour) {
        /// you have a gap
        res.add(new Interval(start, end));
        start = hour;
      }
      nextHour = hour.add(H1);
      end = hour;
    }
    res.add(new Interval(start, end));


    return res;
  }
}