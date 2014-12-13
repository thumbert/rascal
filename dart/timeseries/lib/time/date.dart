library date;
import 'package:intl/intl.dart';
import 'package:timeseries/time/interval.dart';
import 'package:timeseries/time/month.dart';

/*
 * A Date class.  
 * Should try to remove the dependence on DateTime ...
 */
class Date extends Interval implements RegularInterval {
  
  static final DateFormat DEFAULT_FMT = new DateFormat('yyyy-MM-dd');
  static final Duration _1day = new Duration(days: 1);

  static DateFormat fmt = DEFAULT_FMT;
  
  Date(int year, int month, int day) {
    this.start = new DateTime(year, month, day);
    this.end = start.add(_1day);
    new Interval.fromStartEnd(this.start, this.end);
  }
  
  Date.fromDateTime(DateTime start) {
    this.start = start;
    assert(start == new DateTime(start.year, start.month, start.day));
    this.end = start.add(_1day);
    new Interval.fromStartEnd(this.start, this.end);
  }
  
  Date previous() => new Date.fromDateTime(this.start.subtract(_1day));
  Date next() => new Date.fromDateTime(end);
  Date add(int step) => new Date.fromDateTime(start.add(new Duration(days: step)));
  Date subtract(int step) => new Date.fromDateTime(start.subtract(new Duration(days: step)));
  
  Month currentMonth() => new Month(start.year, start.month);
  Month nextMonth() => currentMonth().add(1);
  Month previousMonth() => currentMonth().subtract(1);
  
  bool operator <(Date other)  => this.start.isBefore(other.start);
  bool operator <=(Date other) => this.start.isBefore(other.start) || this.start == other.start;
  bool operator >(Date other)  => this.start.isAfter(other.start);
  bool operator >=(Date other) => this.start.isAfter(other.start) || this.start == other.start;
  int compareTo(Date other)    => this.start.compareTo(other.start);
  
  
  List<Date> seqTo(Date other, {int step: 1}) {
    assert(other >= this);
    List res = [];
    Date aux = this;    // candidate
    while (aux <= other) {
      res.add(aux);
      aux = aux.add(step);
    }  
    
    return res;
  }
  
  List<Date> seqLength(int length, {int step: 1}) {
    assert(length > 0);
    List<Date> res = [this];
    while (res.length <= length-1) {
      res.add(res.last.add(step));
    }
    return res;
  }
  
  //set format(DateFormat fmt) =>  fmt = fmt;
  //DateFormat get format => fmt;
  
  String toString() => fmt.format(start); 
  DateTime toDateTime() => start;
}



