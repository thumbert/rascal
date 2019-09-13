import 'package:plotly/plotly.dart';

import 'dart:math';
import 'package:timezone/browser.dart';
import 'package:date/date.dart';


Map getTrace() {
  var x = <DateTime>[];
  var y = <num>[];
  var n = 4000;
  var rand = Random(1);
  var start = DateTime(2018);
  for (int i=0; i<n; i++) {
    x.add(start.add(Duration(hours: i)));
    y.add(50 + 10*sin(pi*i/2000) + 20*sin(pi*i/4000) + 5*rand.nextDouble());
  }
  return {
    'x': x,
    'y': y,
    'mode': 'lines',
  };
}


main() async {
  await initializeTimeZone();

  var start = Date(2014, 1, 1);
  var end = Date.today();

  var data = [getTrace()];

  var layout = {'title': 'Line and Scatter Plot', 'height': 800, 'width': 960};

  var plot = Plot.id('myDiv2', data, layout);

  plot.on('plotly_relayout').listen((data) {
    print(data);
    var start = DateTime.parse(data["xaxis.range[0]"]);  
    var end = DateTime.parse(data["xaxis.range[1]"]);
    print(start);
    print(end);
    print(start.runtimeType);
  });

}
