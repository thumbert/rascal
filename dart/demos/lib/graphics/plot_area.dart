
import 'dart:async';
import 'package:stagexl/stagexl.dart';

import 'scale.dart';
import 'axis.dart';
import 'axis_numeric.dart';
import 'ticks_numeric.dart';

class PlotArea extends Sprite {

  Sprite rectZoom;
  bool isSelected = false;
  List<num> topLeft = [];
  List<num> bottomRight = [];


  //Scale myScaleX, myScaleY;

  num width, height;

  List<num> _xLimOriginal;
  Duration _delayClicks = new Duration(milliseconds: 400);
  var _clicks = 0;
//  bool _isDoubleClick = false;


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

  Axis get xAxis => getChildAt(0);
  Axis get yAxis => getChildAt(1);
  // go from x data to screen x coordinates
  Scale get myScaleX => xAxis.scale;
  // go from y data to screen y coordinates
  Scale get myScaleY => yAxis.scale;


  /// on DoubleClicks revert to the original xLimits
  _onMouseDoubleClick(Event e) {
    if (_xLimOriginal != null) {
      Scale scaleX = new LinearScale(_xLimOriginal[0], _xLimOriginal[1], 0, width);
      Axis newAxis = new NumericAxis(scaleX, Position.bottom);
      newAxis.y = height;
      newAxis.name = 'xAxis';
      removeChildAt(0);
      addChildAt(newAxis, 0);
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
      isSelected = true;
      topLeft = [mouseX, mouseY];
      print('Start selection at (${xAxis.scale.inverse(mouseX)}, ${yAxis.scale.inverse(mouseY)})');

      /// set the original x axis limits, so you can revert to them later
      if (_xLimOriginal == null && myScaleX != null) {
        _xLimOriginal = [myScaleX.x1, myScaleX.x2];
      }
    }
  }


  _onMouseUp(Event e) {
    bottomRight = [mouseX, mouseY];
    /// only if you have a change in x coords
    if (topLeft[0] != bottomRight[0]) {
      print('Selection ends at (${myScaleX.inverse(bottomRight[0])}, ${myScaleX.inverse(bottomRight[1])}) ');
      rectZoom.graphics.clear();

      if (topLeft[0] > bottomRight[0]) {
        /// mouse was dragged to the left, switch the points
        List aux = [bottomRight[0], bottomRight[1]];
        bottomRight = [topLeft[0], topLeft[1]];
        topLeft = [aux[0], aux[1]];
      }


      /// trigger a redraw by rescaling the xAxis
      num x1 = xAxis.scale.inverse(topLeft[0]);
      num x2 = xAxis.scale.inverse(bottomRight[0]);
      print('from MouseUp, the xAxis data limits are (${x1},${x2})');
      List<num> _xTicks = defaultNumericTicks(x1, x2);
      print('the new ticks: $_xTicks');

      Scale newScale = new LinearScale(_xTicks.first, _xTicks.last, 0, width);
      print('_clicks=${_clicks}');
      Axis newAxis = new NumericAxis(newScale, Position.bottom, tickLocations: _xTicks);
      newAxis.y = height;
      newAxis.name = 'xAxis';
      removeChildAt(0);
      addChildAt(newAxis, 0);
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