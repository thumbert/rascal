library graphics.plot_line;

import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/figure.dart';
import 'package:demos/graphics/drawable.dart';

class LinePlot extends Sprite implements Drawable {
  Figure figure;
  List<num> xData;
  List<num> yData;
  int color;
  num strokeWidth;

  /// A function to go from x data values to screen coordinates
  Function xScale;
  /// A function to go from y data values to screen coordinates
  Function yScale;

  LinePlot(this.figure, this.xData, this.yData, {this.color: Color.Tomato,
    this.strokeWidth: 1.5}) {
    onMouseOver.listen(_onMouseOver);
    onMouseOut.listen(_onMouseOut);
    onMouseWheel.listen(_onMouseWheel);
  }

  draw() {
    if (xScale == null) xScale = figure.xScale;
    if (yScale == null) yScale = figure.yScale;

    graphics.moveTo(xScale(xData.first), yScale(yData.first));
    for (int i = 1; i < xData.length; i++) {
      graphics.lineTo(xScale(xData[i]), yScale(yData[i]));
    }
    graphics.strokeColor(color, width = strokeWidth);
  }

  _onMouseWheel(MouseEvent e) {
    print('Wheelling!');
    //parent.setChildIndex(this, 0);  // push this at the bottom, not good

    var point = new Point(e.localX, e.localY);
    //var list = this.getObjectsUnderPoint(point);


//    var child = parent.getChildAt(parent.numChildren - 1);  // the one on top
//    print(child.name);
//    tooltip.text = child.name;
//    tooltip.x = parent.mouseX + 15;
//    tooltip.y = parent.mouseY - 15;
//    tooltip.alpha = 1;
//    parent.setChildIndex(tooltip, parent.numChildren - 1); // put the tooltip in the forefront
  }

  _onMouseOver(Event e) {
    graphics.clear();
    strokeWidth = 5;
    draw();
    //parent.setChildIndex(this, parent.numChildren - 1); // put this line in front of all lines

//    figure.tooltip.text = name;
//    figure.tooltip.x = e.localX + 15;
//    figure.tooltip.y = e.localY - 15;
//    figure.tooltip.alpha = 1;
    //parent.setChildIndex(tooltip, parent.numChildren - 1); // put the tooltip in the forefront

  }

  _onMouseOut(Event e) {
//    figure.tooltip.alpha = 0;
    graphics.clear();
    strokeWidth = 1.5;
    draw();
  }


}