library plots.panel;


import 'package:charted/selection/selection.dart';
import 'package:dartice/renderers/renderer.dart';
import 'package:dartice/plots/plot.dart';
import 'package:dartice/plots/layout.dart';

class Panel {
  String panelName;
  int panelNumber;
  Plot plot;
  List<Renderer> renderers;
  Selection _host; // selection for the html Element of this panel

  num x; // the screen x coordinate for the top-left corner of this panel
  num y; // the screen y coordinate for the top-left corner of this panel
  num width; // the width of this panel in px
  num height; // the heigth of this panel in px

  List xValues = []; // the xValues associated with this panel
  List yValues = []; // the yValues associated with this panel

  bool _doStrip = true; // draw the strip

  Panel(int this.panelNumber, String this.panelName, Plot this.plot, Selection this._host) {

    if (plot.panel != null) {
      // if you have panels
      List idx = plot.subscripts[panelName];
      idx.forEach((i) {
        xValues.add(plot.xValues[i]);
        yValues.add(plot.yValues[i]);
      });

      Layout layout = new Layout(plot.layout[0], plot.layout[1]);
      int i = layout.rowIndex(panelNumber);
      int j = layout.colIndex(panelNumber);
      x = i * width;
      y = j * height;
      height = plot.plotAreaHeight / plot.layout[0];
      width = plot.plotAreaWidth / plot.layout[1];

    } else {
      // if you don't have panels
      xValues = plot.xValues;
      yValues = plot.yValues;
      x=0;
      y=0;
      height = plot.plotAreaHeight;
      width = plot.plotAreaWidth;
      _doStrip = false;
    }

    Selection _group;
     _group = _host.append('g')..classed("panel-${panelName}");
    // TODO:  do I need to do a translate()?  
    
    // map the renderers to use
    if (plot.type != null) {
      renderers = plot.type.map((String e) {
        if (e == "p") {
          return new PointsRenderer(xValues, yValues, panelNumber, plot, _group, col: plot.col);
        }
      }).toList();
    }

  }



  void draw() {
    renderers.forEach((renderer) => renderer.draw());
  }

}


//        switch (e) {
//          case "p":
//            return new PointsRenderer(_x, _y, subscripts, col, _svggroup);
//          default:
//            throw new StateError("renderer type ${e} not implemented");
//        }
