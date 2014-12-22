library iris.iris;

import 'package:charted/charted.dart';
import 'dart:convert';
import 'package:stagexl/src/resources.dart';
import 'package:dartice/scale/interpolator.dart';


iris_from_scratch(data) {
  SelectionScope scope = new SelectionScope.selector('.iris_scratch');
  Selection svg = scope.append('svg:svg')
      ..attr('width', 300)
      ..attr('height', 300);

  DataSelection border = svg.selectAll('.border').data([0]);
  border.enter.append('rect');
  border
      ..attr('x', 2)
      ..attr('y', 2)
      ..attr('width', 295)
      ..attr('height', 295)
      ..style('shape-rendering', 'crispEdges')
      ..style('fill', "#ffffff")
      ..style('stroke-width', "1")
      ..style('stroke', "#000000");
  border.exit.remove();


  Function color = (int i) => "#31698A";
  var x = data.map((e) => e["Sepal.Length"]);
  var minX = min(x);
  var maxX = max(x);
  var scaleX = new NumericalInterpolator.fromPoints(minX, maxX, 10, 290);
  List xValues = x.map((e) => scaleX(e)).toList();

  var y = data.map((e) => e["Sepal.Width"]);
  var minY = min(y);
  var maxY = max(y);
  var scaleY = new NumericalInterpolator.fromPoints(minY, maxY, 10, 290);
  List yValues = y.map((e) => scaleY(e)).toList();

  var points = svg.selectAll('point').data(data);
  points.enter.append('circle')
      ..classed('point', true)
      ..attr('r', 5)
      ..attrWithCallback('data-row', (d, i, e) => i)
      ..attrWithCallback('cx', (d, i, e) => xValues[i])
      ..attrWithCallback('cy', (d, i, e) => yValues[i])
      ..styleWithCallback('stroke', (d, i, e) {
        return color(i);
      })
      ..styleWithCallback('fill', (d, i, e) => "#ffffff")
      ..style('fill-opacity', '0')
      ..style('opacity', '1');


}

main() {
  ResourceManager rm = new ResourceManager()..addTextFile("table", "iris.json");

  rm.load().then((_) {
    List data = JSON.decode(rm.getTextFile("table"));

    iris_from_scratch(data);

  });


}

//  SvgLine line = new SvgLine();
//  DataSelection lines = svg.selectAll('.line').data( [data] ); // need to wrap into another List!
//  lines.enter.append('path');
//  lines
//      ..attrWithCallback('d', (d, i, e) => line.path(d, i, e))
//      ..classed('line');
//  lines.exit.remove();
