library iris.iris;

import 'package:charted/charted.dart';
import 'dart:convert';
import 'package:stagexl/src/resources.dart';
import 'package:dartice/scale/interpolator.dart';
import 'package:dartice/theme/theme.dart';
import 'package:dartice/plots/plot.dart';
import 'dart:html' as html;


from_scratch(data) {
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
      ..style('shape-rendering', 'crispEdges')   // how to pass this in the style sheet!
      ..style('fill', "#ffffff")
      ..style('stroke-width', "1")
      ..style('stroke', "#000000");
  border.exit.remove();

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

  Theme theme = Theme.currentTheme;
  List groups = data.map((e) => e["Species"]).toSet().toList();
  var groupScale = new OrdinalInterpolator(groups, values: theme.COLORS);
  
  var points = svg.selectAll('point').data(data);
  points.enter.append('circle')
      ..classed('point', true)
      ..attr('r', 5)
      ..attrWithCallback('data-row', (d, i, e) => i)
      ..attrWithCallback('cx', (d, i, e) => xValues[i])
      ..attrWithCallback('cy', (d, i, e) => yValues[i])
      ..styleWithCallback('stroke', (d, i, e) => groupScale(d["Species"]))
      ..styleWithCallback('fill', (d, i, e) => "#ffffff")
      ..style('fill-opacity', '0')
      ..style('opacity', '1');


}

high_level( iris ) {
  
  new Plot( html.querySelector('.iris_highlevel') )
    ..data = iris
    ..x = ((e) => e["Sepal.Length"])
    ..y = ((e) => e["Sepal.Width"])
    ..group = ((e) => e["Species"])
    ..type = ["p"]
    ..draw();

  
  
}


main() {
  ResourceManager rm = new ResourceManager()..addTextFile("table", "iris.json");

  rm.load().then((_) {
    List iris = JSON.decode(rm.getTextFile("table"));

    from_scratch( iris );
    
    high_level( iris );

  });


}

//  SvgLine line = new SvgLine();
//  DataSelection lines = svg.selectAll('.line').data( [data] ); // need to wrap into another List!
//  lines.enter.append('path');
//  lines
//      ..attrWithCallback('d', (d, i, e) => line.path(d, i, e))
//      ..classed('line');
//  lines.exit.remove();
