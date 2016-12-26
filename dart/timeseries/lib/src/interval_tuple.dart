library interval_tuple;

import 'package:tuple/tuple.dart';
import 'package:date/date.dart';

class IntervalTuple<K> {
  Tuple2 _tuple;


  IntervalTuple(Interval interval, K value) {
    _tuple = new Tuple2(interval, value);
  }


  Interval get interval => _tuple.item1;
  K get value => _tuple.item2;


  String toString() => '$interval -> ${_tuple.item2}';


  bool operator ==(IntervalTuple other) => other != null && interval == other.interval && value == other.value;
  int get hashCode => _tuple.hashCode;
}


