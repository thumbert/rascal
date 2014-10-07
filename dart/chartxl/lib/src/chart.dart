library chart;


import 'package:chartxl/src/theme.dart';
import 'package:stagexl/stagexl.dart';
import 'package:chartxl/src/axis.dart';


class Chart extends DisplayObjectContainer {

  //num height;
  //num width;
  List<Map> data;
  List<Axis> axes; 

  num get height => stage.height;
  num get width  => stage.width;
  
  num get topleftX => theme.marginLeft * theme.textSize;
  num get topleftY => theme.marginTop * theme.textSize;
  num get bottomrightX => width  - theme.marginBottom * theme.textSize;
  num get bottomrightY => height - theme.marginRight * theme.textSize;
  
 
  
  num _scaleX(num x) => 0;
  
  
  /**
   * Each element of data contains a Map with keys: "x", "y", "group", "panel".  
   * If "x" is missing, it's assumed to be 1:length(y). 
   */
  Chart() {
    // set the default theme.  How to do nice injection?
    //setTheme(new DefaultTheme());
        
    //_drawBox();
    draw();
    
    
  }

  
  
  void draw() {
    _drawBox();
    
  }
  
  void _drawBox() {
    // you cannot call this until the Chart is attached 
    print("width = $width, height = $height");
    
    Shape box = new Shape();
    print("topleftX=${topleftX}, topleftY=${topleftY}, width=${width}");
    box.graphics.rect(topleftX, topleftY, 
        width-topleftX-theme.marginRight*theme.textSize, 
        height-topleftY-theme.marginBottom*theme.textSize);    
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
      Axis xAxis = new Axis();      
    }

  }

  // set all the properties directly in the chart
//  void setTheme(Theme theme) {
//    alignTicks = theme.alignTicks;
//    backgroundColor = theme.backgroundColor;
//    borderColor = theme.borderColor;
//    borderWidth = theme.borderWidth;
//
//    //height = theme.height;
//    //width = theme.width;
//    
//    
//    textSize = theme.textSize;
//    
//    // Distance between the outer edge of the chart and the plot area, 
//    // as multiple of text size
//    marginBottom = theme.marginBottom;
//    marginLeft   = theme.marginLeft;
//    marginTop    = theme.marginTop;
//    marginRight  = theme.marginRight;
//        
//    plotBackgroundColor = theme.plotBackgroundColor;  
//    plotBorderWidth = theme.plotBorderWidth;
//    
//    // distance between the chart area and the outside text 
//    // as multiple of text size
//    spacingBottom = theme.spacingBottom;
//    spacingLeft   = theme.spacingLeft;
//    spacingTop    = theme.spacingTop;
//    spacingRight  = theme.spacingRight;
//    
//  }


}
