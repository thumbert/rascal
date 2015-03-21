library graphics.tick;

import 'package:stagexl/stagexl.dart';
import 'dart:math';

class Direction {
  static const int UP = 3;
  static const int DOWN = 1;
  static const int LEFT = 2;
  static const int RIGHT = 4;
}

/**
 * An axis tick.
 *
 * [text] is the tick label.
 * [direction] is one of Direction.UP, etc.
 * [length] is the length of the tick in pixels.
 * [padding] is the distance in points from the tick to the label.
 *
 */
class Tick extends Sprite {

  Shape line;
  TextField textField;

  Tick(String text, int direction, {int length: 14, int padding: 10}) {
    line = new Shape();
    line.graphics.moveTo(0, 0);
    var fmt = new TextFormat("Arial", 14, Color.Black, align: TextFormatAlign.CENTER);

    //print(direction);
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
