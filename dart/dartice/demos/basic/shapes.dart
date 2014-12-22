library demos.shapes;
import 'package:charted/selection/selection.dart';


main() {
  SelectionScope scope = new SelectionScope.selector('.circles');
  Selection svg = scope.append('svg:svg')
      ..attr('width', 800)
      ..attr('height', 400);
  
  DataSelection border = svg.selectAll('.border').data([0]);
  border.enter.append('rect');
  border..attr('x', 1)
        ..attr('y', 1)
        ..attr('width', 798)
        ..attr('height', 398)
        ..style('shape-rendering', 'crispEdges')
        ..style('fill', "#ffffff")
        ..style('stroke-width', "1")
        ..style('stroke', "#000000");
  border.exit.remove();

  var radius = [1, 2, 4, 8, 16, 32, 64]; //.reversed.toList();
  
  var points = svg.selectAll('point').data( radius );
  points.enter.append('circle')
      ..classed('point', true)
      ..attrWithCallback('data-row', (d, i, e) => i)
      ..attr('cx', 100)
      ..attr('cy', 100)
      ..attrWithCallback('r', (d, i, e) => radius[i])
      ..style('stroke-width', '1')
      ..style('stroke', "#31698A")
      ..style('fill', "#ffffff")
      ..style('fill-opacity', '0')  // needed to have the smaller shapes visible!
      ..style('opacity', '1');      

  
  
}