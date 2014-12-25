library renderers.points_renderer;
import 'package:charted/selection/selection.dart';
import 'package:dartice/renderers/renderer.dart';

class PointsRenderer extends Renderer {
  
  Selection _group;
  Selection _host;  
  
  List xValues;
  List yValues;
  
  PointsRenderer();
  
  void draw() {
    _group = _host.append('g')..classed('panel-points');
    
    var points = _group.selectAll('point').data(yValues);
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
  
}