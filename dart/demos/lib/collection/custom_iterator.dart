library custom_iterator;

import 'dart:collection';

class Obs<T,E> {
  T index;
  E value;
  Obs(this.index, this.value);
}

class TimeSeries extends Object with IterableMixin {
  List obs;
  Iterator get iterator => obs.iterator;
  
  TimeSeries(List obs) {
    this.obs = obs;
  }
}