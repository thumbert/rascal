library graphics.tick;

import 'dart:math';
import 'package:stagexl/stagexl.dart';

import 'theme.dart';
import 'tick_utils.dart';

/// Format a tick
class TickFormat {
  /// tick length in points
  num length;

  /// tick width
  num width;

  /// tick padding in points (distance from the end of the tick to the tick label)
  num padding;

  /// tick color
  int color;

  /// text format for this tick
  TextFormat textFormat;

  /// tick orientation relative to the axis (towards outside or inside)
  /// not needed if angle is set
  TickOrientation tickOrientation;

  /// polar angle to define the orientation of the ticks
  num angle;

  /// Tick format.
  TickFormat(this.length, this.padding, this.color, this.textFormat,
      {this.width: 1, this.tickOrientation: TickOrientation.outside});
}


 /// An axis tick.  Draws the line tick and the text label.
 /// [text] is the tick label.
 /// [tickFormat] is the format of the tick
class Tick extends Sprite {
  String text;
  TickFormat tickFormat;
  int direction;

  Tick({this.text: '', this.tickFormat}) {
    tickFormat ??= Theme.basic.tickFormat;
  }

  void draw() {
    TextField textField;
    var fmt = tickFormat.textFormat;
    Shape line = new Shape();
    line.graphics.moveTo(-0.5, 0);

    /// TODO:  implement tick angle, tickOrientation
    switch (direction) {
      case TickDirection.down:
        line.graphics.lineTo(-0.5, tickFormat.length);
        textField = new TextField()
          ..defaultTextFormat = fmt
          ..y = tickFormat.length + tickFormat.padding
          ..autoSize = TextFieldAutoSize.CENTER
          ..text = text;
        textField..x = -textField.width ~/ 2;
        break;
      case TickDirection.left:
        line.graphics.lineTo(-tickFormat.length, 0);
        textField = new TextField()
          ..defaultTextFormat = fmt
          ..autoSize = TextFieldAutoSize.CENTER
          ..text = text;
        textField.x = -textField.width - tickFormat.length - tickFormat.padding -2;
        textField.y = -textField.height ~/ 2 -2;
        break;
      case TickDirection.up:
        line.graphics.lineTo(0, -tickFormat.length);
        textField = new TextField()
          ..defaultTextFormat = fmt
          ..y = -tickFormat.length - tickFormat.padding - 14
          ..autoSize = TextFieldAutoSize.CENTER
          ..text = text;
        textField..x = -textField.width ~/ 2;
        break;
      case TickDirection.right:
        line.graphics.lineTo(tickFormat.length, 0);
        textField = new TextField()
          ..defaultTextFormat = fmt
          ..autoSize = TextFieldAutoSize.LEFT
          ..rotation = PI / 2
          ..x = tickFormat.length + tickFormat.padding + 14
          ..text = text;
        textField..y = -textField.width ~/ 2;
        //print("width=${textField.width}");
        break;
    }
    line.graphics.strokeColor(Color.Black, 1, JointStyle.MITER, CapsStyle.SQUARE);

    addChild(line);
    addChild(textField);
  }
}
