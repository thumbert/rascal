library container;

/**
 * Two series in a plotting area, with selection and tooltip.
 */


import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

Stage stage = new Stage(html.querySelector('#stage'));
RenderLoop renderLoop = new RenderLoop();
TextField tooltip;


class PlotArea extends DisplayObjectContainer {

  PlotArea(int width, int height) {
    print("Plot area width={$width} and heigth={$height}");
    Shape background = new Shape()
      ..width = width
      ..height = height
      ..graphics.rect(0, 0, width, height)
      ..graphics.strokeColor(Color.Black, 1.5, JointStyle.MITER)
      ..graphics.fillColor(Color.White);
    addChild(background);
  }

}

class Line extends Sprite {
  List<num> xData;
  List<num> yData;
  int color;

  Line(this.xData, this.yData, {this.color: Color.Tomato}) {
    onMouseOver.listen(_onMouseOver);
    onMouseOut.listen(_onMouseOut);
    onMouseWheel.listen(_onMouseWheel);

  }

  draw({num strokeWidth: 1.5}) {
    graphics.moveTo(xData.first, yData.first);
    for (int i = 1; i < xData.length; i++) {
      graphics.lineTo(xData[i], yData[i]);
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

  _onMouseOver(MouseEvent e) {
    graphics.clear();
    draw(strokeWidth: 5);
    //parent.setChildIndex(this, parent.numChildren - 1); // put this line in front of all lines

    tooltip.text = name;
    tooltip.x = e.localX + 15;
    tooltip.y = e.localY - 15;
    tooltip.alpha = 1;
    //parent.setChildIndex(tooltip, parent.numChildren - 1); // put the tooltip in the forefront

  }

  _onMouseOut(MouseEvent e) {
    tooltip.alpha = 0;
    graphics.clear();
    draw(strokeWidth: 1.5);
  }

}

void main() {
  //stage has width=800, height=500 
  renderLoop.addStage(stage);
  stage.backgroundColor = Color.Beige;

  List xData = new List.generate(7, (i) => 50 + 100 * i);
  List y1Data = [50, 150, 300, 375, 325, 275, 315];
  List y2Data = [100, 250, 250, 305, 225, 155, 125];
  List y3Data = [5, 200, 200, 225, 225, 155, 125];
  List y4Data = [25, 66, 30, 25, 225, 155, 125];


  var area = new PlotArea(700, 400)
    ..x = 50
    ..y = 50
    ..name = 'PlotArea'
    ..addTo(stage);

  tooltip = new TextField('')
    ..name = 'Tooltip'
    ..alpha = 0
    ..addTo(area);                  // one tooltip for all lines

  new Line(xData, y1Data, color: Color.Tomato)
    ..name = "Series 1"
    ..draw()
    ..addTo(area);
  new Line(xData, y2Data, color: Color.BlueViolet)
    ..name = "Series 2"
    ..draw()
    ..addTo(area);
  new Line(xData, y3Data, color: Color.CornflowerBlue)
    ..name = "Series 3"
    ..draw()
    ..addTo(area);
  new Line(xData, y4Data, color: Color.Chocolate)
    ..name = "Series 4"
    ..draw()
    ..addTo(area);


}


