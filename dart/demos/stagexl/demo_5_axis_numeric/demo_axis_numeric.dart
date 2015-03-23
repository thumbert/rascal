library demo_axis_numeric;

//import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'dart:html';
import 'axis_numeric.dart';

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
      ..graphics.rect(0, 0, width - 1, height - 1)
      ..graphics.strokeColor(Color.Black, 1, JointStyle.MITER)
      ..graphics.fillColor(Color.White);
    addChild(background);
  }
}

/// draw a horizontal line inside the PlotArea
class HorizontalLine extends Sprite {
  HorizontalLine();

  draw() {
    print('width is $width, parent width is ${parent.width}, parentName is ${parent.name}');
    graphics.moveTo(0, y);
    graphics.lineTo(parent.width, y); /// parent.width=400, why this line extends outside the PlotArea?!

    graphics.moveTo(0, y + 100);
    graphics.lineTo(400, y + 100);    /// this line does not overextend.

    graphics.strokeColor(Color.Black);
  }
}


main() {
  RenderLoop renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  var figure = new FigureArea(800, 600)
    ..name = 'FigureArea'
    ..addTo(stage);
  print('After adding figure, stage width: ${stage.width}, stage height: ${stage.height}');  /// OK

  var plotArea = new PlotArea(400, 400)
    ..x = 100
    ..y = 100
    ..name = 'PlotArea'
    ..addTo(figure);
  print('plot area width=${plotArea.width} and plot area heigth=${plotArea.height}');
  print('After adding PlotArea, stage width: ${stage.width}, stage height: ${stage.height}'); /// OK

//  var line = new HorizontalLine()
//    ..y = 10
//    ..addTo(plotArea)
//    ..draw();
//  print('After adding HLine, plot area width=${plotArea.width} and plot area heigth=${plotArea.height}');

  new NumericAxis(0, 1)
    //..width = area.width
    ..addTo(figure)
    ..draw()
    ..x = 100
    ..y = 25;

  new NumericAxis(0, 100)
    ..addTo(figure)
    ..draw()
    ..x = 100
    ..y = 125;

  new NumericAxis(0, 3)
    ..addTo(figure)
    ..draw()
    ..x = 100
    ..y = 175;


  print('stage width: ${stage.width}, stage height: ${stage.height}');

}


