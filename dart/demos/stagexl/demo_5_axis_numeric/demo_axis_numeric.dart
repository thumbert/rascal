library demo_axis_numeric;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'dart:math';
import 'dart:html';
import 'axis_numeric.dart';

CanvasElement canvas = html.querySelector('#stage');
Stage stage = new Stage(canvas);


class PlotArea extends DisplayObjectContainer {

  PlotArea(int width, int height) {
    print("Plot area width={$width} and heigth={$height}");
    Shape background = new Shape()
  ..width = width
  ..height = height
  ..graphics.rect(0, 0, width-1, height-1)
  ..graphics.strokeColor(Color.Black, 1, JointStyle.MITER)
  ..graphics.fillColor(Color.White);
    addChild(background);
  }
}



main() {
  RenderLoop renderLoop = new RenderLoop();
  renderLoop.addStage(stage);
  stage.backgroundColor = Color.Beige;

  var area = new PlotArea(700, 500)
..x = 50
..y = 50
..name = 'PlotArea'
..addTo(stage);
  print('stage width: ${stage.width}, stage height: ${stage.height}');
  print("Plot area width=${area.width} and heigth=${area.height}");

  NumericAxis ax1 = new NumericAxis(0, 1)
    ..addTo(area)
    ..y = 10
    ..draw();

  print('stage width: ${stage.width}, stage height: ${stage.height}');

}