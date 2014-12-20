library annotations.tick;

import 'dart:math';
import 'package:dartice/theme/theme.dart';
import 'package:dartice/core/util.dart';
import 'package:dartice/annotations/text.dart';
import 'package:charted/core/core.dart';

// TODO:  remove me from here when editor gets smarter 
enum Direction {DOWN, LEFT, UP, RIGHT}
enum Position {BOTTOM, LEFT, TOP, RIGHT}


abstract class TickProperties {
  int tickLength;
  int tickWidth;
  Color tickColor;
  int tickPadding;       // distance between tick mark and text
  bool tickTextSameSide; // if text is on same side of axis as the tick
  num tickTextShift;     // how much to shift the text away from the tick center
}

/**
 * An axis tick mark.  It is contains a Shape (the tick mark) and 
 * a TextField (the tick label).  
 */
class Tick {

  //Shape line;
  TextField textField;
  TextFormat fmt;
  String label;
  Direction direction;
  Color textColor;
  num textRotation; // in radians
  int textSize;
  Color tickColor;
  int tickLength;
  int tickPadding;
  bool tickTextSameSide;
  num tickTextShift;
  int tickWidth;

  Tick(String this.label, Direction this.direction, {Theme theme, int this.tickLength, int this.tickPadding, int
      this.tickWidth, Color this.tickColor, num this.textRotation, int this.textSize, 
      Color this.textColor, bool this.tickTextSameSide, num this.tickTextShift}) {

    if (theme == null) theme = new DefaultTheme();               // for protection
    if (textSize == null) textSize = theme.textSize;
    if (textColor == null) textColor = theme.textColor;    
    if (tickColor == null) tickColor = theme.tickColor;
    if (tickLength == null) tickLength = theme.tickLength;
    if (tickPadding == null) tickPadding = theme.tickPadding;
    if (tickTextSameSide == null) tickTextSameSide = theme.tickTextSameSide;
    if (tickTextShift == null) tickTextShift = theme.tickTextShift;
    if (tickWidth == null) tickWidth = theme.tickWidth;
        
    draw();
  }

  void draw() {
//    line = new Shape();
//    line.graphics.moveTo(0, 0);
//    fmt = new TextFormat("Arial", textSize, textColor, align: TextFormatAlign.CENTER);
//
//    switch (direction) {
//      case Direction.DOWN:
//        if (textRotation == null) textRotation = 0;
//        line.graphics.lineTo(0, tickLength);
//        textField = new TextField()
//            ..defaultTextFormat = fmt
//            ..y = tickLength + tickPadding
//            ..autoSize = TextFieldAutoSize.CENTER
//            ..rotation = textRotation
//            ..text = text;
//        textField..x = (-textField.width*cos(textRotation) + textField.height*sin(textRotation)) ~/ 2;        
//        break;
//      case Direction.LEFT:
//        if (textRotation == null) textRotation = -PI/2;
//        line.graphics.lineTo(-tickLength, 0);
//        textField = new TextField()
//            ..defaultTextFormat = fmt
//            ..autoSize = TextFieldAutoSize.CENTER
//            ..rotation = textRotation
//            ..x = -tickLength - tickPadding
//            ..text = text;
//        textField..y = textField.width ~/ 2;
//        break;
//      case Direction.UP:
//        if (textRotation == null) textRotation=0;
//        line.graphics.lineTo(0, -tickLength);
//        textField = new TextField()
//            ..defaultTextFormat = fmt
//            ..y = -tickLength - tickPadding - textSize
//            ..autoSize = TextFieldAutoSize.CENTER
//            ..rotation = textRotation
//            ..text = text;
//        textField..x = -textField.width ~/ 2;
//        break;
//      case Direction.RIGHT:
//        if (textRotation == null) textRotation = PI/2;
//        line.graphics.lineTo(tickLength, 0);
//        textField = new TextField()
//            ..defaultTextFormat = fmt
//            ..autoSize = TextFieldAutoSize.LEFT
//            ..rotation = textRotation
//            ..x = tickLength + tickPadding + textSize
//            ..text = text;
//        textField..y = -textField.width ~/ 2;
//        break;
//    }
//
//
//    line.graphics.strokeColor(tickColor, tickWidth);
//
//    addChild(line);
//    addChild(textField);
//  }

  }
}
