library axis_sketch;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

Stage stage = new Stage(html.querySelector('#stage'));

RenderLoop renderLoop = new RenderLoop();

class Direction {
  static const int UP   = 1;
  static const int DOWN = 2;
  static const int LEFT   = 1;
  static const int RIGHT = 2;
}


class Tick extends DisplayObjectContainer {
  
  Shape line;
  TextField textField;
  
  Tick(int direction, 
       int length, 
       int padding, 
       String text) {
    line = new Shape();
    if (direction == Direction.DOWN) {
      line.graphics.moveTo(0, 0);
      line.graphics.lineTo(0, length);
      var fmt = new TextFormat("Arial", 14, Color.Black);
      textField = new TextField(text, fmt)
        ..y = length + padding;
    } else if (direction == Direction.UP) {
      line.graphics.lineTo(0, -length);      
    } else if (direction == Direction.RIGHT) {
      line.graphics.lineTo(length,0);
    } else if (direction == Direction.LEFT) {
      line.graphics.lineTo(-length,0);      
    }
    line.graphics.strokeColor(Color.Black, 1);
    
    addChild(line);
    addChild(textField);
  }
  
}

class Axis extends DisplayObjectContainer {
  
  
  
}


main(){
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  stage.backgroundColor = Color.Beige;
  
  var tick1 = new Tick(Direction.DOWN, 20, 5, "Text")
    ..x = 100
    ..y = 100;
  
  stage.addChild(tick1);
  
  
}