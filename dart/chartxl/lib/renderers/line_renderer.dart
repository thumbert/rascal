library renderers.line_renderer;

import 'package:stagexl/stagexl.dart';
import 'package:chartxl/scale/interpolator.dart';

class LineRenderer extends Sprite {

  List xValues;
  List yValues;
  Interpolator xScale;  // how to go from values to screen coords for x values
  Interpolator yScale;  // how to go from values to screen coords for y values
  int color; 
  
  LineRenderer(this.xValues, this.yValues, this.xScale, this.yScale) {
    
    color = Color.Tomato;
    
    List xCoords = xValues.map((e) => xScale(e)).toList();
    List yCoords = yValues.map((e) => yScale(e)).toList();
    
    graphics.moveTo(xCoords.first, yCoords.first);
    for (int i=1; i<=xCoords.last; i++) {
      graphics.lineTo(xCoords[i], yCoords[i]);      
    }
    graphics.strokeColor(color);
    
    onMouseOver.listen( _onMouseOver );
    onMouseOut.listen( _onMouseOut );
  }
    
  _onMouseOver( MouseEvent e) {
    graphics.strokeColor(color, width=4);    
  }
  _onMouseOut( MouseEvent e) {
    graphics.strokeColor(color, width=1);        
  }
  
  
  
  
}

