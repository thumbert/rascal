library graphics.axis;

import 'package:stagexl/stagexl.dart';
import 'tick.dart';
import 'theme.dart';
import 'scale.dart';

/// possible axis positions for standard plots
enum Position {
  bottom,
  left,
  right,
  top
}

enum AxisType {
  numeric,
  categorical,
  datetime
}


class AxisLimits {
  num minData;
  num maxData;

  /// actual min limit that will be rendered on the screen
  num min;
  /// actual max limit that will be rendered on the screen
  num max;

  AxisLimits();
  AxisLimits.fromData(List data) {
    if (data is List<num>) {
      data.forEach((num e ) {
        minData ??= e;
        minData = e < minData ? e : minData;
        maxData ??= e;
        maxData = e > maxData ? e : maxData;
      });

    } else if (data is List<DateTime>) {
      data.forEach((DateTime e ) {
        minData ??= e.millisecondsSinceEpoch;
        minData = e.millisecondsSinceEpoch < minData ? e.millisecondsSinceEpoch : minData;
        maxData ??= e.millisecondsSinceEpoch;
        maxData = e.millisecondsSinceEpoch > maxData ? e.millisecondsSinceEpoch : maxData;
      });

    } else if (data is List<String>) {
      minData = 1;
      maxData = data.length;

    } else {
      throw 'Unknown axis type for this data';
    }
  }



}


/// General Axis class, with subclasses NumericalAxis, CategoricalAxis, DateTimeAxis, etc.
/// An Axis has a fixed length that
class Axis extends Sprite {
  Position axisPosition;
  List<Tick> ticks;
  Theme theme = Theme.basic;

  /// the label gets under the ticks to clarify the meaning of the ticks
  String _labelText = '';

  /// keeps all the formatting of the label
  TextField _label;

  /// how to go from the data to the screen coordinates
  Scale scale;

  /// empty constructor
  Axis() {}

  set labelText(String value) {
    _labelText = value;
  }
  String get labelText => _label.text;

  set label(TextField value) {
    _label = value;
  }
  TextField get label {
    _label ??= new TextField(_labelText, theme.textFormat);
    return _label;
  }

  static AxisType getAxisType(List data) {
    AxisType type;
    if (data is List<num>) {
      type = AxisType.numeric;
    } else if (data is List<DateTime>) {
      type = AxisType.datetime;
    } else if (data is List<String>) {
      type = AxisType.categorical;
    } else {
      throw 'Unknown axis type for this data';
    }

    return type;
  }

}