library graphics.panel;

import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/plot_line.dart';
import 'package:demos/graphics/theme.dart';
import 'package:demos/graphics/axis.dart';
import 'package:demos/graphics/drawable.dart';
import 'package:demos/graphics/layout.dart';


class Panel extends Sprite implements Drawable {

  /// panel number
  int panelNumber;
  /// the theme of the panel
  Theme theme;


  Panel(this.panelNumber) {
    name = 'panel:$panelNumber';
  }



  /// draw this panel
  void draw() {

  }


}



