library demo_axis_datetime;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'dart:html';
import 'package:demos/graphics/axis_datetime.dart';
import 'package:demos/graphics/axis_datetime_xl.dart';

//CanvasElement canvas = html.querySelector('#stage');
//Stage stage = new Stage(canvas);


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
  StageOptions stageOptions = new StageOptions()
    ..backgroundColor = Color.Beige
    ..antialias = true
    ..renderEngine = RenderEngine.Canvas2D;

  Stage stage = new Stage(html.querySelector('#stage'), options: stageOptions);

  RenderLoop renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  var area = new PlotArea(700, 500)
    ..x = 50
    ..y = 50
    ..name = 'PlotArea'
    ..addTo(stage);
  print('stage width: ${stage.width}, stage height: ${stage.height}');

//  new DateTimeAxisXl(new DateTime(2015, 1, 1), new DateTime(2015, 1, 2))
//    ..addTo(area)
//    ..draw();
//
//  new DateTimeAxisXl(new DateTime(2015, 1, 1), new DateTime(2015, 2, 1))
//    ..y = 75
//    ..addTo(area)
//    ..draw();
//
//  new DateTimeAxisXl(new DateTime(2015, 1, 1), new DateTime(2015, 4, 1))
//    ..y = 150
//    ..addTo(area)
//    ..draw();



  print('stage width: ${stage.width}, stage height: ${stage.height}');

}