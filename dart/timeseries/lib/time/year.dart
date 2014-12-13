library year;
import 'package:intl/intl.dart';
import 'package:timeseries/time/interval.dart';
import 'package:timeseries/time/month.dart';

/**
 * Class representing a calendar year.
 */
class Year extends Interval implements RegularInterval {
  
  int _value;
  
  static final DateFormat fmt = new DateFormat('yyyy');
  
  static Year current({DateTime datetime}) {
    if (datetime == null) 
       datetime = new DateTime.now();
     return new Year(datetime.year);
  } 
  
  Year(int year) {
    _value = year;
    this.start = new DateTime(year);
    this.end = new DateTime(year+1);
    new Interval.fromStartEnd(this.start, this.end);
  }
  
  Year.fromDateTime(DateTime start) {
    assert(start == new DateTime(start.year));
    _value = start.year;
    this.start = new DateTime(_value);
    this.end = new DateTime(_value+1);
    new Interval.fromStartEnd(this.start, this.end);
  }
  
  List<Month> splitMonths() {
    List<Month> res = new List(12);
    res[0] = new Month.fromDateTime(start);
    for (int m=1; m<=11; m++) {
      res[m] = res[m-1].next();
    }
    
    return res;
  }
  
  Year previous() => new Year(start.year-1);
  Year next() => new Year(start.year+1);
  Year add(int years) => new Year(start.year + years);
  Year subtract(int years) => new Year(start.year - years);
  
  bool operator <(Year other)  => _value < other._value;
  bool operator <=(Year other) => _value <= other._value;
  bool operator >(Year other)  => _value > other._value;
  bool operator >=(Year other) => _value >= other._value;
  bool operator ==(Year other) => _value == other._value;
  
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
  
  
  String toString() => fmt.format(start);
}
