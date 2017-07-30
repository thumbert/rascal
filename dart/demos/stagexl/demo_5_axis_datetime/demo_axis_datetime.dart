library demo_axis_datetime;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/axis_datetime.dart';
import 'package:demos/graphics/scale.dart';
import 'package:demos/graphics/axis.dart';


class PlotArea extends DisplayObjectContainer {

  PlotArea(int width, int height) {
    print("Plot area width={$width} and heigth={$height}");
    Shape background = new Shape()
      ..width = width
      ..height = height
      ..graphics.rect(0, 0, width-1, height-1)
      ..graphics.strokeColor(Color.Red, 1, JointStyle.MITER)
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


  DateTime start = new DateTime(2015, 1, 1);
  DateTime end = new DateTime(2015, 1, 2);
  Scale scale1 = new DateTimeScale(start, end, 15, 700-15);
  var a1 = new DateTimeAxis(scale1, Position.bottom);
  area.addChild(a1);
  print(a1.tickLocations.map((e) => scale1(e)));

//  Scale scale2 = new DateTimeScale(new DateTime(2015,1,1), new DateTime(2015,12,31), 0, 700);
//  var a2 = new DateTimeAxis(scale2, Position.bottom)..y = 100;
//  area.addChild(a2);







}