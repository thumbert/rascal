library graphics.theme;

import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/tick.dart';
import 'package:demos/graphics/tick_utils.dart';
import 'package:demos/graphics/layout.dart';

enum Margin { bottom, left, top, right }

abstract class Theme {

  /// layout of the panels
  Layout layout;

  /// plot area background color
  int plotAreaBackgroundColor;

  /// font size
  int fontSize;

  /// the textFormat for Axis labels, ticks and all other annotations.
  TextFormat textFormat;

  /// the format of the ticks
  TickFormat tickFormat;

  /// tick orientation (towards outside or inside of the plot area)
  TickOrientation tickOrientation;

  /// default margins in points
  Map<Margin, num> margin;

  /// default distance between the [min,max] of the data and the plot area width, in points
  num borderSpaceToData;

  /// list of colors to be used for multiple series
  List colors;

  static Theme basic = new BasicTheme();
}

class BasicTheme extends Theme {
  BasicTheme() {
    plotAreaBackgroundColor = Color.White;
    fontSize = 20;
    textFormat = new TextFormat("Arial", fontSize, Color.Black,
        align: TextFormatAlign.CENTER);
    tickFormat = new TickFormat(14, 3, Color.Black, textFormat);
    tickOrientation = TickOrientation.outside;


    borderSpaceToData = 15;
    margin = {
      Margin.bottom: 5 * fontSize,
      Margin.left: 4 * fontSize,
      Margin.top: 3 * fontSize,
      Margin.right: 3 * fontSize
    };

    colors = [
      0xFF4184F3,
      0xFFDB4437,
      0xFFF4B400,
      0xFF0F9D58,
      0xFFAA46BB,
      0xFF00ABC0,
      0xFFFF6F42,
      0xFF9D9C23,
      0xFF5B6ABF,
      0xFFEF6191,
      0xFF00786A,
      0xFFC1175A,
      0xFF0080ff,
      0xFFff00ff,
      0xFF006400,
      0xFFff0000,
      0xFFffa500,
      0xFF00ff00,
      0xFF4184F3,
      0xFF2955C5
    ];
  }
}
