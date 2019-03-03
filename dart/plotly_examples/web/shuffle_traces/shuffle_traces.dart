import 'package:plotly/plotly.dart';

import 'dart:math';
import 'dart:html';

List<Map> getTraces() {
  var n = 1000;
  var x = List.generate(n, (i) => i);
  var y1 = <num>[];
  var y2 = <num>[];
  var y3 = <num>[];
  var rand = Random(1);
  for (int i = 0; i < n; i++) {
    y1.add(30 +
        10 * sin(pi * i / 2000) +
        40 * sin(pi * i / 1000) +
        5 * rand.nextDouble());
    y2.add(65 +
        5 * sin(pi * i / 2000) +
        10 * sin(pi * i / 4000) +
        5 * rand.nextDouble());
    y3.add(80*exp(-i/n) + 5*rand.nextDouble());
  }
  return <Map>[
    {
      'x': x,
      'y': y1,
      'mode': 'lines',
    },
    {
      'x': x,
      'y': y2,
      'mode': 'lines',
    },
    {
      'x': x,
      'y': y3,
      'mode': 'lines',
    },
  ];
}

main() {
  var data = getTraces();

  var layout = {'title': 'Click button to change trace order',
    'height': 800, 'width': 960};

  var plot = Plot.id('chart-div', data, layout);

  var button = querySelector('#shuffle');
  button.onClick.listen((e) {
    plot.moveTraces([0,1,2], [2,1,0]);
  });

}
