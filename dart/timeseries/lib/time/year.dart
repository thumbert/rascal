library year;

import 'package:timeseries/time/interval.dart';
import 'package:timeseries/time/month.dart';

/**
 * Class representing a calendar year.
 */
class Year extends Comparable<Year> {  

  int _value;
    
  static Year current({DateTime datetime}) {
    if (datetime == null) 
       datetime = new DateTime.now();
     return new Year(datetime.year);
  } 
  
  Year(int year) {
    _value = year;
  }
  
  /**
   * Get the year that contains this datetime.  The datetime does not need to be the 
   * beginning of the year. 
   */
  Year.fromDateTime(DateTime datetime) {
    _value = datetime.year;
  }
  
  int get value => _value;
  
  List<Month> splitMonths() {
    List<Month> res = new List(12);
    res[0] = new Month.fromDateTime(new DateTime(_value));
    for (int m=1; m<=11; m++) {
      res[m] = res[m-1].next();
    }
    
    return res;
  }
  
  Year previous() => new Year(_value-1);
  Year next() => new Year(_value+1);
  Year add(int years) => new Year(_value + years);
  Year subtract(int years) => new Year(_value - years);
  
  bool operator <(Year other)  => _value < other._value;
  bool operator <=(Year other) => _value <= other._value;
  bool operator >(Year other)  => _value > other._value;
  bool operator >=(Year other) => _value >= other._value;
  bool operator ==(Year other) => (other != null) &&_value == other._value;
  int get hashCode => _value;

  int compareTo(Year other) {
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

  bool isLeapYear() => _value % 4 == 0 && (_value % 100 != 0 || _value % 400 == 0);  
  
  List<Year> seqTo(Year other, {int step: 1}) {
    assert(other >= this);
    List res = [];
    var aux = this;    // candidate
    while (aux <= other) {
      res.add(aux);
      aux = aux.add(step);
    }  
    
    return res;
  }
  
  
  List<Year> seqLength(int length, {int step: 1}) {
    List<Year> res = [this];
    while (res.length <= length-1) {
      res.add(res.last.add(step));
    }
    return res;
  }
 
  
  int toInt() => _value;
  Interval toInterval() => new Interval.fromStartEnd(new DateTime(_value), new DateTime(_value+1));
  
  String toString() => _value.toString();
}
