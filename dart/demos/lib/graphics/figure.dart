library graphics.figure;

import 'package:tuple/tuple.dart';
import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/plot_line.dart';
import 'package:demos/graphics/theme.dart';
import 'package:demos/graphics/axis.dart';
import 'package:demos/graphics/drawable.dart';
import 'package:demos/graphics/key.dart';
import 'package:demos/graphics/axis_numeric.dart';

class Figure extends DisplayObjectContainer implements Drawable {
  TextField tooltip;
  Theme theme = Theme.basic;
  Map<Position,Axis> axes;
  Key key;

  /// the plot area
  _PlotArea _plotArea;
  //int _drawableChildren = 0;
  int _colorIndex = 0;
  Tuple2<num, num> _xLim;
  Tuple2<num, num> _yLim;
  bool _xLimFixed = false;
  bool _yLimFixed = false;

  Figure(Stage stage) {
    print(stage.stageWidth);

    this.addTo(stage);
  }

  /// x axis limits for numerical values
  set xLim(Tuple2<num, num> values) {
    _xLimFixed = true;
    _xLim = values;
    axes[Position.bottom] = new NumericAxis(values.i1, values.i2);
  }
  Tuple2<num, num> get xLim => _xLim;

  /// y axis limits for numerical values
  set yLim(Tuple2<num, num> values) {
    _yLimFixed = true;
    _yLim = values;
    axes[Position.left] = new NumericAxis(values.i1, values.i2);
  }
  Tuple2<num, num> get yLim => _yLim;

  /// draw a line in the plot area of the active panel
  void line(List xData, List yData, {int color}) {
    if (color == null) {
      color = theme.colors[_colorIndex % theme.colors.length];
      _colorIndex += 1;
    }

    AxisType axisTypeX = Axis.getAxisType(xData);

    if (!_xLimFixed) {
      var aux = new AxisLimits.fromData(xData);
      _xLim = new Tuple2(aux.minData, aux.maxData);
    }

    var lp = new LinePlot(this, xData, yData, color: color);
    lp.name = 'draw-line:$_colorIndex';
    this.addChild(lp);
  }

  /// draw this figure
  void draw() {
    children.where((e) => e.name.startsWith('draw')).forEach((e) => e.draw());
  }
}

class _PlotArea extends Sprite implements Drawable {
  _PlotArea(Theme theme) {}

  void draw() {}
}
