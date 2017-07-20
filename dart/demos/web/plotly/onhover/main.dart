import 'dart:js';
import 'package:plotly/plotly.dart';

main() {

  var data = [
    {
      'x': [1, 2, 3, 4, 5, 6, 7],
      'y': [1, 2, 3, 2, 3, 4, 3],
      'type': 'scatter',
      'name': '1st line - red',
      'mode': 'lines',
      'line': {'width': 1, 'color': '#FF0000'}
    },
    {
      'x': [1, 2, 3, 4, 5, 6, 7],
      'y': [1, 2, 1, 2, 3, 4, 3],
      'type': 'scatter',
      'name': '2nd line - blue',
      'mode': 'lines',
      'marker': {'opacity': 1},
      'line': {'width': 1, 'color': '#0000FF'}
    }
  ];

  var layout = {
    'hovermode': 'closest',
    'showlegend': false,
    'title': 'Hover on a Point to highlight a series'
  };

  var plot = new Plot.id('myDiv', data, layout);
  /// Didn't succeed to put the highlighted series on top.
  /// Didn't see a way to control mouse-wheel, doubleclick, etc.


  plot.onHover.listen((data) {
    var lineId, color, width;
    /// https://plot.ly/javascript/plotlyjs-events/#event-data
    for (var i = 0; i < data['points'].length; i++) {
      width = data['points'][i]['data']['line']['width'];
      lineId = data['points'][i]['curveNumber'];
      color = data['points'][i]['data']['line']['color'];
      print('line:$lineId, width:$width');
    }

    var update = {
      'line': {'width': 5, 'color': color}
    };
    plot.restyle(update, [lineId]);
    ///plot.moveTrace(lineId, 0);   /// put it on top!

  });

  plot.onUnhover.listen((data) {
    var lineId, color, width;
    for (var i = 0; i < data['points'].length; i++) {
      width = data['points'][i]['data']['line']['width'];
      lineId = data['points'][i]['curveNumber'];
      color = data['points'][i]['data']['line']['color'];
      print('line:$lineId, width:$width');
    }

    var update = {
      'line': {'width': 1, 'color': color}
    };

    plot.restyle(update, [lineId]);
  });
}
