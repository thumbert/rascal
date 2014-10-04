library tick;

import 'package:stagexl/stagexl.dart';
import 'package:chartxl/src/util.dart';
import 'dart:math';

class TickDefaults {
  int tickLength = 14;
  int tickWidth = 1;
  int tickColor = Color.Black;
}

/**
 * An axis tick mark.  It is constructed from a Shape and a TextField.  
 */
class Tick extends DisplayObjectContainer with TickDefaults {

  Shape line;
  TextField textField;
  TextFormat fmt;

  Tick(String text, int direction, {int tickLength: 14, int tickPadding: 14}) {
    line = new Shape();
    line.graphics.moveTo(0, 0);
    fmt = new TextFormat("Arial", 14, Color.Black, align: TextFormatAlign.CENTER);

    switch (direction) {
      case Direction.DOWN:
        line.graphics.lineTo(0, tickLength);
        textField = new TextField()
            ..defaultTextFormat = fmt
            ..y = tickLength + tickPadding
            ..autoSize = TextFieldAutoSize.CENTER
            ..text = text;
        textField..x = -textField.width ~/ 2;
        break;
      case Direction.LEFT: 
        line.graphics.lineTo(-tickLength,0);
        textField = new TextField()
            ..defaultTextFormat = fmt
            ..autoSize = TextFieldAutoSize.CENTER
            ..rotation = -PI/2
            ..x = -tickLength - tickPadding
            ..text = text;
        textField..y = textField.width ~/ 2;
        break;       
      case Direction.UP:
        line.graphics.lineTo(0, -tickLength);
        textField = new TextField()
            ..defaultTextFormat = fmt
            ..y = -tickLength -tickPadding - 14
            ..autoSize = TextFieldAutoSize.CENTER
            ..text = text;
        textField..x = -textField.width ~/ 2;        
        break;
      case Direction.RIGHT: 
        line.graphics.lineTo(tickLength,0);
        textField = new TextField()
            ..defaultTextFormat = fmt
            ..autoSize = TextFieldAutoSize.LEFT
            ..rotation = PI/2
            ..x = tickLength + tickPadding + 14
            ..text = text;
        textField..y = -textField.width ~/ 2;
        break;       
    }


    line.graphics.strokeColor(tickColor, tickWidth);

    addChild(line);
    addChild(textField);
  }

}
