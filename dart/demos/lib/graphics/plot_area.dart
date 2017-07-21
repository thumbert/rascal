
import 'dart:async';
import 'package:stagexl/stagexl.dart';

import 'scale.dart';
import 'axis.dart';
import 'axis_numeric.dart';

class PlotArea extends Sprite {

  Sprite rectZoom;
  bool isSelected = false;
  List<num> topLeft = [];
  List<num> bottomRight = [];

  Scale myScaleX, myScaleY;

  num width, height;

  List<num> _xLimOriginal;
  Duration _delayClicks = new Duration(milliseconds: 400);
  var _clicks = 0;
  bool _isDoubleClick = false;


  PlotArea(this.width, this.height) {
    graphics.rect(0, 0, width, height);
    graphics.strokeColor(Color.Black);
    graphics.fillColor(Color.White);

    rectZoom = new Sprite();
    addChild(rectZoom);

    onMouseDown.listen(_onMouseDown);
    onMouseUp.listen(_onMouseUp);
    onMouseMove.listen(_onMouseMove);
  }

  /// on DoubleClicks revert to the original xLimits
  _onMouseDoubleClick(Event e) {
    if (_xLimOriginal != null) {
      myScaleX = new LinearScale(_xLimOriginal[0], _xLimOriginal[1], 0, width);
      Axis xAxis = new NumericAxis(myScaleX, Position.bottom);
      xAxis.y = height;
      xAxis.name = 'xAxis';
      removeChildAt(0);
      addChildAt(xAxis, 0);
    }
  }

  _onMouseDown(Event e) {
    /// deal with double clicks here
    _clicks++;
    new Timer(_delayClicks, () {
      print('in timer, reset the clicks');
      _clicks = 0;
    });

    if (_clicks == 2) {
      _onMouseDoubleClick(e);
      _clicks = 0;
      return;

    } else {
      print('Start selection');
      isSelected = true;
      topLeft = [mouseX, mouseY];

      /// set the original x axis limits, so you can revert to them later
      if (_xLimOriginal == null && myScaleX != null) {
        _xLimOriginal = [myScaleX.x1, myScaleX.x2];
      }
      print(_xLimOriginal);
    }
  }

  _onMouseUp(Event e) {

    /// only if the rectangle is
    if (topLeft[0] != bottomRight[0] || topLeft[1] != bottomRight[1]) {
      print('Selection is $topLeft to $bottomRight');
      rectZoom.graphics.clear();

      if (topLeft[0] > bottomRight[0]) {
        /// mouse was dragged to the left, switch the points
        List aux = [bottomRight[0], bottomRight[1]];
        bottomRight = [topLeft[0], topLeft[1]];
        topLeft = [aux[0], aux[1]];
      }


      /// trigger a redraw by rescaling the xAxis
      num x1 = myScaleX.inverse(topLeft[0]);
      num x2 = myScaleX.inverse(bottomRight[0]);

      myScaleX = new LinearScale(x1, x2, 0, width);
      print('from MouseUp, myScaleX.x1=${myScaleX.x1}');
      print('_clicks=${_clicks}');
      Axis xAxis = new NumericAxis(myScaleX, Position.bottom);
      xAxis.y = height;
      xAxis.name = 'xAxis';
      removeChildAt(0);
      addChildAt(xAxis, 0);

      /// TODO: fixme, almost works!

    }
    isSelected = false;
  }


  _onMouseMove(Event e) {
    bottomRight = [mouseX, mouseY];
    rectZoom.graphics.clear();
    if (isSelected) {
      rectZoom.graphics.rect(topLeft[0], 0,
          bottomRight[0]-topLeft[0], height);
      rectZoom.graphics.fillColor(0xFF75dff5);
    }
  }


}