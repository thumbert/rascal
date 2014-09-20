library axis_sketch;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

Stage stage = new Stage(html.querySelector('#stage'));

RenderLoop renderLoop = new RenderLoop();

addGrid() {
  var grid = new Shape();
  
  num h = 0;
  while( h < stage.stageHeight) {
    grid.graphics.moveTo(0, h);
    grid.graphics.lineTo(stage.stageWidth, h);
    h += 100;
  }
  num v = 0;
  while( v < stage.stageWidth) {
    grid.graphics.moveTo(v, 0);
    grid.graphics.lineTo(v,stage.stageHeight);
    v += 100;
  }
  grid.graphics.strokeColor(Color.Gray, 1);
  
  stage.addChild( grid );
}



class Direction {
  static const int UP = 1;
  static const int DOWN = 2;
  static const int LEFT = 1;
  static const int RIGHT = 2;
}


class Tick extends DisplayObjectContainer {

  Shape line;
  TextField textField;

  Tick(int length, int padding, String text) {
    line = new Shape();
    line.graphics.moveTo(0, 0);
    line.graphics.lineTo(0, length);
    var fmt = new TextFormat("Arial", 14, Color.Black, align: TextFormatAlign.CENTER);
    textField = new TextField()
        ..defaultTextFormat = fmt
        ..y = length + padding
        ..autoSize = TextFieldAutoSize.CENTER  
        ..text = text;
    textField..x = -textField.width ~/ 2;
    line.graphics.strokeColor(Color.Black, 1);

    addChild(line);
    addChild(textField);
  }

}

class Axis extends DisplayObjectContainer {



}


main() {
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  stage.backgroundColor = Color.Beige;
  addGrid();
  
  
  var tick = new Tick(20, 5, "A really superlong Text")
      ..x = 100
      ..y = 100;

  stage.addChild(tick);


}
