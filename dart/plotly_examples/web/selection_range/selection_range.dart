import 'package:plotly/plotly.dart';

import 'dart:math';
import 'dart:js';
import 'dart:js_util';

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


main() {

  var data = [getTrace()];

  var layout = {'title': 'Line and Scatter Plot', 'height': 800, 'width': 960};

  var plot = new Plot.id('myDiv2', data, layout);

//  plot.onClick.listen((event) {
//    print('click: $event');
//  });
//  plot.onHover.listen((event) {
//    print('hover: $event');
//  });

  plot.on('plotly_relayout').listen((data) {
    print(data);
    var start = data["xaxis.range[0]"];  // a String
    var end = data["xaxis.range[1]"];
    print(start);
    print(end);
    print(start.runtimeType);
  });





//  plot
//      .on("plotly_beforeplot")
//      .listen((event) => print("plotly_beforeplot: $event"));
//  plot
//      .on("plotly_afterplot")
//      .listen((event) => print("plotly_afterplot: $event"));
//  plot
//      .on("plotly_beforeexport")
//      .listen((event) => print("plotly_beforeexport: $event"));


}