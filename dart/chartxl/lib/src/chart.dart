library chart;


import 'package:chartxl/src/theme.dart';
import 'package:stagexl/stagexl.dart';


class Chart extends DisplayObjectContainer with Theme {

  //num height;
  //num width;
  List<Map> data;

  num get height => stage.height;
  num get width  => stage.width;
  
  num get topleftX => marginTop*textSize;
  num get topleftY => marginLeft*textSize;
  num get bottomrightX => width  - marginBottom*textSize;
  num get bottomrightY => height - marginRight*textSize;
  
 
  
  num _scaleX(num x) => 0;
  
  
  /**
   * Each element of data contains a Map with keys: "x", "y", "group", "panel".  
   * If "x" is missing, it's assumed to be 1:length(y). 
   */
  Chart() {
    // set the default theme.  How to do nice injection?
    setTheme(new DefaultTheme());
        
    //_drawBox();
    
    
    
  }

  
  
  void draw() {
    _drawBox();
    
  }
  
  void _drawBox() {
    // you cannot call this until the Chart is attached 
    print("width = $width, height = $height");
    
    Shape box = new Shape();
    print("topleftX=${topleftX}, topleftY=${topleftY}, width=${width}");
    box.graphics.rect(topleftX, topleftY, width-topleftX-marginRight*textSize, height-topleftY-marginBottom*textSize);    
    box.graphics.strokeColor(Color.Black);
    addChild(box);
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
    alignTicks = theme.alignTicks;
    backgroundColor = theme.backgroundColor;
    borderColor = theme.borderColor;
    borderWidth = theme.borderWidth;

    //height = theme.height;
    //width = theme.width;
    
    
    textSize = theme.textSize;
    
    // Distance between the outer edge of the chart and the plot area, 
    // as multiple of text size
    marginBottom = theme.marginBottom;
    marginLeft   = theme.marginLeft;
    marginTop    = theme.marginTop;
    marginRight  = theme.marginRight;
        
    plotBackgroundColor = theme.plotBackgroundColor;  
    plotBorderWidth = theme.plotBorderWidth;
    
    // distance between the chart area and the outside text 
    // as multiple of text size
    spacingBottom = theme.spacingBottom;
    spacingLeft   = theme.spacingLeft;
    spacingTop    = theme.spacingTop;
    spacingRight  = theme.spacingRight;
    
  }


}
