library timeseries;

import 'dart:collection';
//import 'seq.dart';
import 'package:timeseries/time/month.dart';
import 'package:timeseries/time/interval.dart';
import 'package:timeseries/time/period.dart';


/**
 * An Observations class. 
 * Type K needs to have the methods isBefore, isAfter. 
 */
//class Obs<K,V> extends Object with Comparable<K> {
class Obs<V> {
  DateTime index;
  V value;
  Obs(this.index, this.value);
  bool operator ==(Obs other) =>
      value == other.value && index == other.index; // TODO: check for null
  toString() => "{$index, $value}";
}


/**
 * A TimeSeries class suitable for storing time-stamped data, or aggregated time-series data
 * with a given periodicity.  
 *   
 * Time stamped data can arise from a logger or a tool that measures something at specific 
 * time points.  Aggregated time-series hold a value for a given time interval.  For exampe, 
 * the monthly average historical temperature in Boston.  Each month will have a double associated
 * with it representing the temperature, but it is also important to distinguish the fact 
 * that "2014-01-01 00:00:00.000" corresponds to the entire month, not only to the instant.  
 * To distinguish between the second type of time-series we'll refer to them as aggregated 
 * (or integrated, or interval) time-series.  
 * 
 * The [index] keeps the time stamp or the beginning time-stamp in the case of an aggregated 
 * time-series.  Most aggregated time-series have constant duration between the time index.  For 
 * example, aggregated hourly data will have the index showing the beginning of the hour and the 
 * [duration] equal to 1 hour.   
 * 
 * Observations are ordered by the time index.  Only distinct values of the index are allowed.  
 * The observations value type V doesn't need to be the same for different 
 * values of the index. [REALLY?!]
 *   
 */
class TimeSeries<V> extends ListBase<Obs<V>> {
  List<Obs<V>> data = [];  //TODO: do I need this?!  I don't think so!
  final bool isUtc;
  final Period period;


  TimeSeries({Period this.period, bool this.isUtc: false});

  TimeSeries.fill(List<DateTime> index, value, {Period this.period, bool this.isUtc: false}) {
    data = new List.generate(index.length, (i) => new Obs(index[i], value), growable: true);
  }
  /**
   * Creates a TimeSeries of size length and fills it with observations observations created by 
   * calling the generator for each index in the range 0 .. length-1 in increasing order. 
   */
  TimeSeries.generate(int length, Function generator, {Period this.period, bool this.isUtc: false,
      bool growable: true}) {
    data = new List.generate(length, generator, growable: growable);
  }
  /**
   * Create a TimeSeries from components.
   */
  TimeSeries.fromComponents(List<DateTime> index, List<V> value, {Period this.period, bool
      this.isUtc: false}) {
    if (value.length !=
        index.length) throw new Exception('TimeSeries value and index must have the same length');

    for (int i = 0; i < value.length; i++) {
      data.add(new Obs(index[i], value[i]));
    }

  }


  int get length => data.length;
  void set length(int i) {
    data.length = i;
  }

  operator [](int i) => data[i];
  operator []=(int i, Obs obs) => data[i] = obs;

  /**
   * Only add at the end of a timeseries.  If the timeseries is of a given period, only 
   * observations that start at the correct period are allowed.
   */
  void add(Obs obs) {
    if (!data.isEmpty &&
        obs.index.isBefore(
            data.last.index)) throw new StateError("You can only add at the end of the TimeSeries");
    if (period != null &&
        period.trunc(obs.index) !=
            obs.index) throw new StateError("You can only add observations with the same period");
    if (isUtc != obs.index.isUtc) 
      throw new StateError("The observation UTC flag does not match the UTC flag for the timeseries");
    
    data.add(obs);
  }
  void addAll(Iterable<Obs> all) => all.forEach((obs) => this.add(obs));


  Iterable get values => data.map((obs) => obs.value);


  // return the index of the key in the List _data or -1.
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

  /**
   * Expand each observation of this timeseries using a function f. 
   * For example, can be used to expand a monthly timeseries to a daily series. 
   */
  TimeSeries expand(Iterable<Obs> f(Obs obs), {Period period}) {
    
    TimeSeries ts = new TimeSeries(period: period, isUtc: this.isUtc);
    print(data);
    data.forEach((Obs obs) {
      ts.addAll( f(obs) );  
    });
    
    return ts;    
  }
    
  
  Obs obsAt(DateTime index) {
    int i = _comparableBinarySearch(index);
    return data[i];
  }
  //Obs obsAtSlow(index) => _data.firstWhere((obs) => obs.index == index);



  toString() => data.join("\n");


  /**
   * Split the time series into a LinkedHashMap of Lists according to a function on the
   * index.
   */
  Map<DateTime, List<V>> groupByIndex(DateTime f(DateTime dt)) {
    Map<DateTime, List<V>> grp = new LinkedHashMap<DateTime, List<V>>();
    int N = data.length;
    for (int i = 0; i < N; i++) {
      DateTime group = f(data[i].index);
      grp.putIfAbsent(group, () => []).add(data[i].value);
    }

    return grp;
  }

  /**
   * Aggregate this timeseries to a daily timeseries according to an
   * aggregation function f.
   */
  toDaily(Function f(List<V> x)) {
    Map<DateTime, List<V>> grp = groupByIndex((DateTime dt) {
      if (isUtc) {
        return new DateTime.utc(dt.year, dt.month, dt.day);
      } else {
        return new DateTime(dt.year, dt.month, dt.day);
      }
    });

    var valueGrp = [];
    for (DateTime key in grp.keys) {
      valueGrp.add(f(grp[key]));
    }
    return new TimeSeries.fromComponents(
        grp.keys.toList(growable: false),
        valueGrp,
        period: Period.DAY, 
        isUtc: this.isUtc);
  }


  /**
   * Aggregate this timeseries to a monthly timeseries according to an
   * aggregation function f.
   */
  toMonthly(Function f(List<V> x)) {
    Map<DateTime, List<V>> grp = groupByIndex((DateTime dt) {
      if (isUtc) {
        return new DateTime.utc(dt.year, dt.month);
      } else {
        return new DateTime(dt.year, dt.month);
      }
    });

    var valueGrp = [];
    for (DateTime key in grp.keys) {
      valueGrp.add(f(grp[key]));
    }
    return new TimeSeries.fromComponents(
        grp.keys.toList(growable: false),
        valueGrp,
        period: Period.MONTH, 
        isUtc: this.isUtc);
  }

  /**
   * Aggregate this timeseries to a yearly timeseries according to an aggregation function.
   * The aggregation function operates on a List with all the values in a year.
   */
  toYearly(Function f(List<V> x)) {
    Map<DateTime, List<V>> grp = groupByIndex((DateTime dt){
      if (isUtc) {
        return new DateTime.utc(dt.year);
      } else {
        return new DateTime(dt.year);
      }     
    });

    var valueGrp = [];
    for (DateTime key in grp.keys) {
      valueGrp.add( f(grp[key]) );
    }
    return new TimeSeries.fromComponents(
        grp.keys.toList(growable: false),
        valueGrp,
        period: Period.YEAR, 
        isUtc: this.isUtc);
  }
}





/*
 * A TimeSeries class, with the index a DateTime instant.  The index needs to be 
 * ordered!
 * E be the 
 */
//class TimeSeries<E> extends AbstractTimeSeries<DateTime, E> {
//  List<DateTime> index;
//  List<E> value;
//
//
//  //  TimeSeries.fromObservations(List<Observation<E>> obs) {
//  //    obs.forEach((e) {
//  //      index.add(e.index);
//  //      value.add(e.value);
//  //    });
//  //  }
//
//  TimeSeries.fill(List<DateTime> index, E value, {bool checkIndexOrdering:
//      true}) {
//    this.value = new List.filled(index.length, value);
//    this.index = index;
//    if (checkIndexOrdering && !_isIndexOrdered()) throw new Exception(
//        'TimeSeries index needs to be ordered!');
//  }
//
//
//  void add([DateTime dt, E value]) {
//    if (!dt.isAfter(index.last)) throw new Exception(
//        "You can only add value at the end of the TimeSeries");
//    index.add(dt);
//    this.value.add(value);
//  }
//
//
//
//
//
//  /*
//   * Checking if the index is ordered.
//   */
//  bool _isIndexOrdered() {
//    var aux = index.first;
//    for (int i = 1; i < index.length; i++) {
//      if (!aux.isBefore(index[i])) return false;
//      aux = index[i];
//    }
//
//    return true;
//  }
//
//}

/*
 * Aggregate this timeseries to a monthly timeseries according to an 
 * aggregation function f .
 * The aggregation function operates on all the values in a month.  
 * Use an imperative style for speed.  
 */
//  toMonthly(Function f(List<Obs> x)) {
//    Month start, end;
//    if (_data.first.index is DateTime) {
//      start = new Month(_data.first.index.year, _data.first.index.month);
//      end = new Month(_data.last.index.year, _data.last.index.month);
//
//    } else if (_data.first.index is Interval) {
//      start = new Month(_data.first.index.start.year, _data.first.index.start.month);
//      end = new Month(_data.last.index.end.year, _data.last.index.end.month);
//
//    } else {
//      throw new Exception("Wrong type for the index dude!");
//    }
//    List<Month> months = start.seqTo(end);
//
//    List res = new List(months.length); // the data for the monthly timeseries
//    var aux = [];
//    var iM = 0;
//    for (int i = 0; i < _data.length; i++) {
//      if (_data[i].index.year == months[iM].year && _data[i].index.month == months[iM].month) {
//        aux.add(_data[i].value);
//      } else {
//        res[iM] = f(aux);
//        aux = [_data[i].value];
//        iM += 1;
//      }
//    }
//    res[iM] = f(aux); // for the last observation
//
//    return new TimeSeries.generate(months.length, (i) => new Obs(months[i], res[i]));
//  }
