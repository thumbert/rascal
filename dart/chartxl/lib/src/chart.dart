library chart;


import 'package:chartxl/src/theme.dart';
import 'package:stagexl/stagexl.dart';


class Chart extends DisplayObjectContainer with Theme {

  num height;
  num width;
  List<Map> data;

  num get topleftX => marginTop*textSize;
  num get topleftY => marginLeft*textSize;
  num get bottomrightX => height - marginBottom*textSize;
  num get bottomrightY => width  - marginRight*textSize;
  
  
  num _scaleX(num x) => 0;
  
  
  /**
   * Each element of data contains a Map with keys: "x", "y", "group", "panel".  
   * If "x" is missing, it's assumed to be 1:length(y). 
   */
  Chart() {
    // set the default theme.  How to do nice injection?
    setTheme(new DefaultTheme());
    
  }

  
  
  void draw() {
    
  }
  
  bool hasGroups() {
    if (data.first.keys.contains("group")) return true; else return false;
  }
  bool hasPanels() {
    if (data.first.keys.contains("panel")) return true; else return false;
  }
  bool hasX() {
    if (data.first.keys.contains("x")) return true; else return false;
  }
  bool hasY() {
    if (data.first.keys.contains("y")) return true; else return false;
  }

  addAxes() {
    Map obs = data.first;
    if (obs.keys.contains("x")) {

    }

  }

  // set all the properties directly in the chart
  void setTheme(Theme theme) {
    bool alignTicks = theme.alignTicks;
    int backgroundColor = theme.backgroundColor;
    int borderColor = theme.borderColor;
    int borderWidth = theme.borderWidth;

    int textSize = theme.textSize;
    
    // Distance between the outer edge of the chart and the plot area, 
    // as multiple of text size
    num marginBottom = theme.marginBottom;
    num marginLeft   = theme.marginLeft;
    num marginTop    = theme.marginTop;
    num marginRight  = theme.marginRight;
        
    int plotBackgroundColor = theme.plotBackgroundColor;  
    num plotBorderWidth = theme.plotBorderWidth;
    
    // distance between the chart area and the outside text 
    // as multiple of text size
    num spacingBottom = theme.spacingBottom;
    num spacingLeft   = theme.spacingLeft;
    num spacingTop    = theme.spacingTop;
    num spacingRight  = theme.spacingRight;
    
  }


}
