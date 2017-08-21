library graphics.axis_datetime;

import 'dart:math' show max, min;
import 'package:stagexl/stagexl.dart';
import 'package:tuple/tuple.dart';

import 'axis.dart';
import 'tick.dart';
import 'tick_utils.dart';
import 'ticks_datetime.dart';
import 'scale.dart';
import 'theme.dart';

class DateTimeAxis extends Axis {
  AxisFormat axisFormat;

  DateTime start, end;

  /// location of the ticks
  List<DateTime> tickLocations = [];

  /// the ticks for the axis, the stagexl sprites
  List<Tick> ticks;

  /// go from a DateTime to a screen coordinate;
  DateTimeScale scale;

  /// the tick frequency.  Only need this if [ticks] are not specified.
  DateTimeTickFrequency _frequency;

  /// A DateTime axis.  Currently only for the x axis.
  /// <br>If [tickLocations] are specified, use the default formatter to
  /// construct the [ticks].
  /// <br>If [ticks] are specified, they need to be the same length as
  /// [tickLocations].  This is useful if you want to customize the
  /// tick appearance. Ticks don't need to have the x property set, it will
  /// be set directly by [tickLocations].
  ///
  DateTimeAxis(this.scale, this.axisFormat, {this.tickLocations, this.ticks}) {
    start = scale.x1;
    end = scale.x2;
    assert(start.isBefore(end));

    if (axisFormat.axisPosition != Position.bottom)
      throw 'Currently only bottom position is implemented';


    if (tickLocations == null) {
      /// get default tickLocations and default ticks using the default format
      var aux = defaultTicksDateTime(start, end,
          tickCoverType: TickCoverType.undercover);
      _frequency = aux.item1;
      tickLocations = aux.item2;
      ticks = makeTicks(tickLocations);

    } else {
      if (ticks == null) {
        /// tickLocations is specified by user, just make default ticks
        /// using default format
        ticks = makeTicks(tickLocations);
      } else {
        /// both tickLocations and ticks are directly specified by the user.
        assert(ticks.length == tickLocations.length);
      }
    }

    draw();
  }

  draw() {
//    print('tickLocations: $tickLocations');
//    print('tickLabels: ${ticks.forEach((t) => t.tickFormat.text)}');

    /// draw the axis line
    if (axisFormat.axisPosition == Position.bottom) {
      graphics.moveTo(-0.5 + scale.y1, 0.5);
      graphics.lineTo(scale.y2 - 0.5, 0.5);
    }
    graphics.strokeColor(Color.Black, 1, JointStyle.MITER, CapsStyle.SQUARE);

    /// draw the ticks
    for (int i=0; i<ticks.length; i++) {
      if (axisFormat.axisPosition == Position.bottom)
        ticks[i].x = scale(tickLocations[i]);
//      print('ticks[$i].x=${ticks[i].x}');
      addChild(ticks[i]);
    }
  }


  /// Make default ticks given the [tickLocations].
  List<Tick> makeTicks(List<DateTime> tickLocations) {
    TickDirection direction = TickDirection.down;

    num _left = 0;
    List<Tick> _ticks = [];
    for (int i = 0; i < tickLocations.length; i++) {
      // screen coordinate of the tick, used to check if the label fits
      var coord = scale(tickLocations[i]);
      int idx = 0;
      String tickLabel =
          (defaultDateTimeTickFormatter(_frequency)(tickLocations[i])
              as List)[idx];
      TickFormat tickFormat = Theme.basic.tickFormat
        ..tickDirection = direction
        ..text = tickLabel;
      Tick tick = new Tick(tickFormat);

      if (i == 0) _left = coord - tick.width / 2;
      if (coord - tick.width / 2 < _left) {
        /// label doesn't fit, make a new Tick with a smaller label!
        tickFormat.text = '';
        tick = new Tick(tickFormat);
      } else {
        _left = coord + tick.width / 2;

        tick.name = 'tick-$i';
        _ticks.add(tick);
      }
    }

    return _ticks;
  }
}




/// Go over the ticks one more time and see which ones can be
/// displayed without overlap.
//  Tuple2 imposeTickLabelConstraints() {
//
//    num _left = 0;
//    List<Tick> _ticks = [];
//    for (int i = 0; i < tickLocations.length; i++) {
//      // screen coordinate of the tick, used to check if the label fits
//      var coord = scale(tickLocations[i]);
//      int idx = i == 0 ? 0 : 1;
//      String tickLabel =
//      (defaultDateTimeTickFormatter(_frequency)(tickLocations[i])
//      as List)[idx];
//
//      if (i == 0) _left = coord - tick.width / 2;
//
//      print(
//          'i: $i, coord: $coord, tickLabel: ${tickLabel}, tick.width: ${tick.width}, _left: $_left');
//      if (coord - tick.width / 2 < _left) {
//        /// label doesn't fit, make a new Tick with a smaller label!
//        tickFormat.text = '';
//        tick = new Tick(tickFormat);
//      } else {
//        _left = coord + tick.width / 2;
//
//        tick.name = 'tick-$i';
//        _ticks.add(tick);
//      }
//    }
//
//    return _ticks;
//
//  }
