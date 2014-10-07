library theme;

import 'package:stagexl/stagexl.dart';
import 'package:chartxl/src/tick.dart';
import 'package:chartxl/src/text.dart';

Theme theme = new DefaultTheme();

abstract class Theme extends Object with TickProperties, TextProperties {
  bool alignTicks;
  int backgroundColor;
  int borderColor;
  int borderWidth;

  //num height;
  //num width;


  // as multiple of text size
  List<num> get margin => [marginBottom, marginLeft, marginLeft, marginRight];
  num marginBottom;
  num marginLeft;
  num marginTop;
  num marginRight;

  int plotBackgroundColor;
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
    backgroundColor = Color.White;
    borderColor = Color.Black;
    borderWidth = 0;

    // Text Properties
    textSize = 14;
    textColor = Color.Black;

    // Tick Properties
    tickLength = 14;
    tickWidth = 1;
    tickColor = Color.Black;
    tickPadding = 14;          // distance between tick mark and text
    tickTextShift = 0;         // how many points away from the tick, 0 = Centered
    tickTextSameSide = true;   

    // Distance between the outer edge of the chart and the plot area,
    // as multiple of text size
    marginBottom = 5;
    marginLeft = 5;
    marginTop = 3;
    marginRight = 3;

    plotBackgroundColor = Color.White;
    plotBorderWidth = 0;

    // distance between the chart area and the outside text
    // as multiple of text size
    spacingBottom = 1;
    spacingLeft = 1;
    spacingTop = 1;
    spacingRight = 1;

  }

}
