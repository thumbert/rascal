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
  //Stage stage;
  TextField tooltip;
  Theme theme = Theme.basic;
  Map<Position,Axis> axes;
  Key key;

  /// the bottom axis
  Axis xAxis;

  /// the left axis
  Axis yAxis;

  /// the top axis (is null for the default figure)
  Axis topAxis;

  /// the right axis (useful for timeseries or if you need to plot
  /// several series with different scales)
  Axis rightAxis;

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

  TextField _xLabel;
  TextField _yLabel;
  TextField _title;

  /// Instantiate a Figure with a stage only if you don't need a layout
  /// and you want this figure on the stage.
  Figure() {
    _plotArea = new PlotArea(this);
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
  TextField get xLabel => _xLabel;

  /// set the value of the x axis label.  You can pass in either a TextField
  /// or a String which gets formatted with [theme.textFormat].
  set xLabel(value) {
    if (value is TextField) {
      _xLabel = value;
    } else {
      _xLabel = new TextField(value.toString(), theme.textFormat);
    }
  }

  /// Label for the Y axis
  TextField get yLabel => _yLabel;

  /// set the value of the y axis label.  You can pass in either a TextField
  /// or a String which gets formatted with [theme.textFormat].
  set yLabel(value) {
    if (value is TextField) {
      _yLabel = value;
    } else {
      _yLabel = new TextField(value.toString(), theme.textFormat);
    }
  }


  /// the title of the figure
  TextField get title => _title;

  /// set the value of the title of the figure.  You can pass in either a TextField
  /// or a String which gets formatted with [theme.textFormat].
  set title(value) {
    if (value is TextField) {
      _title = value;
    } else {
      _title = new TextField(value.toString(), theme.textFormat);
    }
  }


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
    num _width = parent.width - (theme.margin[Margin.left] + theme.margin[Margin.right]);
    return _width;
  }

  /// Calculate the height of the plotArea, it depends of axis labels, the key, title, etc.
  num _plotAreaHeight() {
    num _height = parent.height - (theme.margin[Margin.top] + theme.margin[Margin.bottom]);
    return _height;
  }

  /// draw this figure
  void draw() {
    print('parent.width=${parent.width}');
    print('is parent stage ${parent == stage}');
    /// the parent of this figure should have dimensions set before calling draw.
    _plotArea.addTo(this);

    /// draw the plot area first
    _plotArea.graphics.rect(0, 0, _plotAreaWidth(), _plotAreaHeight());
    _plotArea.graphics.fillColor(Color.White);
    _plotArea
      ..x = _plotAreaX()
      ..y = _plotAreaY();

    if (title != null) {
      title.autoSize = TextFieldAutoSize.CENTER;
      _plotArea.addChild(title);
      title.alignPivot(HorizontalAlign.Center);
      title.x = _plotAreaWidth()/2;
      title.y = - 2*theme.textFormat.size;
    }


    num hX = theme.borderSpaceToData;
    num hY = theme.borderSpaceToData;

    xScale = new LinearScale(xLim.i1, xLim.i2, hX, _plotAreaWidth() - hX);
    yScale = new LinearScale(yLim.i1, yLim.i2, _plotAreaHeight() - hY, hY);

    _constructAxes();

    /// draw all the children
    children.where((e) => e.name.startsWith('draw')).forEach((e) => e.draw());
  }

  void _constructAxes() {
    if (_axisTypeBottom == AxisType.numeric) {
      Scale scale = new LinearScale(xLim.i1, xLim.i2, 0, _plotAreaWidth()-2*theme.borderSpaceToData);
      xAxis = new NumericAxis(scale, Position.bottom);
    }
    xAxis.addTo(_plotArea);
    xAxis.x = theme.borderSpaceToData;
    xAxis.y = _plotAreaHeight();
    xAxis.name = 'draw-bottomAxis';
    if (xLabel != null) xAxis.label = xLabel;

    if (_axisTypeLeft == AxisType.numeric) {
      Scale scale = new LinearScale(yLim.i1, yLim.i2, _plotAreaHeight()-2*theme.borderSpaceToData, 0);
      yAxis = new NumericAxis(scale, Position.left);
    }
    yAxis.addTo(_plotArea);
    yAxis.x = 0;
    yAxis.y = theme.borderSpaceToData;
    yAxis.name = 'draw-leftAxis';
    if (yLabel != null) yAxis.label = yLabel;

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
