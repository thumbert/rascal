library chart;


import 'package:chartxl/src/theme.dart';
import 'package:stagexl/stagexl.dart';
import 'package:chartxl/src/axis.dart';


class PlotArea extends DisplayObjectContainer {
  
   
  PlotArea(num width, num height) {
    Shape background = new Shape()
      ..width = width
      ..height = height
      ..graphics.rect(0, 0, width, height)    
      ..graphics.strokeColor(Color.Black, 1, JointStyle.MITER, CapsStyle.BUTT)
      ..graphics.fillColor(Color.AntiqueWhite);
    
    
    addChild(background);   
  } 
  
}


class Chart extends DisplayObjectContainer {

  num height;
  num width;
  List<Map> data;
  List<Axis> axes; 
  
  //num get height => stage.height;
  //num get width  => stage.width;
  
  
  num get plotAreaX => theme.marginLeft * theme.textSize;
  num get plotAreaY => theme.marginTop * theme.textSize;
  num get plotAreaWidth => width  - (theme.marginBottom + theme.marginTop)*theme.textSize;
  num get plotAreaHeight => height - (theme.marginRight + theme.marginLeft)*theme.textSize;
  
  
  PlotArea plotArea;
  
  num _scaleX(num x) => 0;
  
  
  /**
   * Each element of data contains a Map with keys: "x", "y", "group", "panel".  
   * If "x" is missing, it's assumed to be 1:length(y). 
   */
  Chart(num this.width, num this.height) {
    if (theme == null) theme = new DefaultTheme();     
    
    plotArea = new PlotArea(plotAreaWidth, plotAreaHeight)
      ..x = plotAreaX
      ..y = plotAreaY;
    print("width=${width}, heigth=${height}");
    print("plotAreaWidth = ${plotAreaWidth}, plotAreaHeight = ${plotAreaHeight}, plotAreaX =${plotAreaX}");
    addChild(plotArea); 
  }

  
  
  void draw() {
    
    
    //addChild(plotArea); 
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
