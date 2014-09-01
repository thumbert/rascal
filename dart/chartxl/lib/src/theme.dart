library theme;

import 'package:stagexl/stagexl.dart';

abstract class Theme {
  bool alignTicks;  
  int backgroundColor;
  int borderColor;
  int borderWidth;

  // as multiple of text size
  List<num> margin;
  num marginBottom;
  num marginLeft;
  num marginTop;
  num marginRight;
      
  int plotBackgroundColor;  
  num plotBorderWidth;
  
  
}


class DefaultTheme extends Theme {
  bool alignTicks = true;
  int backgroundColor = Color.White;
  int borderColor = Color.Black;
  int borderWidth = 0;

  // Distance between the outer edge of the chart and the plot area, 
  // as multiple of text size
  List<num> margin = [5, 4, 3, 3];
  num marginBottom = 5;
  num marginLeft   = 4;
  num marginTop    = 3;
  num marginRight  = 3;
      
  int plotBackgroundColor = Color.White;  
  num plotBorderWidth = 0;
  
  // distance between the chart area and the outside text 
  // as multiple of text size
  List<num> spacing = [1, 1, 1, 1];
  num spacingBottom = 1;
  num spacingLeft   = 1;
  num spacingTop    = 1;
  num spacingRight  = 1;
  
  
  
}