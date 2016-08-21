library demo_axis_numeric;

import 'dart:html';
import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/axis_numeric.dart';
import 'package:demos/graphics/scale.dart';
import 'package:demos/graphics/axis.dart';

CanvasElement canvas = querySelector('#stage');
Stage stage = new Stage(canvas);

class FigureArea extends DisplayObjectContainer {
  FigureArea(int width, int height) {
    Shape background = new Shape()
      ..graphics.rect(0, 0, width, height)
      ..graphics.fillColor(Color.Beige);
    addChild(background);
  }
}


class PlotArea extends DisplayObjectContainer {
  PlotArea(int width, int height) {
    Shape background = new Shape()
      ..graphics.rect(0, 0, width, height)
    //..graphics.strokeColor(Color.Black, 1, JointStyle.MITER)
      ..graphics.fillColor(Color.White);
    addChild(background);
  }
}



main() {
  RenderLoop renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  var figure = new FigureArea(800, 600)
    ..name = 'FigureArea'
    ..addTo(stage);
//  print('After adding figure, stage width: ${stage.width}, stage height: ${stage.height}');  /// OK

  var plotArea = new PlotArea(400, 550)
    ..x = 100
    ..y = 25
    ..name = 'PlotArea'
    ..addTo(figure);
  print('plot area width=${plotArea.width} and plot area height=${plotArea.height}');
//  print('After adding PlotArea, stage width: ${stage.width}, stage height: ${stage.height}'); /// OK


  print(plotArea.width);
  int N = 400;
  new NumericAxis(new LinearScale(0, 1, 0, N), Position.bottom)
    ..addTo(plotArea)
    ..draw()
    ..y = 25;
  print(plotArea.width);

  new NumericAxis(new LinearScale(0, 100, 0, N), Position.bottom)
    ..addTo(plotArea)
    ..draw()
    ..y = 75;
  print(plotArea.width);

  new NumericAxis(new LinearScale(0, 3, 0, N), Position.bottom)
    ..addTo(plotArea)
    ..draw()
    ..y = 125;
  print(plotArea.width);

  new NumericAxis(new LinearScale(0, 3000, 0, N), Position.bottom)
    ..addTo(plotArea)
    ..draw()
    ..y = 175;
  print(plotArea.width);

  new NumericAxis(new LinearScale(65, 66, 0, N), Position.bottom)
    ..addTo(plotArea)
    ..draw()
    ..y = 225;
  print(plotArea.width);

  new NumericAxis(new LinearScale(1000, 1000000, 0, N), Position.bottom)
    ..addTo(plotArea)
    ..draw()
    ..y = 275;
  print(plotArea.width);

  new NumericAxis(new LinearScale(100000, 100000000, 0, N), Position.bottom)
    ..addTo(plotArea)
    ..draw()
    ..y = 325;
  print(plotArea.width);

  new NumericAxis(new LinearScale(-1000000, 1000000, 0, 600), Position.bottom)
    ..addTo(plotArea)
    ..draw()
    ..y = 375;
  print(plotArea.width);

  print('stage width: ${stage.width}, stage height: ${stage.height}');

}


//  var line = new HorizontalLine()
//    ..y = 10
//    ..addTo(plotArea)
//    ..draw();
//  print('After adding HLine, plot area width=${plotArea.width} and plot area height=${plotArea.height}');
