library chart;


import 'package:chartxl/src/theme.dart';
import 'package:stagexl/stagexl.dart';


class Chart extends DisplayObjectContainer with Theme {

  num height;
  num width;
  List<Map> data;

  /**
   * Each element of data contains a Map with keys: "x", "y", "group", "panel".  
   * If "x" is missing, it's assumed to be 1:length(y). 
   */
  Chart(this.data) {}

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



}
