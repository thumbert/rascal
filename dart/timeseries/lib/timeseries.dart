library timeseries;

export 'src/interval_tuple.dart';
export 'src/time_tuple.dart';
export 'src/timeseries_base.dart';




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
