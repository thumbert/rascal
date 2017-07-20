
import 'package:stagexl/stagexl.dart';
import 'package:tuple/tuple.dart';

import 'axis.dart';
import 'axis_numeric.dart';
import 'scale.dart';
import 'plot_area.dart';


class Chart extends Sprite {

  Axis xAxis;
  Axis yAxis;
  PlotArea _plotArea;

  /// data range
  DateTime startDate, endDate;
  num yMin, yMax;

  /// default values
  num margin = 100;
  num _plotAreaWidth;
  num _plotAreaHeight;

  /// axis limits
  Tuple2<num,num> _xlim, _ylim;


  Chart() {
     _plotAreaWidth = 600;
     _plotAreaHeight = 400;

    _plotArea = new PlotArea(_plotAreaWidth, _plotAreaHeight);
    _plotArea.x = margin;
    _plotArea.y = margin;

    addChild(_plotArea);

  }


  void xLimit(Tuple2<num,num> x) {
    _xlim = x;
    /// Add an axis to the plot area
    _plotArea.myScaleX = new LinearScale(x.item1, x.item2, 0, _plotAreaWidth);
    xAxis = new NumericAxis(_plotArea.myScaleX, Position.bottom);
    xAxis.y = _plotArea.height;
    xAxis.name = 'xAxis';
    _plotArea.addChildAt(xAxis, 0);
  }

  void yLimit(Tuple2<num,num> x) {
    _ylim = x;
    /// Add an axis to the plot area
    Scale scaleY = new LinearScale(x.item1, x.item2, _plotAreaHeight, 0);
    yAxis = new NumericAxis(scaleY, Position.left);
    yAxis.name = 'yAxis';
    _plotArea.addChildAt(yAxis, 1);
  }

}



