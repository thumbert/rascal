library axis;

import 'package:chartxl/src/scale.dart';
import 'package:chartxl/src/tick.dart';
import 'package:chartxl/src/util.dart';
import 'package:stagexl/stagexl.dart';

class AxisType {
  static const int Numeric  = 1;
  static const int Category = 2;
  static const int Datetime = 3;
}

abstract class Axis {
  Color alternateGridColor;
  AxisType axisType;
  
  Color gridLineColor;
  String gridLineDashStyle = "Solid";
  num gridLineWidth = 1;
  
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
}

