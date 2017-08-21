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

  /// direction of the ticks
  TickDirection tickDirection;

  /// tick orientation relative to the axis (towards outside or inside)
  /// not needed if angle is set
  TickOrientation tickOrientation;

  /// the text label for this tick
  String text;

  /// polar angle to define the orientation of the ticks
  num angle;

  /// Tick format.
  TickFormat(this.length, this.padding, this.color, this.textFormat,
      {this.width: 1, this.tickOrientation: TickOrientation.outside});

  TickFormat.fromTheme(Theme theme) {
    //TODO
  }
}


 /// An axis tick.  Draws the line tick and the text label.
 /// [text] is the tick label.
 /// [tickFormat] is the format of the tick
class Tick extends Sprite {
  TickFormat tickFormat;
  TextField textField;

  Tick(this.tickFormat) {
    draw();
  }

  void draw() {
    var fmt = tickFormat.textFormat;
    Shape line = new Shape();
    line.graphics.moveTo(-0.5, 0.5);

    print(tickFormat.tickDirection);

    /// TODO:  implement tick angle, tickOrientation
    switch (tickFormat.tickDirection) {
      case TickDirection.down:
        line.graphics.lineTo(-0.5, tickFormat.length);
        textField = new TextField()
          ..defaultTextFormat = fmt
          ..y = tickFormat.length + tickFormat.padding
          ..autoSize = TextFieldAutoSize.CENTER
          ..text = tickFormat.text;
        textField..x = -textField.width ~/ 2;
        break;
      case TickDirection.left:
        line.graphics.lineTo(-tickFormat.length, 0);
        textField = new TextField()
          ..defaultTextFormat = fmt
          ..autoSize = TextFieldAutoSize.CENTER
          ..text = tickFormat.text;
        textField.x = -textField.width - tickFormat.length - tickFormat.padding -2;
        textField.y = -textField.height ~/ 2 -2;
        break;
      case TickDirection.up:
        line.graphics.lineTo(0, -tickFormat.length);
        textField = new TextField()
          ..defaultTextFormat = fmt
          ..y = -tickFormat.length - tickFormat.padding - 14
          ..autoSize = TextFieldAutoSize.CENTER
          ..text = tickFormat.text;
        textField..x = -textField.width ~/ 2;
        break;
      case TickDirection.right:
        line.graphics.lineTo(tickFormat.length, 0);
        textField = new TextField()
          ..defaultTextFormat = fmt
          ..autoSize = TextFieldAutoSize.LEFT
          ..rotation = PI / 2
          ..x = tickFormat.length + tickFormat.padding + 14
          ..text = tickFormat.text;
        textField..y = -textField.width ~/ 2;
        break;
    }
    line.graphics.strokeColor(Color.Black, 1, JointStyle.MITER, CapsStyle.SQUARE);

    textField.name = 'tick-label';

    addChild(line);
    addChild(textField);
  }
}
