library iris.iris;

import 'package:charted/charted.dart';
import 'dart:convert';
import 'package:stagexl/src/resources.dart';

iris_from_scratch( data ) {
  SelectionScope scope = new SelectionScope.selector('.iris_scratch');
  Selection svg = scope.append('svg:svg')
      ..attr('width', 700)
      ..attr('height', 700);

//  SvgLine line = new SvgLine(); 
//  DataSelection lines = svg.selectAll('.line').data( [data] ); // need to wrap into another List!
//  lines.enter.append('path');
//  lines
//      ..attrWithCallback('d', (d, i, e) => line.path(d, i, e))
//      ..classed('line');
//  lines.exit.remove();
  String blue = "#31698A";

  List xValues = data.map((e) => e[0]).toList();
  List yValues = data.map((e) => e[1]).toList();

  var points = svg.selectAll('point').data(yValues);
  points.enter.append('circle')
      ..classed('point', true)
      ..attr('r', 5)
      ..attrWithCallback('data-row', (d, i, e) => i)
      ..attrWithCallback('cx', (d, i, e) => xValues[i])
      ..attrWithCallback('cy', (d, i, e) => yValues[i])
      ..styleWithCallback('stroke', (d, i, e) => "#31698A")
      ..styleWithCallback('fill', (d, i, e) => "#31698A")
      ..style('opacity', '0.5');
  
  
}

main() {
  ResourceManager rm = new ResourceManager()..addTextFile("table", "iris.json");
  
  rm.load().then((_) {
    List iris = JSON.decode(rm.getTextFile("table"));

    List data = iris.map((obs) => [100 * obs["Sepal.Length"], 100 * obs["Sepal.Width"]]).toList();

    iris_from_scratch( data );
    
  });


}
