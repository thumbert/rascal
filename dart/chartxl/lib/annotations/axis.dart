library annotations.axis;

import 'package:chartxl/theme/theme.dart';
import 'package:chartxl/core/util.dart';

enum AxisType {NUMERIC, ORDINAL, DATETIME}   //TODO:  remove them when imports work
enum Direction {DOWN, LEFT, UP, RIGHT}
enum Position {BOTTOM, LEFT, TOP, RIGHT}


class Axis {
  AxisType axisType;
  
  
  String label;        
  num labelOffset;
  
  var max;
  num maxPadding = 0.01;
  var min;
  num minPadding = 0.01;     // distance in 
  
  String name;        //  a name for this axis for later use  
  
  num offset;         // distance in pixels from by which to displace the axis from the edge of the enclosing group or data rectangle
  Position position;
  
  Scale scale;        // linear, logarithmic or user defined
  
  num tickPadding;    // number of pixels between ticks and text labels
  num tickLength;     // the length in pixels of major, minor, and end ticks
  num tickWidth;      // the width in pixels of major, minor, and end ticks
  List<Tick> ticks;    
  
  Axis({Theme theme}) {
    if (theme == null) 
      theme = Theme.currentTheme;  
    
  }
}
