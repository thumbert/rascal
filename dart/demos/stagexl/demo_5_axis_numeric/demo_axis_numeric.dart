library demo_axis_datetime;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'dart:math';
import 'dart:html';
import 'axis_datetime.dart';

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

  DateTimeAxis ax1 = new DateTimeAxis(new DateTime(2015, 1, 1), new DateTime(2015, 1, 2))
    ..calculateTicks()
    ..addTo(area)
    ..draw();

  print(ax1.scale(new DateTime(2015, 1, 2)));
  print('stage width: ${stage.width}, stage height: ${stage.height}');

}