library tick;

import 'package:stagexl/stagexl.dart';
import 'package:chartxl/src/util.dart';
import 'dart:math';


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
        break;       
    }


    line.graphics.strokeColor(Color.Black, 1);

    addChild(line);
    addChild(textField);
  }

}
