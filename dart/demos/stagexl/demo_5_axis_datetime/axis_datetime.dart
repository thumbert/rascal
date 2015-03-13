library axis_datetime;

import 'package:stagexl/stagexl.dart';


/**
 * A DateTime axis for the x axis.
 */
class DateTimeAxis extends Sprite {

  List<DateTime> ticks;
  DateTime start, end;
  // go from a DateTime to a screen coordinate;
  Function scale;
  String label;   // the label gets under the ticks to clarify the meaning of the ticks
  List<String> panels = [];  // the panels are the categorical groups that have meaning


  DateTimeAxis(this.start, this.end) {
    calculateTicks();
  }

  calculateTicks() {

  }

  draw() {

  }



}