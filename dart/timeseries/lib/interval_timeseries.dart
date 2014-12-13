library interval_timeseries;

//import 'dart:collection';
//import 'package:timeseries/interval.dart';
//import 'package:timeseries/timeseries.dart';

//class IntervalObservation<E> {
//  Interval interval;
//  E value;
//  IntervalObservation(this.interval, this.value);
//  toString() => "{$interval, $value}";
//}

/*
 * NO LONGER NEEDED SEPARATELY.  TREATED INSIDE timeseries
 */

/*
 * A TimeSeries where the index is an Interval and not a 
 * DateTime.  For example an average monthly temperature is 
 * more conveniently represented as a Month -> value mapping, 
 * rather than using a DateTime with a beginning of the month.  
 * 
 * This class allows the creation of TimeSeries with a non-homogeneous 
 * index.  For example, a nextday interval, a next week interval, 
 * a balance of the month interval, months, and calendar years.   
 *  
 */
//class IntervalTimeSeries<E> extends AbstractTimeSeries<Interval,E> {
//  List<Interval> index;
//  List<E> data;
//  
//  TimeSeries(List<E> data, List<Interval> index, {bool checkIndexOrdering: false}) {
//    if (data.length != index.length) {
//      throw new Exception('TimeSeries data and index must have the same length');
//    }
//    if (checkIndexOrdering && !_isIndexOrdered()) 
//      throw new Exception('The index needs to be ordered');
//    this.data = data;
//    this.index = index;
//  }
//
//
//  IntervalTimeSeries.fill(List<Interval> index, E value, {bool checkIndexOrdering: false}) {
//    if (checkIndexOrdering && !_isIndexOrdered()) 
//      throw new Exception('The index needs to be ordered');
//    this.data = new List.filled(index.length, value);
//    this.index = index;
//  }
//  
//  
//  void add([Interval interval, E value]) {
//    if (!interval.isAfter(index.last))
//      throw new Exception("You can only add data at the end of the TimeSeries");
//    index.add(interval);
//    data.add(value);
//  }
//  
//   
//  /*
//    * Checking if the index is ordered.  
//    */
//   bool _isIndexOrdered() {
//     var aux = index.first;
//     for (int i=1; i<index.length; i++) {
//       if (!aux.isBefore(index[i])) 
//         return false;
//       aux = index[i]; 
//     }
//     
//     return true;
//   }
//   
//  
//}


//  IntervalTimeSeries.fromObservations(List<IntervalObservation<E>> obs) {
//    obs.forEach((e) {
//      index.add(e.interval);
//      data.add(e.value);
//    });
//  }
  

