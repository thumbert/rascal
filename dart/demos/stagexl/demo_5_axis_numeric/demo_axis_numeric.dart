library demo_axis_numeric;


import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/axis_numeric.dart';
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

NumericAxis axis1() {
  AxisFormat axisFormat = new AxisFormat(Position.bottom);
  Scale scale1 = new LinearScale(0, 1, 15, 700-15);
  return new NumericAxis(scale1, axisFormat);
}
//NumericAxis axis2() {
//  AxisFormat axisFormat = new AxisFormat(Position.bottom);
//  Scale scale1 = new LinearScale(0, 1, 15, 700-15);
//  return new NumericAxis(scale1, axisFormat);
//}
//NumericAxis axis3() {
//  AxisFormat axisFormat = new AxisFormat(Position.bottom);
//  Scale scale1 = new LinearScale(0, 1, 15, 700-15);
//  return new NumericAxis(scale1, axisFormat);
//}
//NumericAxis axis4() {
//  AxisFormat axisFormat = new AxisFormat(Position.bottom);
//  Scale scale1 = new LinearScale(0, 1, 15, 700-15);
//  return new NumericAxis(scale1, axisFormat);
//}
//NumericAxis axis5() {
//  AxisFormat axisFormat = new AxisFormat(Position.bottom);
//  Scale scale1 = new LinearScale(0, 1, 15, 700-15);
//  return new NumericAxis(scale1, axisFormat);
//}



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
//  area.addChild( axis2()..y = 75 );
//  area.addChild( axis3()..y = 150 );
//  area.addChild( axis4()..y = 225 );
//  area.addChild( axis5()..y = 300 );


}


//  var line = new HorizontalLine()
//    ..y = 10
//    ..addTo(plotArea)
//    ..draw();
//  print('After adding HLine, plot area width=${plotArea.width} and plot area height=${plotArea.height}');
