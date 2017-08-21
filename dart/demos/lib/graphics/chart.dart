import 'package:stagexl/stagexl.dart';
import 'package:tuple/tuple.dart';

import 'axis.dart';
import 'axis_numeric.dart';
import 'axis_datetime.dart';
import 'scale.dart';
import 'plot_area.dart';

class Chart extends Sprite {
  Axis xAxis;
  Axis yAxis;
  PlotArea _plotArea;

  /// default values
  /// size of the border between chart and plotArea
  num marginPlotArea = 100;
  /// distance between the edge of the plotArea and the start/end of the axis
  num marginAxis = 15;
  num _plotAreaWidth;
  num _plotAreaHeight;

  /// Can I move the stage declaration inside the Chart??
  /// TODO: pass in only the div to the chart constructor ...
  Chart(num width, num height) {
    this.width = width;
    this.height = height;
    _plotAreaWidth = width - 2*marginPlotArea;
    _plotAreaHeight = height - 2*marginPlotArea;

    _plotArea = new PlotArea(_plotAreaWidth, _plotAreaHeight);
    _plotArea.x = marginPlotArea;
    _plotArea.y = marginPlotArea;

    addChild(_plotArea);
  }

  /// Set the limits for the x-Axis.
  void xLimit(xMin, xMax) {
    AxisFormat axisFormat = new AxisFormat(Position.bottom);
    /// Add an axis to the plot area
    if ((xMin is num) && (xMax is num)) {
      Scale myScaleX = new LinearScale(xMin, xMax, marginAxis, _plotAreaWidth-marginAxis);
      xAxis = new NumericAxis(myScaleX, axisFormat);
    } else if ((xMin is DateTime) && (xMax is DateTime)) {
      Scale myScaleX = new DateTimeScale(xMin, xMax, marginAxis, _plotAreaWidth-marginAxis);
      xAxis = new DateTimeAxis(myScaleX, axisFormat);
    } else {
      throw 'Only numeric or DateTime xLimits are allowed';
    }

    xAxis.y = _plotArea.height;
    xAxis.name = 'xAxis';
    _plotArea.addChildAt(xAxis, 0);
  }

  /// Set the limits for the y-Axis.
  void yLimit(num yMin, num yMax) {
    AxisFormat axisFormat = new AxisFormat(Position.left);
    /// Add an axis to the plot area
    Scale scaleY = new LinearScale(yMin, yMax, _plotAreaHeight-marginAxis, marginAxis);
    yAxis = new NumericAxis(scaleY, axisFormat);
    yAxis.name = 'yAxis';
    _plotArea.addChildAt(yAxis, 1);
  }
}
