library renderers.points_renderer;
import 'package:charted/selection/selection.dart';
import 'package:dartice/renderers/renderer.dart';
import 'package:charted/charted.dart' as charted;
import 'package:dartice/scale/interpolator.dart';


class PointsRenderer extends Renderer {

  Selection _host;
  String classed;
  List x;                     // all data points for x variable
  List y;                     // all data points for y variable
  List<int> subscripts;       // index of the elements that correspond to this panel
  Function col;               // a function
  num minX, maxX, minY, maxY;
  Interpolator scaleX, scaleY;
  
  
  PointsRenderer(List this.x, List this.y, List<int> this.subscripts, 
      Function this.col, 
      Selection this._host, 
      {this.classed: "panel-points"}) {
    
    minX = charted.min(x);
    maxX = charted.max(x);
    scaleX = new NumericalInterpolator.fromPoints(minX, maxX, 10, 290 - 10); //TODO 
    
    minY = charted.min(y);
    maxY = charted.max(y);
    scaleY = new NumericalInterpolator.fromPoints(minY, maxY, 10, 290 - 10);

    
  }

  void draw() {
    Selection _group;
    _group = _host.append('g')..classed(classed);

    print(col(10,0,))
    
    var points = _group.selectAll(classed).data( y );
    points.enter.append('circle')
        ..classed(classed, true)
        ..attr('r', 5)
        ..attrWithCallback('data-row', (d, i, e) => i)
        ..attrWithCallback('cx', (d, i, e) => scaleX( x[i] ))
        ..attrWithCallback('cy', (d, i, e) => scaleY( y[i] ))
        ..styleWithCallback('stroke', (d, i, e) => col(d,i,e))
        ..styleWithCallback('fill', (d, i, e) => "#ffffff")
        ..style('fill-opacity', '0')
        ..style('opacity', '1');


  }

}
