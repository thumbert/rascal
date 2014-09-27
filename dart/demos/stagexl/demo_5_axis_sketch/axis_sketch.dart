library axis_sketch;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'dart:math';
import 'dart:html';

CanvasElement canvas = html.querySelector('#stage');
Stage stage = new Stage(canvas);

RenderLoop renderLoop = new RenderLoop();

addGrid() {
  var grid = new Shape();

  num h = 0;
  while (h < stage.stageHeight) {
    grid.graphics.moveTo(0, h);
    grid.graphics.lineTo(stage.stageWidth, h);
    h += 100;
  }
  num v = 0;
  while (v < stage.stageWidth) {
    grid.graphics.moveTo(v, 0);
    grid.graphics.lineTo(v, stage.stageHeight);
    v += 100;
  }
  grid.graphics.strokeColor(Color.Bisque, 1);

  stage.addChild(grid);
}



class Direction {
  static const int UP = 3;
  static const int DOWN = 1;
  static const int LEFT = 2;
  static const int RIGHT = 4;
}

class Tick extends DisplayObjectContainer {

  Shape line;
  TextField textField;

  Tick(String text, int length, int padding, int direction) {
    line = new Shape();
    line.graphics.moveTo(0, 0);
    var fmt = new TextFormat("Arial", 14, Color.Black, align: TextFormatAlign.CENTER);

    print(direction);
    switch (direction) {
      case Direction.DOWN:
        line.graphics.lineTo(0, length);
        textField = new TextField()
            ..defaultTextFormat = fmt
            ..y = length + padding
            ..autoSize = TextFieldAutoSize.CENTER
            ..text = text;
        textField..x = -textField.width ~/ 2;
        break;
      case Direction.LEFT: 
        line.graphics.lineTo(-length,0);
        textField = new TextField()
            ..defaultTextFormat = fmt
            ..autoSize = TextFieldAutoSize.CENTER
            ..rotation = -PI/2
            ..x = -length - padding
            ..text = text;
        textField..y = textField.width ~/ 2;
        break;       
      case Direction.UP:
        line.graphics.lineTo(0, -length);
        textField = new TextField()
            ..defaultTextFormat = fmt
            ..y = -length -padding - 14
            ..autoSize = TextFieldAutoSize.CENTER
            ..text = text;
        textField..x = -textField.width ~/ 2;        
        break;
      case Direction.RIGHT: 
        line.graphics.lineTo(length,0);
        textField = new TextField()
            ..defaultTextFormat = fmt
            ..autoSize = TextFieldAutoSize.LEFT
            ..rotation = PI/2
            ..x = length + padding + 14
            ..text = text;
        textField..y = -textField.width ~/ 2;
        print("width=${textField.width}");
        break;       
    }


    line.graphics.strokeColor(Color.Black, 1);

    addChild(line);
    addChild(textField);
  }

}

main() {
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  stage.backgroundColor = Color.Beige;
  addGrid();

  var tickDown = new Tick("A really superlong Text", 20, 10, Direction.DOWN)
      ..x = 100
      ..y = 100;
  stage.addChild(tickDown);

  var tickUp = new Tick("A text for an UP Tick", 20, 10, Direction.UP)
      ..x = 100
      ..y = 400;
  stage.addChild(tickUp);

  var tickLeft = new Tick("Another long text label", 20, 10, Direction.LEFT)
      ..x = 300
      ..y = 100;
  stage.addChild(tickLeft);

  var tickRight = new Tick("A text for a RIGHT tick", 20, 10, Direction.RIGHT)
      ..x = 300
      ..y = 400;
  stage.addChild(tickRight);

  
  var dataURL = canvas.toDataUrl();
  print(dataURL);

}
