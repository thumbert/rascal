import 'dart:collection';
//import 'range.dart';


List<DateTime> seq(DateTime startDt, DateTime endDt, Duration step) {
  List<DateTime> index = [];
  
  while (startDt.compareTo(endDt) <= 0) {
    index.add( startDt );
    startDt = startDt.add( step );
  }

  return index;
}

int comparableBinarySearch(List<Comparable> list, Comparable key) {
  int min = 0;
  int max = list.length;
  while (min < max) {
    int mid = min + ((max - min) >> 1);
    var element = list[mid];
    int comp = element.compareTo(key);
    if (comp == 0) return mid;
    if (comp < 0) {
      min = mid + 1;
    } else {
      max = mid;
    }
  }
  return -1;
}



class Obs<K,V> extends Object with Comparable<K> {
  K index;
  V value;
  
  Obs(this.index, this.value);
  
  bool operator ==(Obs other) => index == other.index && value == other.value; 
  
  toString() => 
    "{" + index.toString() + ", " + value.toString() + "}";
}



/*
 * Make this an Iterable 
 * http://japhr.blogspot.com/2013/08/simple-iterable-classes-in-dart.html
 */
class TimeSeries<K,V> extends ListBase<Obs<K,V>> { 
  List<Obs> data = [];

  TimeSeries();
  
  TimeSeries.fill(List index, value) {
    data = new List.generate(index.length, (i) => new Obs(index[i], value), growable: true); 
  }
  
  int get length => data.length;
  void set length(int i) {data.length = i;}
  operator [](int i) => data[i];  
  operator []=(int i, v) =>  data[i] = v;
  void addAll(Iterable<Obs> all) => data.addAll(all);
  
  // return the index of the key in the List data or -1. 
  int _comparableBinarySearch(Comparable key) {
    int min = 0;
    int max = data.length;
    while (min < max) {
      int mid = min + ((max - min) >> 1);
      var element = data[mid].index;
      int comp = element.compareTo(key);
      if (comp == 0) return mid;
      if (comp < 0) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }
    return -1;
  }

  
  Obs obsAt(K index) {
    int i = _comparableBinarySearch(index);
    return data[i];
  }
  Obs obsAtSlow(index) => data.firstWhere((obs) => obs.index == index);

  
  
  toString() => data.join("\n");
}



void main() {
  TimeSeries ts = new TimeSeries();
  ts.addAll([new Obs(new DateTime(2014), 1),
             new Obs(new DateTime(2015), 2),
             new Obs(new DateTime(2016), 3)]);
  
  print(ts);
  ts.removeWhere((e) => e.value < 3);
  print(ts);
  
  
}


