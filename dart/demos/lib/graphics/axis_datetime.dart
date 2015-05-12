library graphics.axis_datetime;

import 'package:intl/intl.dart';
import 'package:stagexl/stagexl.dart';
import 'package:demos/datetime/utils.dart';


/**
 * A DateTime axis for the x axis.
 */
class DateTimeAxis extends Sprite {

  static DateFormat ddMMMyyyy = new DateFormat('dd MMM yyyy');
  static DateFormat MMMyy = new DateFormat('MMMyy');

  DateTime start, end;
  List<DateTime> ticks;
  List<String> tickLabels;
  /// may need to move the start earlier and the end later for the axis ticks
  DateTime extStart, extEnd;

  /// go from a DateTime to a screen coordinate;
  Function scale;
  /// the label gets under the ticks to clarify the meaning of the ticks
  String label;

  /// margin in points from the edges of the parent
  num margin = 10;

  /// the headers are the categorical groups that have meaning
  List<String> _header = [];


  DateTimeAxis(this.start, this.end) {
    assert(start.isBefore(end));
    calculateTicks();
  }

  /**
   * Calculate the ticks, the panel and the label.
   */
  calculateTicks() {

  }


  draw() {
    var _width = parent.width;
    print('width is $width, parent width is $_width, parentName is ${parent.name}');
    var range = extEnd.millisecondsSinceEpoch - extStart.millisecondsSinceEpoch;
    scale = (DateTime x) => ((x.millisecondsSinceEpoch - extStart.millisecondsSinceEpoch) * (_width-2*_margin) / range + _margin).round();

    graphics.rect(scale(ticks[0]), y, scale(ticks.last)-scale(ticks[0]), y+24);
    graphics.strokeColor(Color.Black, 1, JointStyle.MITER);
    graphics.fillColor(Color.Wheat);

    for (int i=0; i<ticks.length; i++) {
      print(scale(ticks[i]));
      graphics.moveTo(scale(ticks[i]), y+24);
      graphics.lineTo(scale(ticks[i]), y+34);
    }
    graphics.strokeColor(Color.Black);


  }


}