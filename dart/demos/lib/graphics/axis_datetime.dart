library graphics.axis_datetime;

import 'dart:math' show max, min;
import 'package:stagexl/stagexl.dart';

import 'axis.dart';
import 'tick.dart';
import 'tick_utils.dart';
import 'ticks_datetime.dart';
import 'scale.dart';

class DateTimeAxis extends Axis {
  final txtFmt =
      new TextFormat("Arial", 20, Color.Black, align: TextFormatAlign.CENTER);

  DateTime start, end;
  Position position;

  /// location of the ticks
  List<DateTime> tickLocations = [];

  /// the ticks for the axis, the stagexl sprites
  List<Tick> ticks;

  /// go from a DateTime to a screen coordinate;
  DateTimeScale scale;

  /// the tick frequency.  Only need this if [ticks] are not specified.
  DateTimeTickFrequency _frequency;

  /// A DateTime axis.  Currently only for the x axis.
  /// <br>If [tickLocations] are specified, use the default formatter.  You
  /// can construct your own [ticks] directly, but this is a bit more work.
  /// <br>If ticks are [null], make default ones.
  DateTimeAxis(this.scale, this.position, {this.tickLocations, this.ticks}) {
    start = scale.x1;
    end = scale.x2;
    assert(start.isBefore(end));

    if (position != Position.bottom)
      throw 'Currently only bottom position is implemented';

    ticks ??= makeTicks();
    draw();
  }

  draw() {
    print('drawing the datetime axis');
    print('tickLocations: $tickLocations');
    print('tickLabels: ${ticks.forEach((t) => t.text)}');

    /// draw the axis line
    if (position == Position.bottom) {
      graphics.moveTo(-0.5 + scale.y1, -0.5);
      graphics.lineTo(scale.y2 - 0.5, -0.5);
    }
    graphics.strokeColor(Color.Black, 1, JointStyle.MITER, CapsStyle.SQUARE);

    /// draw the ticks
    ticks.forEach((tick) => addChild(tick));
    ticks.forEach((tick) => tick.draw());
  }

  /// Make the default ticks.  Ticks will be inside the data only.
  List<Tick> makeTicks() {
    var aux = defaultTicksDateTime(start, end, tickCoverType: TickCoverType.undercover);
    _frequency = aux.item1;
    tickLocations ??= aux.item2;

    int direction;
    if (position == Position.bottom) direction = TickDirection.down;
    else throw 'Unsupported datetime axis position';

    // see axis_numeric for an attempt to not print labels that overlap
    List<Tick> _ticks = [];
    for (int i=0; i<tickLocations.length; i++) {
      var coord = scale(tickLocations[i]);  // screen coordinate
      String tickLabel = (defaultDateTimeTickFormatter(_frequency)(tickLocations[i]) as List).first;
      Tick tick = new Tick(text: tickLabel)..direction = direction;

      if (position == Position.bottom)
        tick.x = coord;

      tick.name = 'tick-$i';
      _ticks.add(tick);
    }


    return _ticks;
  }
}
