library graphics.layout;

import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/drawable.dart';


class Layout extends Sprite implements Drawable {
  /// rows of panels
  int nrow;
  /// cols of panels
  int ncol;

  /// simple layout, tile-like, all panels equal in size
  Layout({this.nrow: 1, this.ncol: 1}) {
    if (nrow < 1)
      throw 'Illegal number of rows for layout';
    if (ncol < 1)
      throw 'Illegal number of cols for layout';
  }

  /// TODO: a layout of different tile sizes
  Layout.fromMap(){}

  int get panels {
    int res = 1;
    if (nrow != null && ncol != null) {
      res = nrow * ncol;
    }
    return res;
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
