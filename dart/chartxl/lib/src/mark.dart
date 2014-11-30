library mark;

import 'package:stagexl/stagexl.dart';

abstract class Mark extends Sprite {
  
}

class Circle extends Mark {
  
  Circle({int color: Color.Blue, num radius: 3, int fillColor: Color.Transparent, 
    num strokeWidth: 1, num alpha: 1}) {
    
    graphics.moveTo(0, 0);
    graphics.circle(0, 0, radius);
    graphics.strokeColor(color, strokeWidth);
    graphics.fillColor(fillColor);
    this.alpha = alpha;
    
    onMouseOver.listen( (e) {
      graphics.strokeColor(color, strokeWidth*2);
    });
    onMouseOut.listen( (e) {
      //graphics.circle(0, 0, radius);
      //print("Here");
      graphics.strokeColor(Color.Transparent, strokeWidth*2);
      graphics.strokeColor(color, strokeWidth);
    });
    
  }
  
  
}