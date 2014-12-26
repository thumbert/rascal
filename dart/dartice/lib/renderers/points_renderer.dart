library renderers.points_renderer;
import 'package:charted/selection/selection.dart';
import 'package:dartice/renderers/renderer.dart';
import 'package:charted/charted.dart' as charted;
import 'package:dartice/scale/interpolator.dart';
import 'package:dartice/theme/theme.dart';


class PointsRenderer extends Renderer {

  String classed;
  List x;                     // data for the x variable for all panels 
  List y;                     // data for the y variable for all panels
  List<int> subscripts;       // index of the elements that correspond to this panel
  Theme theme;
  Selection _host;
  int panelWidth;
  int panelHeight;
  
  Function col;               // a function (d,i,e) => string color
  Function cex;               // a function (d,i,e) => percent of plotting text
  
  num minX, maxX, minY, maxY;
  Interpolator scaleX, scaleY;
  
  
  PointsRenderer(List this.x, List this.y, List<int> this.subscripts, 
      Theme this.theme, 
      Selection this._host,
      int this.panelWidth, 
      int this.panelHeight, 
      {Function this.col, Function this.cex, String this.classed: "panel-points"}) {
    
    minX = charted.min(x);
    maxX = charted.max(x);
    scaleX = new NumericalInterpolator.fromPoints(minX, maxX, 10, panelWidth - 10); //TODO 
    
    minY = charted.min(y);
    maxY = charted.max(y);
    scaleY = new NumericalInterpolator.fromPoints(minY, maxY, 10, panelHeight - 10);

    
  }

  void draw() {
    Selection _group;
    _group = _host.append('g')..classed(classed);

    if (cex == null) 
      cex = (d,i,e) => 0.8;
    
    var points = _group.selectAll(classed).data( y );
    points.enter.append('circle')
        ..classed(classed, true)
        ..attrWithCallback('r', (d,i,e) => (0.5*cex(d,i,e)*theme.textSize).round())
        ..attrWithCallback('data-row', (d, i, e) => i)
        ..attrWithCallback('cx', (d, i, e) => scaleX( x[i] ))
        ..attrWithCallback('cy', (d, i, e) => scaleY( y[i] ))
        ..styleWithCallback('stroke', col )
        ..styleWithCallback('fill', (d, i, e) => theme.backgroundColor)
        ..style('fill-opacity', '0')
        ..style('opacity', '1');


  }

}
