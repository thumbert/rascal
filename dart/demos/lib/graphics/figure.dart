library graphics.figure;

import 'dart:math' show min, max, PI;

import 'package:tuple/tuple.dart';
import 'package:stagexl/stagexl.dart';
import 'plot_line.dart';
import 'theme.dart';
import 'axis.dart';
import 'drawable.dart';
import 'key.dart';
import 'axis_numeric.dart';
import 'scale.dart';

class Figure extends DisplayObjectContainer implements Drawable {
  Stage stage;
  TextField tooltip;
  Theme theme = Theme.basic;
  Map<Position,Axis> axes;
  Key key;

  /// the bottom axis
  Axis xAxis;

  /// the left axis
  Axis yAxis;

  /// the plot area
  PlotArea _plotArea;
  /// keep track of the order of colors for multiple series
  int _colorIndex = 0;
  /// the axis limits, and the extended axis limits
  Tuple2<num, num> _xLim;
  Tuple2<num, num> _yLim;
  bool _xLimFixed = false;
  bool _yLimFixed = false;
  /// guess the axis type from the data
  AxisType _axisTypeBottom, _axisTypeLeft;


  Figure(this.stage) {
    this.addTo(stage);

    _plotArea = new PlotArea(this);
    _plotArea.addTo(this);
  }

  /// Set the X axis limits for numerical values
  set xLim(Tuple2<num, num> values) {
    _xLimFixed = true;
    _xLim = values;
  }
  Tuple2<num, num> get xLim => _xLim;

  /// Set the Y axis limits for numerical values
  set yLim(Tuple2<num, num> values) {
    _yLimFixed = true;
    _yLim = values;
  }
  Tuple2<num, num> get yLim => _yLim;

  /// Usually the scales are set automatically by the data.  If extra control
  /// is needed, or a special scale is used, the variables can be set.
  Function xScale, yScale;

  /// Label for the X axis
  String xLabel;

  /// Label for the Y axis
  String yLabel;

  /// Customize the location of the ticks on the X axis
  List<num> xTicks;

  /// Customize the location of the ticks on the Y axis
  List<num> yTicks;

  /// draw a line in the plot area of the active panel
  void line(List xData, List yData, {int color, num strokeWidth: 1.5}) {
    if (color == null) {
      color = theme.colors[_colorIndex % theme.colors.length];
      _colorIndex += 1;
    }

    if (_axisTypeBottom == null) _axisTypeBottom = Axis.getAxisType(xData);
    if (_axisTypeLeft == null) _axisTypeLeft = Axis.getAxisType(yData);

    if (!_xLimFixed) {
      var aux = new AxisLimits.fromData(xData);
      if (xLim == null)
        _xLim = new Tuple2(aux.minData, aux.maxData);
      else
        _xLim = new Tuple2(min(aux.minData, xLim.i1), max(aux.maxData, xLim.i2));
    }
    if (!_yLimFixed) {
      var aux = new AxisLimits.fromData(yData);
      if (yLim == null)
        _yLim = new Tuple2(aux.minData, aux.maxData);
      else
        _yLim = new Tuple2(min(aux.minData, yLim.i1), max(aux.maxData, yLim.i2));
    }

    var lp = new LinePlot(this,
        xData,
        yData,
        color: color,
        strokeWidth: strokeWidth);
    lp.name = 'draw-line:$_colorIndex';
    _plotArea.addChild(lp);
  }

  /// Calculate the x coordinate of the plotArea
  num _plotAreaX() {
    num x = theme.margin[Margin.left];
    return x;
  }

  /// Calculate the y coordinate of the plotArea
  num _plotAreaY() {
    num y = theme.margin[Margin.top];
    return y;
  }

  /// Calculate the width of the plotArea, it depends of axis labels, the key, title, etc.
  num _plotAreaWidth() {
    num _width = stage.stageWidth - (theme.margin[Margin.left] + theme.margin[Margin.right]);
    return _width;
  }

  /// Calculate the height of the plotArea, it depends of axis labels, the key, title, etc.
  num _plotAreaHeight() {
    num _height = stage.stageHeight - (theme.margin[Margin.top] + theme.margin[Margin.bottom]);
    return _height;
  }

  /// draw this figure
  void draw() {

    _plotArea.graphics.rect(0, 0, _plotAreaWidth(), _plotAreaHeight());
    _plotArea.graphics.fillColor(Color.White);
    _plotArea
      ..x = _plotAreaX()
      ..y = _plotAreaY();


    num hX = theme.borderSpaceToData;
    num hY = theme.borderSpaceToData;

    xScale = new LinearScale(xLim.i1, xLim.i2, hX, _plotAreaWidth() - hX);
    yScale = new LinearScale(yLim.i1, yLim.i2, _plotAreaHeight() - hY, hY);

    if (_axisTypeBottom == AxisType.numeric) {
      Scale scale = new LinearScale(xLim.i1, xLim.i2, 0, _plotAreaWidth()-2*hX);
      xAxis = new NumericAxis(scale, Position.bottom);
    }
    xAxis.addTo(_plotArea);
    xAxis.x = hX;
    xAxis.y = _plotAreaHeight();
    xAxis.name = 'draw-bottomAxis';

    if (_axisTypeLeft == AxisType.numeric) {
      Scale scale = new LinearScale(yLim.i1, yLim.i2, _plotAreaHeight()-2*hY, 0);
      yAxis = new NumericAxis(scale, Position.left);
    }
    yAxis.addTo(_plotArea);
    yAxis.x = 0;
    //yAxis.y = _plotAreaHeight() - hY;
    yAxis.y = hY;
    yAxis.rotation = -PI/2;
    yAxis.name = 'draw-leftAxis';


    /// draw all the children
    children.where((e) => e.name.startsWith('draw')).forEach((e) => e.draw());
  }
}

class PlotArea extends Sprite implements Drawable {
  Figure figure;

  PlotArea(this.figure) {
    name = 'draw-plotArea';
  }

  void draw() {
    //print('plotArea width: $width');
    children.where((e) => e.name.startsWith('draw')).forEach((e) => e.draw());
  }
}
