library graphics.figure;

import 'package:tuple/tuple.dart';
import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/plot_line.dart';
import 'package:demos/graphics/theme.dart';
import 'package:demos/graphics/axis.dart';
import 'package:demos/graphics/drawable.dart';
import 'package:demos/graphics/key.dart';

class Figure extends DisplayObjectContainer implements Drawable {
  TextField tooltip;
  Theme theme = Theme.basic;
  List<Axis> axes;
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

  set xLim(Tuple2<num, num> values) {
    _xLimFixed = true;
    _xLim = values;
  }
  Tuple2<num, num> get xLim => _xLim;

  set yLim(Tuple2<num, num> values) {
    _yLimFixed = true;
    _yLim = values;
  }
  Tuple2<num, num> get yLim => _yLim;

  /// draw a line in the plot area of the active panel
  void line(List xData, List yData, {int color}) {
    if (color == null) {
      color = theme.colors[_colorIndex % theme.colors.length];
      _colorIndex += 1;
    }
    _drawableChildren += 1;

    AxisType axisTypeX = Axis.getAxisType(xData);

    if (!_xLimFixed) {
      //xLim =
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
