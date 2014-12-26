//library panel.panel_points;
//
//import 'package:charted/selection/selection.dart';
//
//abstract class Panel {
//  
//}
//
//class PanelPoints extends Panel {
//  
//  Selection _group;
//  Selection _host;  
//  
//  List xValues;
//  List yValues;
//  
//  PanelPoints();
//  
//  void draw() {
//    _group = _host.append('g')..classed('panel-points');
//    
//    var points = _group.selectAll('point').data(yValues);
//    points.enter.append('circle')
//         ..classed('point', true)
//         ..attr('r', 5)
//         ..attrWithCallback('data-row', (d, i, e) => i)
//         ..attrWithCallback('cx', (d, i, e) => xValues[i])
//         ..attrWithCallback('cy', (d, i, e) => yValues[i])
//         ..styleWithCallback('stroke', (d, i, e) => "#31698A")
//         ..styleWithCallback('fill', (d, i, e) => "#31698A")
//         ..style('opacity', '0.5');
//     
//    
//  }
//  
//}