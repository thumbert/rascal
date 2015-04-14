library month;

import 'package:intl/intl.dart';
import 'package:timeseries/time/interval.dart';
import 'package:timeseries/time/period.dart';


/**
 * Class representing a calendar Month. 
 *  
 * 
 */
class Month extends Comparable<Month> {
  
  int _value;
  int _year;
  int _month;  // between Jan=1 to Dec=12
  
  static final DateFormat DEFAULT_FMT = new DateFormat('MMMyy');
  static final DateFormat fmt = DEFAULT_FMT;
  static final Duration H1 = new Duration(hours: 1);
  
  static Month current( {DateTime datetime} ) {
    if (datetime == null) 
      datetime = new DateTime.now();
    return new Month(datetime.year, datetime.month);
  }
    

  /**
   * Creates a new Month object.
   */
  Month(int year, int month) {
    _value = year*12 + month;
    _year  = year;
    _month = month;
  }
  
  /**
   * Creates a new Month object from a DateTime.  The Month will contain the [datetime].
   */
  Month.fromDateTime(DateTime datetime) {
     _value = datetime.year*12 + datetime.month;
     _year  = datetime.year;
     _month = datetime.month;
  }
  
  int _calcYear(int x)  => (x-1) ~/ 12;
  int _calcMonth(int x) => (x-1) % 12 + 1;
  
  
  Month previous() => new Month(_calcYear(_value-1), _calcMonth(_value-1));
  Month next() => new Month(_calcYear(_value+1), _calcMonth(_value+1));
  Month add(int months) => new Month(_calcYear(_value+months), _calcMonth(_value+months));
  Month subtract(int months) => new Month(_calcYear(_value-months), _calcMonth(_value-months));
  
  bool operator <(Month other)  => _value < other._value;
  bool operator <=(Month other) => _value <= other._value;
  bool operator >(Month other)  => _value > other._value;
  bool operator >=(Month other) => _value >= other._value;
  bool operator ==(Month other) => _value == other._value;
  int get hashCode => _value;

  int get year => _year;
  int get month => _month;
  Period get period => Period.MONTH;
  
  int compareTo(Month other) {
    int res;
    if (this._value < other._value) {
      res = -1;
    } else if (this._value == other._value){
      res = 0;
    } else {
      res = 1;
    };
    
    return res;
  }
 
  /**
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
  
  Interval toInterval() {
    DateTime start = new DateTime(year, month);
    DateTime end;
    if (month == 12) {
       end = new DateTime(year+1);
    } else {
       end = new DateTime(year, month+1);       
    }
    return new Interval.fromStartEnd(start, end);
  }
  String toString() => fmt.format(new DateTime(year, month));
  DateTime toDateTime() => new DateTime(year, month); 
}

/**
 * Return all the hours in this month.
 * TODO: how to generate the hours in different time zones ...
 */
//  List<DateTime> expandHours() {
//    List res = [];
//    var hour = start;
//    while (hour.isBefore(end)) {
//      res.add(hour);
//      hour = hour.add(H1);
//    }
//    
//    return res;
//  }