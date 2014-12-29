library theme.theme;

import 'package:charted/core/core.dart';
import 'package:dartice/annotations/tick.dart';
import 'package:dartice/annotations/text.dart';


abstract class Theme extends Object with TickProperties, TextProperties {
  
  static Theme currentTheme = new DefaultTheme();
  
  bool alignTicks;
  String backgroundColor;
  
  /**
   * The border is the rectangle around the plot area.  Some plots don't need it, 
   * so I disable it for now. 
   */
  //Color borderColor;
  //int borderWidth;

  
  int height;          // figure height
  int width;           // figure width


  /**
   * Margin controls the space between the edges of the plot area and the figure area. 
   * It is given as a multiple of text size. 
   * 
   */ 
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

  List COLORS;         // list of colors to cycle through for lines, symbols, etc. 
  List STRIP_COLORS;   // list of colors to cycle through the panel strips
}


class DefaultTheme extends Theme {

  static final DefaultTheme _singleton = new DefaultTheme._internal();

  factory DefaultTheme() {
    return _singleton;
  }

  DefaultTheme._internal() {
    width = 500;    // figure width
    height = 500;   // figure height
    
    alignTicks = true;
    backgroundColor = "#ffffff"; //new Color.fromRgb(255, 255, 255);
    //borderColor = new Color.fromRgb(0, 0, 0);
    //borderWidth = 0;

    /**
     * Text Properties.  Many other relative dimensions get set relative to 
     * textSize, for example cex. 
     */
    textSize = 12;                          
    textColor = new Color.fromRgb(0, 0, 0);

    // Tick Properties
    tickLength = 14;
    tickWidth = 1;
    tickColor = new Color.fromRgb(0, 0, 0);
    tickPadding = 14; // distance between tick mark and text
    tickTextShift = 0; // how many points away is label from the tick, 0 = Centered
    tickTextSameSide = true;

    // Distance between the outer edge of the chart and the plot area,
    // as multiple of text size
    marginBottom = 6;
    marginLeft = 6;
    marginTop = 4;
    marginRight = 4;

    plotBackgroundColor = new Color.fromRgb(255, 255, 255);
    //plotBorderWidth = 0;

    // distance between the chart area and the outside text as multiple of text size
    spacingBottom = 1;
    spacingLeft = 1;
    spacingTop = 1;
    spacingRight = 1;

    COLORS = ['#4184F3', '#DB4437', '#F4B400', '#0F9D58', '#AA46BB', '#00ABC0',
              '#FF6F42', '#9D9C23', '#5B6ABF', '#EF6191', '#00786A', '#C1175A', 
              "#0080ff", "#ff00ff", "#006400", "#ff0000", "#ffa500", "#00ff00", 
              '#4184F3', '#2955C5'];
    STRIP_COLORS = [
        "#ffe5cc",
        "#ccffcc",
        "#ccffff",
        "#cce6ff",
        "#ffccff",
        "#ffcccc",
        "#ffffcc"];

    /**
     * Grid lines are reference lines. 
     */
    String gridLineColor = "#e6e6e6";
    Map REFERENCE_LINE = {
      "alpha": 1,
      "color": "#e6e6e6",
      "lty": 1,
      "lwd": 1
    };

    /**
     * Default symbol is an open circle
     */
    Map PLOT_SYMBOL = {
      "alpha": 1,
      "cex": 0.8,
      "color": "#0080ff",
      "fill": "transparent",
      "pch": 1
    };


  }

}
