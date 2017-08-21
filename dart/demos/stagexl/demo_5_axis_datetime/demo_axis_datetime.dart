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

DateTimeAxis axis1() {
  AxisFormat axisFormat = new AxisFormat(Position.bottom);
  DateTime start = new DateTime(2015, 1, 1);
  DateTime end = new DateTime(2015, 1, 2);
  Scale scale1 = new DateTimeScale(start, end, 15, 700-15);
  return new DateTimeAxis(scale1, axisFormat);
}
DateTimeAxis axis2() {
  AxisFormat axisFormat = new AxisFormat(Position.bottom);
  DateTime start = new DateTime(2015, 1, 1);
  DateTime end = new DateTime(2015, 1, 2, 2);
  Scale scale1 = new DateTimeScale(start, end, 15, 700-15);
  return new DateTimeAxis(scale1, axisFormat);
}
DateTimeAxis axis3() {
  AxisFormat axisFormat = new AxisFormat(Position.bottom);
  DateTime start = new DateTime(2015, 1, 1);
  DateTime end = new DateTime(2015, 1, 3);
  Scale scale1 = new DateTimeScale(start, end, 15, 700-15);
  return new DateTimeAxis(scale1, axisFormat);
}
DateTimeAxis axis4() {
  AxisFormat axisFormat = new AxisFormat(Position.bottom);
  DateTime start = new DateTime(2015, 1, 1);
  DateTime end = new DateTime(2015, 1, 10);
  Scale scale1 = new DateTimeScale(start, end, 15, 700-15);
  return new DateTimeAxis(scale1, axisFormat);
}
DateTimeAxis axis5() {
  AxisFormat axisFormat = new AxisFormat(Position.bottom);
  DateTime start = new DateTime(2015, 1, 10);
  DateTime end = new DateTime(2015, 5, 15);
  Scale scale1 = new DateTimeScale(start, end, 15, 700-15);
  return new DateTimeAxis(scale1, axisFormat);
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


  area.addChild( axis1() );
  area.addChild( axis2()..y = 75 );
  area.addChild( axis3()..y = 150 );
  area.addChild( axis4()..y = 225 );
  area.addChild( axis5()..y = 300 );





//  Scale scale2 = new DateTimeScale(new DateTime(2015,1,1), new DateTime(2015,12,31), 0, 700);
//  var a2 = new DateTimeAxis(scale2, Position.bottom)..y = 100;
//  area.addChild(a2);







}