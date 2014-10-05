library theme;

import 'package:stagexl/stagexl.dart';

Theme theme = new DefaultTheme();

abstract class Theme {
  bool alignTicks;  
  int backgroundColor;
  int borderColor;
  int borderWidth;

  //num height;
  //num width;
  
  int textSize;
  int textColor;
  
  int tickLength;
  int tickWidth;
  int tickColor;
  int tickPadding;           // distance between tick mark and text   
  
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
  bool alignTicks = true;
  int backgroundColor = Color.White;
  int borderColor = Color.Black;
  int borderWidth = 0;

  
  int textSize = 12;
  int textColor = Color.Black;
  
  int tickLength = 14;
  int tickWidth = 1;
  int tickColor = Color.Black;
  int tickPadding = 14;           // distance between tick mark and text   

  
  // Distance between the outer edge of the chart and the plot area, 
  // as multiple of text size
  num marginBottom = 5;
  num marginLeft   = 5;
  num marginTop    = 3;
  num marginRight  = 3;
      
  int plotBackgroundColor = Color.White;  
  num plotBorderWidth = 0;
  
  // distance between the chart area and the outside text 
  // as multiple of text size
  num spacingBottom = 1;
  num spacingLeft   = 1;
  num spacingTop    = 1;
  num spacingRight  = 1;
  
  
  
}