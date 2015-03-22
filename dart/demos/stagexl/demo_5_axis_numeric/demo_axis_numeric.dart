library demo_axis_numeric;

//import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'dart:html';
import 'axis_numeric.dart';

CanvasElement canvas = querySelector('#stage');
Stage stage = new Stage(canvas);


class PlotArea extends DisplayObjectContainer {
  PlotArea(int width, int height) {
    Shape background = new Shape()
      ..width = width
      ..height = height
      ..graphics.rect(0, 0, width - 1, height - 1)
      ..graphics.strokeColor(Color.Black, 1, JointStyle.MITER)
      ..graphics.fillColor(Color.White);
    addChild(background);
  }
}



main() {
  RenderLoop renderLoop = new RenderLoop();
  renderLoop.addStage(stage);
  stage.backgroundColor = Color.Beige;
  stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.NONE;
  print('stage width: ${stage.width}, stage height: ${stage.height}');

  var area = new PlotArea(700, 500)
    ..x = 50
    ..y = 50
    ..name = 'PlotArea'
    ..addTo(stage);
  print('stage width: ${stage.width}, stage height: ${stage.height}');
  print('Plot area width=${area.width} and heigth=${area.height}');

  new NumericAxis(0, 1)
    ..width = area.width
    ..addTo(area)
    ..draw()
    ..y = 25;

  new NumericAxis(0, 100)
    ..width = area.width
    ..addTo(area)
    ..draw()
    ..y = 75;

  new NumericAxis(0, 3)
    ..width = area.width
    ..addTo(area)
    ..draw()
    ..y = 125;




  print('stage width: ${stage.width}, stage height: ${stage.height}');

}


