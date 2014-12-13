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
 * An Interval class.  
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
  
  bool operator ==(Interval other) {
    return (other.start == start) && (other.end == end);
  }
  
  bool isAfter(Interval other) {
    return start.isAfter(other.end) || start.isAtSameMomentAs(other.end);
  }
  
  bool isBefore(Interval other) {
    return end.isBefore(other.start) || end.isAtSameMomentAs(other.start);
  }
   
  /**
   * Split this interval into subintervals given the Period period. 
   * Retuns an empty list if start + duration > end. 
   */
//  List<Interval> split(Period period) {
//    return splitFun(period, (x) => x);
//  }
  
  List split(Period period, Function f(Interval interval)) {
    var startChunk = start;
    var endChunk = period.add(start);
    List res = [];
    while (endChunk.isBefore(end) || endChunk == end) {
      res.add( f(new Interval.fromStartEnd(startChunk, endChunk)) );
      startChunk = endChunk;
      endChunk = period.add(startChunk);
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





