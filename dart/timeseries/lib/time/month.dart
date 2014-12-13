library month;

import 'package:intl/intl.dart';
import 'package:timeseries/time/interval.dart';
import 'package:timeseries/time/period.dart';


/**
 * Class representing a calendar Month. 
 *  
 * 
 */
class Month extends Interval implements RegularInterval {
  
  int _value;
  int _year;
  int _month;
  
  static final DateFormat fmt = new DateFormat('MMMyy');
  static final Duration H1 = new Duration(hours: 1);
  
  static Month current( {DateTime datetime} ) {
    if (datetime == null) 
      datetime = new DateTime.now();
    return new Month(datetime.year, datetime.month);
  }
    

  /*
   * Creates a new Month object.
   */
  Month(int year, int month) {
    this.start = new DateTime(year, month);
    if (month == 12) {
      end = new DateTime(year+1);
    } else {
      end = new DateTime(year, month+1);       
    }
    _value = year*12 + month;
    _year  = year;
    _month = month;
    new Interval.fromStartEnd(start, end);
  }
  
  /*
   * Creates a new Month object from a DateTime.  The [start] needs to 
   * be a beginning of the month DateTime.  
   */
  Month.fromDateTime(DateTime start) {
    this.start = start;
     assert(start == new DateTime(start.year, start.month));
     if (start.month == 12) {
       end = new DateTime(start.year+1);
     } else {
       end = new DateTime(start.year, start.month+1);       
     }
     _value = start.year*12 + start.month;
     _year  = year;
     _month = month;
     new Interval.fromStartEnd(start, end);   
  }
  
  Month previous() => new Month((_value-1)~/12, (_value-1)%12);
  Month next() => new Month.fromDateTime(end);
  Month add(int months) => new Month((_value -1 +months)~/12, (_value -1 + months)%12 + 1);
  Month subtract(int months) => new Month((_value -1 - months)~/12, (_value -1 - months)%12 + 1);
  
  bool operator <(Month other)  => _value < other._value;
  bool operator <=(Month other) => _value <= other._value;
  bool operator >(Month other)  => _value > other._value;
  bool operator >=(Month other) => _value >= other._value;
  bool operator ==(Month other) => _value == other._value;
  
  int get year => _year;
  int get month => _month;
  Period get period => Period.MONTH;
  
  int compareTo(Month other) {
    int res;
    if (this.start.isBefore(other.start)) {
      res = -1;
    } else if (this.start == other.start){
      res = 0;
    } else {
      res = 1;
    };
    
    return res;
  }
 
  /*
   * Create a Month sequence starting with this month and ending at 
   * [other].  The [step] can be used to skip months if needed. 
   */
  List<Month> seqTo(Month other, {int step: 1}) {
    assert(other >= this);
    List res = [];
    Month aux = this;    // candidate
    while (aux <= other) {
      res.add(aux);
      aux = aux.add(step);
    }  
    
    return res;
  }
  
  /**
   * Create a Month sequence of given [length] starting with this month.  
   * The [step] can be used to skip months if needed.    
   */
  List<Month> seqLength(int length, {int step: 1}) {
    List<Month> res = [this];
    while (res.length <= length-1) {
      res.add(res.last.add(step));
    }
    return res;
  }
  
  /**
   * Return all the hours in this month.
   * TODO: how to generate the hours in different time zones ...
   */
  List<DateTime> expandHours() {
    List res = [];
    var hour = start;
    while (hour.isBefore(end)) {
      res.add(hour);
      hour = hour.add(H1);
    }
    
    return res;
  }
  
  String toString() => fmt.format(start);
  DateTime toDateTime() => start;
  
}
