import 'dart:js';
import 'package:plotly/plotly.dart';

main() {
  var colors = new List.filled(7, '#00000');

  var data = [
    {
      'x': [1, 2, 3, 4, 5, 6, 7],
      'y': [1, 2, 3, 2, 3, 4, 3],
      'type': 'scatter',
      'mode': 'lines',
      'marker': {'size': 16, 'color': colors},
      'line': {'width': 1, 'color': '#000000'}
    },
    {
      'x': [1, 2, 3, 4, 5, 6, 7],
      'y': [1, 2, 1, 2, 3, 4, 3],
      'type': 'scatter',
      'mode': 'lines',
      'marker': {'size': 16, 'color': '#F44283'},
      'line': {'width': 1, 'color': '#F44283'}
    }
  ];

  var layout = {
    'hovermode': 'closest',
    'title': 'Hover on a Point to Change Color'
  };

  var plot = new Plot.id('myDiv', data, layout);

  plot.onHover.listen((data) {
    var pn = '', tn = '', width;
    List size = new List.filled(7, 16);
    /// data['points'].length == 1, only one point is hovered at a time
    /// the curve number is 0 because there is only one trace.
    /// https://plot.ly/javascript/plotlyjs-events/#event-data
    for (var i = 0; i < data['points'].length; i++) {
      pn = data['points'][i]['pointNumber'];
      tn = data['points'][i]['curveNumber'];
      width = data['points'][i]['data']['line']['width'];
      print('pn:$pn, tn:$tn, width:$width');
    }

    var update = {
      'line': {'color': '#FF0000', 'width': 3}
    };
    plot.restyle(update, [tn]);
  });

  plot.onUnhover.listen((data) {
    var pn = '', tn = '', colors = [];
    for (var i = 0; i < data['points'].length; i++) {
      pn = data['points'][i]['pointNumber'];
      tn = data['points'][i]['curveNumber'];
      colors = data['points'][i]['data']['marker']['color'];
    }
    colors[pn] = '#00000';

    var update = {
      'line': {'color': '#FF0000', 'width': 1}
    };

    plot.restyle(update, [tn]);
  });
}
