import 'dart:js';
import 'package:plotly/plotly.dart';

main() {

  var data = [
    {
      'x': [1, 2, 3, 4, 5, 6, 7],
      'y': [1, 2, 3, 2, 3, 4, 3],
      'type': 'scatter',
      'mode': 'lines',
      'line': {'width': 1, 'color': '#FF0000', 'opacity': 1}
    },
    {
      'x': [1, 2, 3, 4, 5, 6, 7],
      'y': [1, 2, 1, 2, 3, 4, 3],
      'type': 'scatter',
      'mode': 'lines',
      'line': {'width': 1, 'color': '#0000FF', 'opacity': 1}
    }
  ];

  var layout = {
    'hovermode': 'closest',
    'showlegend': false,
    'title': 'Hover on a Point to Change Color'
  };

  var plot = new Plot.id('myDiv', data, layout);

  plot.onHover.listen((data) {
    var lineId, color, width;
    /// data['points'].length == 1, only one point is hovered at a time
    /// the curve number is 0 because there is only one trace.
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
