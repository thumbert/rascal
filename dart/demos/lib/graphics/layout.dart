library graphics.layout;

import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/drawable.dart';
import 'package:demos/graphics/figure.dart';


class Layout extends DisplayObjectContainer implements Drawable {
  Stage stage;

  /// rows of panels
  int nrow;
  /// cols of panels
  int ncol;

  /// for equally sized panels, you can use a matrix specification
  List<int> _matrix;

  /// for each column of the layout matrix, specify the percent of the
  /// total stage this panel takes
  List<List<num>> vFractions = [];

  /// for each row of the layout matrix, specify the percent of the
  /// total stage this panel takes
  List<List<num>> hFractions = [];

  /// the panels
  Map<int, Figure> _panels = {};

  /// By default only one figure in the panel.
  /// Only simple layout, tile-like.  You can have multiple panels inside the
  /// layout (by default all panels have the same dimensions).  Different
  /// dimensions can be accommodated with the layoutFraction variable.
  Layout(this.stage, {this.nrow: 1, this.ncol: 1}) {
    if (nrow < 1)
      throw 'Illegal number of rows for layout';
    if (ncol < 1)
      throw 'Illegal number of cols for layout';
  }

  /// TODO: a layout of different tile sizes
  Layout.fromMap(){}

  /// get the total number of panels
  int get panels {
    int res = 1;
    if (nrow != null && ncol != null) {
      res = nrow * ncol;
    }
    return res;
  }

  List<int> get matrix {
    _matrix = [nrow, ncol];
    return _matrix;
  }
  set matrix(List<int> values) {
    if (values.length != 2)
      throw 'Layout dimensions need to be exactly 2';
    if (values.any((v) => v < 1))
      throw 'Layout dimensions cannot be < 1';
    nrow = values.first;
    ncol = values.last;
  }

  /// Set a panel
  void panel(int id, Figure fig) {
    if (id > panels)
       throw 'This panel does not exist for the existing figure layout.';
    _panels[id] = fig;
  }

  void draw() {

  }

}

//Layout get layout {
//  _layout ??= theme.layout;
//  return _layout;
//}
//set layout(Layout value) {
//  _layout = value;
//}
//set panel(int value) {
//  if (value > layout.panels)
//    throw 'This panel does not exist for the existing figure layout.';
//  _panelNumber = value;
//}
//int get panel {
//  _panelNumber ??= 1;
//  return _panelNumber;
//}
