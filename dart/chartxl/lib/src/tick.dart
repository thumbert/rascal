library tick;

import 'package:stagexl/stagexl.dart';
import 'package:chartxl/src/util.dart';
import 'dart:math';
import 'package:chartxl/src/text.dart';
import 'package:chartxl/src/theme.dart';

class TickDefaults {
  static const int tickLength = 14;
  static const int tickWidth = 1;
  static const int tickColor = Color.Black;
  static const int tickPadding = 14;           // distance between tick mark and text   
}

/**
 * An axis tick mark.  It is contains a Shape (the tick mark) and 
 * a TextField (the tick label).  
 */
class Tick extends DisplayObjectContainer {

  Shape line;
  TextField textField;
  TextFormat fmt;
  String text;
  int direction;
  num textRotation;    // in radians
  int tickLength;
  int tickPadding;
  int tickColor;
  int tickWidth;
  int textSize;
  
  Tick(String this.text, int this.direction, {int this.tickLength, int this.tickPadding, 
    int this.tickWidth, int this.tickColor, num this.textRotation, int this.textSize}) {
    
    tickLength  == null ? theme.tickLength : tickLength;
    tickPadding == null ? theme.tickPadding : tickPadding;
    tickColor   == null ? theme.tickColor : tickColor;
    tickPadding == null ? theme.tickPadding : tickPadding;
    textSize    == null ? theme.textSize : textSize;
    
    draw();
  }
  
  void draw() {
    line = new Shape();
    line.graphics.moveTo(0, 0);
    fmt = new TextFormat("Arial", 14, Color.Black, align: TextFormatAlign.CENTER);

    switch (direction) {
      case Direction.DOWN:
        textRotation == null ? 0 : textRotation;
        line.graphics.lineTo(0, theme.tickLength);
        textField = new TextField()
            ..defaultTextFormat = fmt
            ..y = tickLength + tickPadding
            ..autoSize = TextFieldAutoSize.CENTER
            ..rotation = textRotation
            ..text = text;
        textField..x = -textField.width ~/ 2;
        break;
      case Direction.LEFT: 
        textRotation == null ? -PI/2 : textRotation;
        line.graphics.lineTo(-tickLength,0);
        textField = new TextField()
            ..defaultTextFormat = fmt
            ..autoSize = TextFieldAutoSize.CENTER
            ..rotation = textRotation
            ..x = -tickLength - tickPadding
            ..text = text;
        textField..y = textField.width ~/ 2;
        break;       
      case Direction.UP:
        textRotation == null ? 0 : textRotation;
        line.graphics.lineTo(0, -tickLength);
        textField = new TextField()
            ..defaultTextFormat = fmt
            ..y = -tickLength -tickPadding - 14
            ..autoSize = TextFieldAutoSize.CENTER
            ..rotation = textRotation
            ..text = text;
        textField..x = -textField.width ~/ 2;        
        break;
      case Direction.RIGHT: 
        textRotation == null ? PI/2 : textRotation;
        line.graphics.lineTo(tickLength,0);
        textField = new TextField()
            ..defaultTextFormat = fmt
            ..autoSize = TextFieldAutoSize.LEFT
            ..rotation = textRotation
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
