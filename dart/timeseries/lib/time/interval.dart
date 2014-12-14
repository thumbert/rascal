library interval;
import 'package:timeseries/time/period.dart';
import 'package:timeseries/time/month.dart';

abstract class RegularInterval {
  RegularInterval next();
  RegularInterval previous();
  RegularInterval add(int step);
  RegularInterval subtract(int step);
  
  bool operator <(RegularInterval other); 
  bool operator <=(RegularInterval other); 
  bool operator >(RegularInterval other); 
  bool operator >=(RegularInterval other); 
  int compareTo(RegularInterval other); 
  
  List<RegularInterval> seqTo(RegularInterval other, {int step: 1});
  List<RegularInterval> seqLength(int length, {int step: 1});
  
  
}

/**
 * An Interval class to represent the time interval between [[start] and [end]).  
 * Start and end DateTimes need to be different.
 */
class Interval {
  DateTime start;
  DateTime end;
  
  Interval(): super() {}
  
  Interval.fromStartEnd(DateTime start, DateTime end): super() {
    assert(start.isBefore(end));
    this.start = start;
    this.end = end;
  }
  
  bool operator ==(Interval other) =>
    other != null && other.start == start && other.end == end;
  
  
  bool isAfter(Interval other) {
    return start.isAfter(other.end) || start.isAtSameMomentAs(other.end);
  }
  
  bool isBefore(Interval other) {
    return end.isBefore(other.start) || end.isAtSameMomentAs(other.start);
  }
   
  /**
   * Split this interval into subintervals given the Period period. 
   * Retuns an empty list if start + duration > end.
   * TODO:  How to make this return an iterable?!  That would be nice.  
   */ 
  List split(Period period, Function f(Interval interval)) {
    var startChunk = start;
    var endChunk = period.next(start);
    List res = [];
    while (endChunk.isBefore(end) || endChunk == end) {
      res.add( f(new Interval.fromStartEnd(startChunk, endChunk)) );
      startChunk = endChunk;
      endChunk = period.next(startChunk);
    }
    
    return res;
  }
  
  
  List<Month> splitMonths() {
    var mon = Month.current(datetime: start);
    List res = [mon];
    while (mon <= Month.current(datetime: end)) {
      mon = mon.next();
      res.add(mon);
    }
    
    return res;
  }
  
  
  String toString() => "$start/$end";
  
}





