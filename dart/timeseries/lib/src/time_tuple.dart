library time_tuple;

import 'package:tuple/tuple.dart';

class TimeTuple<K> {
  Tuple2 _tuple;

  TimeTuple(DateTime time, K value) {
    _tuple = new Tuple2(time, value);
  }

  DateTime get time => _tuple.item1;
  K get value => _tuple.item2;

  bool operator ==(TimeTuple other) => other != null && time == other.time && value == other.value;
  int get hashCode => _tuple.hashCode;
}
