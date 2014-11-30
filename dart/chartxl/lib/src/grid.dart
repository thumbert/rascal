library grid;

import 'package:stagexl/stagexl.dart';


class GridDefaults {
  int color = Color.Gainsboro;  
  num lineWidth = 1;
}


/**
 * Construct a grid. 
 */
class Grid extends Shape with GridDefaults {
  
  //set width(num newWidth) => graphics.strokeColor(color, newWidth);
  List<num> v;
  List<num> h;
  
  
  Grid(List<num> this.v, List<num> this.h, num width, num height) {

    h.forEach((e) {
      graphics.moveTo(0, e);
      graphics.lineTo(width, e);
    });
    
    v.forEach((e) {
      graphics.moveTo(e, 0);
      graphics.lineTo(e, height);
    });

    graphics.strokeColor(color, lineWidth);
  }
  
}
