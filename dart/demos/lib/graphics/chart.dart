
import 'package:stagexl/stagexl.dart';
import 'package:tuple/tuple.dart';

import 'axis.dart';
import 'axis_numeric.dart';
import 'axis_datetime_xl.dart';
import 'scale.dart';
import 'plot_area.dart';


class Chart extends Sprite {

  Axis xAxis;
  Axis yAxis;
  PlotArea _plotArea;


  /// default values
  num margin = 100;
  num _plotAreaWidth;
  num _plotAreaHeight;



  Chart() {
     _plotAreaWidth = 600;
     _plotAreaHeight = 400;

    _plotArea = new PlotArea(_plotAreaWidth, _plotAreaHeight);
    _plotArea.x = margin;
    _plotArea.y = margin;

    addChild(_plotArea);

  }


  void xLimit(xMin, xMax) {
    /// Add an axis to the plot area
    if (xMin is num) {
      Scale myScaleX = new LinearScale(xMin, xMax, 0, _plotAreaWidth);
      xAxis = new NumericAxis(myScaleX, Position.bottom);

    } else if ((xMin is DateTime) && (xMax is DateTime)) {
      Scale myScaleX = new LinearScale(xMin.millisecondsSinceEpoch, xMax.millisecondsSinceEpoch, 0, _plotAreaWidth);
      xAxis = new DateTimeAxisXl(myScaleX, Position.bottom);


    } else {
      throw 'Only numeric and DateTime xLimits are allowed';
    }

    xAxis.y = _plotArea.height;
    xAxis.name = 'xAxis';
    _plotArea.addChildAt(xAxis, 0);
  }

  void yLimit(num yMin, num yMax) {
    /// Add an axis to the plot area
    Scale scaleY = new LinearScale(yMin, yMax, _plotAreaHeight, 0);
    yAxis = new NumericAxis(scaleY, Position.left);
    yAxis.name = 'yAxis';
    _plotArea.addChildAt(yAxis, 1);
  }

}



