library congview_client;

import 'dart:html' as html;
import 'dart:math';
import 'package:dygraphs_dart/dygraphs_dart.dart';

/// Define a custom mouse interaction.  The mouse wheel brings one series to
/// the forefront.

main() async {

  List<List> data = [
    [1, 0,0,0,0,0],
    [2, 0,0,0,0,0],
    [3, 0,0,0,0,0],
    [4, 0,1,2,3,4],
    [5, 0,0,0,0,0]
  ];

  Option opt = new Option(
      labels: ['a', 'b', 'c', 'd', 'e', 'f'],
      animatedZooms: true,
      highlightSeriesOpts: {
        'strokeWidth': 50,
        'strokeBorderWidth': 1,
        'highlightCircleSize': 20
      },
      showLabelsOnHighlight: false
  );




  new Dygraph(html.querySelector('#canvas'), data, opt);


}
