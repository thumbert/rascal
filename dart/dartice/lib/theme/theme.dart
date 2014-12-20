library theme.theme;

import 'package:charted/core/core.dart';
import 'package:dartice/annotations/tick.dart';
import 'package:dartice/annotations/text.dart';


Theme theme = new DefaultTheme();

abstract class Theme extends Object with TickProperties, TextProperties {
  bool alignTicks;
  Color backgroundColor;
  Color borderColor;
  int borderWidth;

  //num height;
  //num width;


  // as multiple of text size
  List<num> get margin => [marginBottom, marginLeft, marginLeft, marginRight];
  num marginBottom;
  num marginLeft;
  num marginTop;
  num marginRight;

  Color plotBackgroundColor;
  num plotBorderWidth;

  List<num> get spacing => [spacingBottom, spacingLeft, spacingTop, spacingRight];
  num spacingBottom;
  num spacingLeft;
  num spacingTop;
  num spacingRight;

}


class DefaultTheme extends Theme {

  static final DefaultTheme _singleton = new DefaultTheme._internal();

  factory DefaultTheme() {
    return _singleton;
  }

  DefaultTheme._internal() {
    alignTicks = true;
    backgroundColor = new Color.fromRgb(255, 255, 255);  
    borderColor = new Color.fromRgb(0, 0, 0);
    borderWidth = 0;

    // Text Properties
    textSize = 14;
    textColor = new Color.fromRgb(0, 0, 0);

    // Tick Properties
    tickLength = 14;
    tickWidth = 1;
    tickColor = new Color.fromRgb(0, 0, 0);
    tickPadding = 14;          // distance between tick mark and text
    tickTextShift = 0;         // how many points away is label from the tick, 0 = Centered
    tickTextSameSide = true;   

    // Distance between the outer edge of the chart and the plot area,
    // as multiple of text size
    marginBottom = 6;
    marginLeft = 6;
    marginTop = 4;
    marginRight = 4;

    plotBackgroundColor = new Color.fromRgb(255, 255, 255);
    plotBorderWidth = 0;

    // distance between the chart area and the outside text as multiple of text size
    spacingBottom = 1;
    spacingLeft = 1;
    spacingTop = 1;
    spacingRight = 1;

  }

}
