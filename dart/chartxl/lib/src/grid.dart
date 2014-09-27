library grid;

import 'package:stagexl/stagexl.dart';


class DefaultGrid {
  int color = Color.Bisque;  
  num width = 1;
}


/**
 * Construct a grid
 */
class Grid extends Shape with DefaultGrid {
  
  //set width(num newWidth) => graphics.strokeColor(color, newWidth);
  List<num> v;
  List<num> h;
  num xMax;
  
  
  Grid(List<num> this.v, List<num> this.h, {num xMax: 100, num yMax: 100}) {

  }
  
  
  draw() {
    
    h.forEach((e) {
      graphics.moveTo(0, e);
      graphics.lineTo(stage.stageWidth, e);
    });
    
    v.forEach((e) {
      graphics.moveTo(e, 0);
      graphics.lineTo(e, stage.stageHeight);
    });

    graphics.strokeColor(color, width);
    
    
  }

}
