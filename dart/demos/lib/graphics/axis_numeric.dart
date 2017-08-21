library axis_numeric;

import 'dart:math' as math show PI, log, LOG10E, max;
import 'package:tuple/tuple.dart';
import 'package:stagexl/stagexl.dart';

import 'ticks_numeric.dart';
import 'tick.dart';
import 'tick_utils.dart';
import 'axis.dart';
import 'scale.dart';
import 'theme.dart';


/// A numeric axis for StageXL
class NumericAxis extends Axis {
  AxisFormat axisFormat;

  /// the tick locations, in case you want to set them by hand
  List<num> tickLocations;

  /// the ticks for the axis, the stagexl sprites
  List<Tick> ticks;

  /// go from the data to the screen coordinates
  LinearScale scale;

  /// margin in points from the edges of the parent (what is this for??)
  num margin = 30;

  /// margin in points from the left edge of the parent to the first tick
  //int leftMargin;
  /// margin in points from the right edge of the parent to the last tick
  //int rightMargin;

  /// amount of minimum space between labels, so they don't look crowded
  num minSpaceBetweenLabels = 10;


  /// A numeric axis.
  /// [scale] is the scale that converts data points to screen coordinates.
  /// [tickLocations] a List of numeric
  /// TODO: copy the DateTimeAxis setup where you can pass on the ticks directly
  NumericAxis(this.scale, this.axisFormat, {this.tickLocations, this.ticks}) {
    width = scale.y2 - scale.y1;

    tickLocations ??= defaultNumericTicks(scale.x1, scale.x2);
//    print(tickLocations);
    ticks = makeTicks(tickLocations);

    draw();
  }


  /// the actual length of the axis in pixels
  num get _axisLength => scale.y2 - scale.y1;

  /// Draw this axis
  draw() {
    /// draw the axis line
    if (axisFormat.axisPosition == Position.bottom) {
      graphics.moveTo(-0.5+scale.y1, 0.5);
      graphics.lineTo(-0.5+scale.y2, 0.5);

    } else if (axisFormat.axisPosition == Position.left) {
      graphics.moveTo(-0.5, 0.5+scale.y1);
      graphics.lineTo(-0.5, 0.5+scale.y2);
    }

    /// add the ticks
    ticks.forEach((tick) => addChild(tick));

    /// add the axis label if it exists
    if (label != null) {
      label.autoSize = TextFieldAutoSize.CENTER;
      //label.alignPivot(HorizontalAlign.Center);
      //label.border = true;
      addChild(label);
      switch (axisFormat.axisPosition) {
        case Position.bottom:
          label.x = (this.width - label.width)~/2;
          label.y = theme.tickFormat.length + 2*theme.fontSize;
          break;
        case Position.left:
          label.alignPivot(HorizontalAlign.Center);
          label.x = -(theme.tickFormat.length + 3*theme.fontSize);
          label.y = -_axisLength~/2;
          label.rotation = -math.PI/2;
          break;
        case Position.top:

          break;
        case Position.right:

          break;
      }
    }
    graphics.strokeColor(Color.Black, 1, JointStyle.MITER, CapsStyle.SQUARE);
  }

  /// default ticks, keep only the ticks inside the scale
  List<Tick> makeTicks(List tickLocations) {

    TickDirection direction;   // tick direction
    switch (axisFormat.axisPosition) {
      case Position.bottom:
        direction = TickDirection.down;
        break;
      case Position.left:
        direction = TickDirection.left;
        break;
      case Position.top:
        direction = TickDirection.up;
        break;
      case Position.right:
        direction = TickDirection.right;
        break;
    }

    List<Tick> _ticks = [];
    List<String> tickLabels = tickLocations.map((e) => _defaultNumericTickLabel(e)).toList();
    print('tickLabels:$tickLabels');

    /// construct the ticks
    for (int i = 0; i < tickLocations.length; i++) {
      //print('i: $i, ${tickNum[i]}, ${scale(tickNum[i])}');
      var coord = scale(tickLocations[i]);
      TickFormat tickFormat = Theme.basic.tickFormat
        ..text = tickLabels[i]
        ..tickDirection = direction;
      Tick tick = new Tick(tickFormat);

      if (axisFormat.axisPosition == Position.bottom){
        tick.x = coord;
      } else if (axisFormat.axisPosition == Position.left)
        tick.y = coord;
      else if (axisFormat.axisPosition == Position.right) {
        tick.x = width;
        tick.y = coord;
      }
      tick.name = 'draw-tick-$i';
      _ticks.add(tick);
    }

    return _ticks;
  }


  /// Construct the default tick label for a given value
  List<String> _defaultNumericTickLabel(num value) {
    Function fmtLabel;
    num range10 = (math.log(scale.x2 - scale.x1)*math.LOG10E);
    //print('range10: $range10');
    if (range10 <= 0.6) {
      int precision = math.max(range10, 1).ceil();
      fmtLabel = (num x) {
        String res;
        if (x.abs() >= 1000000)
          res = x.toStringAsExponential(2);
        else
          res = x.toStringAsFixed(precision);
        return res;
      };
    } else {
      fmtLabel = (num x) {
        String res;
        if (x.abs() >= 1000000)
          res = x.toStringAsExponential(0);
        else
          res = x.toStringAsFixed(0);
        return res;
      };
    }
    return fmtLabel(value);
  }

}


// if the label doesn't fit, remove the label
//      if (x - tick.width/2 < _left + minSpaceBetweenLabels) {
//        tick = new Tick(text: '')
//          ..direction = TickDirection.down;
//      }
//      if (x + tick.width/2 > _axisLength) {
//        tick = new Tick(text: '')
//          ..direction = TickDirection.down;
//      }

/// Extend the limits of a numeric axis, so the data is contained in
/// a 'nice' interval.  For example if the lim of the data is [0.5,9]
/// a nice extended limit would be [0,10].
//  static Tuple2<num,num> extendLimits(Tuple2<num,num> lim) {
//    Tuple2<num,num> limExt = lim;
//
//    return limExt;
//  }

/// Calculate the [min,max] of the iterable for axis limits
/// You can pass in some existing limits from the previous lines to extend the
/// limits.
//  static Tuple2<num,num> getLimits(Iterable<num> x, {Tuple2<num,num> lim}) {
//    if (x.isEmpty)
//      throw 'Cannot calculate axis limits of an empty iterable';
//    if (x.length == 1 && (x.first.isNaN || x.first == null))
//      throw 'Cannot calculate the limits';
//    num min = lim.item1;
//    num max = lim.item2;
//    x.where((e) => !(e.isNaN || e == null)).forEach((num e){
//      if (e > max || max == null) max = e;
//      if (e < min || min == null) min = e;
//    });
//
//    return new Tuple2(min,max);
//  }
