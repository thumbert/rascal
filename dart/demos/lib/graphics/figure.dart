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
  Map<Position, Axis> axes;
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

  /// The plot area is the main window where data is represented on screen.
  /// The dimensions of the _plotArea are determined by the labels,
  /// title, and maybe other possible annotations (??).
  PlotArea _plotArea;

  /// keep track of the order of colors for multiple series
  int _colorIndex = 0;

  /// the axis limits from the data (becomes an ordinal value)
  Tuple2<num, num> _xLim;
  Tuple2<num, num> _yLim;

  /// is xLim passed in by the user, default is data driven
  bool _xLimFixed = false;

  /// is yLim passed in by the user, default is data driven
  bool _yLimFixed = false;

  /// guess the axis type from the data
  AxisType _axisTypeBottom, _axisTypeLeft;

  /// the bottom label
  TextField _xLabel;

  /// the left label
  TextField _yLabel;

  /// the title
  TextField _title;

  /// Instantiate a Figure if you don't need a layout (a combinations of Figures).
  /// It needs to be added as a child to the stage and then you can draw it.
  /// All the children of the Figure who have a name containing 'draw' will get
  /// drawn.
  Figure({num width: 800, num height: 500}) {
    /// need this empty shell with the right dimensions
    Shape background = new Shape()
      ..width = width
      ..height = height
      ..graphics.rect(0, 0, width - 1, height - 1)
      ..graphics.strokeColor(0x00000000, 1, JointStyle.MITER);
//      ..graphics.fillColor(Color.Beige);
    addChild(background);
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
  /// is needed, or a special scale is used, they can be set directly.
  /// xScale, yScale are functions from data to num screen coordinates.
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
    /// if the color is not set, get it from the theme
    if (color == null) {
      color = theme.colors[_colorIndex % theme.colors.length];
      _colorIndex += 1;
    }

    /// if there is no axis on the bottom, create one
    if (_axisTypeBottom == null) _axisTypeBottom = Axis.getAxisType(xData);

    /// if there is no axis on the left, create one
    if (_axisTypeLeft == null) _axisTypeLeft = Axis.getAxisType(yData);

    if (!_xLimFixed) {
      var aux = new AxisLimits.fromData(xData);
      if (xLim == null)
        _xLim = new Tuple2(aux.minData, aux.maxData);
      else
        _xLim =
            new Tuple2(min(aux.minData, xLim.i1), max(aux.maxData, xLim.i2));
    }
    if (!_yLimFixed) {
      var aux = new AxisLimits.fromData(yData);
      if (yLim == null)
        _yLim = new Tuple2(aux.minData, aux.maxData);
      else
        _yLim =
            new Tuple2(min(aux.minData, yLim.i1), max(aux.maxData, yLim.i2));
    }

    var lp = new LinePlot(this, xData, yData,
        color: color, strokeWidth: strokeWidth);
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
    num _width =
        width - (theme.margin[Margin.left] + theme.margin[Margin.right]);
    print('From _plotAreaWidth, _width = ${_width}');
    return _width;
  }

  /// Calculate the height of the plotArea, it depends of axis labels, the key, title, etc.
  num _plotAreaHeight() {
    num _height =
        height - (theme.margin[Margin.top] + theme.margin[Margin.bottom]);
    return _height;
  }

  /// draw this figure
  void draw() {
    _constructAxes();
    print('xAxis height =${xAxis.height}');

    _plotArea.addTo(this);

    /// draw the plot area first
    _plotArea.graphics.rect(0, 0, _plotAreaWidth(), _plotAreaHeight());
    _plotArea.graphics.fillColor(Color.White);
    _plotArea
      ..x = _plotAreaX()
      ..y = _plotAreaY();

    num hX = theme.borderSpaceToData;
    num hY = theme.borderSpaceToData;

    /// TODO: what if xLim, yLim are null and not set yet?
    xScale = new LinearScale(xLim.i1, xLim.i2, hX, _plotAreaWidth() - hX);
    yScale = new LinearScale(yLim.i1, yLim.i2, _plotAreaHeight() - hY, hY);

    if (title != null) {
      title.autoSize = TextFieldAutoSize.CENTER;
      title.alignPivot(HorizontalAlign.Center);
      title.x = _plotAreaWidth() / 2;
      title.y = -2 * theme.textFormat.size;
      _plotArea.addChild(title);
    }

    /// draw all the children
    children.where((e) => e.name.startsWith('draw')).forEach((e) => e.draw());
  }

  void _constructAxes() {
    /// bottom axis
    if (_axisTypeBottom == AxisType.numeric) {
      Scale scale = new LinearScale(
          xLim.i1, xLim.i2, 0, _plotAreaWidth() - 2 * theme.borderSpaceToData);
      xAxis = new NumericAxis(scale, Position.bottom);
    }
    xAxis.addTo(_plotArea);
    xAxis.x = theme.borderSpaceToData;
    xAxis.y = _plotAreaHeight();
    xAxis.name = 'draw-bottomAxis';
    if (xLabel != null) xAxis.label = xLabel;

    /// left axis
    if (_axisTypeLeft == AxisType.numeric) {
      Scale scale = new LinearScale(
          yLim.i1, yLim.i2, _plotAreaHeight() - 2 * theme.borderSpaceToData, 0);
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
    children.where((e) => e.name.startsWith('draw')).forEach((e) => e.draw());
  }
}
