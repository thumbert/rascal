library congview_client;

import 'dart:html';
import 'package:chartjs/chartjs.dart';

import 'dart:math' as math;
import 'package:date/date.dart';

List<DateTime> getHours({int N: 8760}) {
  DateTime start = new DateTime(2016);
  Duration h1 = new Duration(hours: 1);
  List<DateTime> res = new List(N);
  res[0] = start;
  for (int i=1; i<N; i++) {
    res[i] = res[i-1].add(h1);
  }
  return res;
}

/// generate some fake data, M is the number of series
List<List<num>> getSeries(List<DateTime> hours, {int M: 5}) {
  var rnd = new math.Random();
  List<List<num>> res = new List.generate(M, (i) => new List(hours.length));
  res.forEach((e) => e[0] = 0);  /// start all series from 0
  int i = 1;
  hours.skip(1).forEach((hour) {
    for (int j=0; j<M; j++) {
      res[j][i] = (100*(res[j][i-1] + rnd.nextDouble()-0.5)).round()/100;
    }
    i++;
  });
  return res;
}

void main() {
  List<DateTime> hours = getHours();
  List<List<num>> series = getSeries(hours, M: 2);
  //series.forEach((List e) => print(e.take(5)));

  var ctx = (querySelector('#canvas') as CanvasElement).context2D;
  var data = new LinearChartData(
      labels: hours.map((hour) => hour.toString()).toList(),
      datasets: <ChartDataSets>[
    new ChartDataSets(
        label: "My First dataset",
        borderColor: "rgba(255,0,0,0.5)",
        backgroundColor: "rgba(0,0,0,0)",
        lineTension: 0,
        data: series[0]),
    new ChartDataSets(
        label: "My Second dataset",
        borderColor: "rgba(0,255,0,0.5)",
        backgroundColor: "rgba(0,0,0,0)",
        lineTension: 0,
        data: series[1])
  ]);

  var config = new ChartConfiguration(
      type: 'line',
      data: data,
      options: new ChartOptions(responsive: false,
        legend: new ChartLegendOptions(display: false),
        animation: new ChartAnimationOptions(duration: 0),
        elements: new ChartElementsOptions(point: new ChartPointOptions(radius: 0))
      ));

  new Chart(ctx, config);
  /// Conclusion:  Does not have pan and zoom out of the box.  Does not seem to allow
  /// for incremental adding of series to the plot.  So switch back to dygraphs!
  /// 11/9/2016

}
