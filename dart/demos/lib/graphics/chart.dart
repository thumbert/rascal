
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
  num plotAreaWidth = 600;
  num plotAreaHeight = 400;

  /// axis limits
  Tuple2<num,num> _xlim, _ylim;


  Chart() {

    _plotArea = new PlotArea(plotAreaWidth, plotAreaHeight);
    _plotArea.x = 100;
    _plotArea.y = 100;

    addChild(_plotArea);

  }


  void xLimit(Tuple2<num,num> x) {
    _xlim = x;
    /// Add an axis to the plot area
    _plotArea.myScaleX = new LinearScale(x.item1, x.item2, 0, plotAreaWidth);
    xAxis = new NumericAxis(_plotArea.myScaleX, Position.bottom);
    xAxis.y = _plotArea.height;
    _plotArea.addChild(xAxis);
  }

  void yLimit(Tuple2<num,num> x) {
    _ylim = x;
    /// Add an axis to the plot area
    Scale scaleY = new LinearScale(x.item1, x.item2, plotAreaHeight, 0);
    yAxis = new NumericAxis(scaleY, Position.left);
    _plotArea.addChild(yAxis);
  }

}



