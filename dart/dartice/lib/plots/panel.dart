library plots.panel;


import 'package:charted/selection/selection.dart';
import 'package:dartice/renderers/renderer.dart';
import 'package:dartice/plots/plot.dart';
import 'package:dartice/plots/layout.dart';
import 'package:dartice/renderers/points_renderer.dart';
import 'package:charted/core/core.dart';

class Panel {
  String panelName;
  int panelNumber = 0;
  Plot plot;
  List<Renderer> renderers;
  Selection _host;   // selection for the html Element of this panel

  Rect position;     // the screen coordinates of this panel
  List xValues = []; // the xValues associated with this panel
  List yValues = []; // the yValues associated with this panel

  bool _doStrip = true; // draw the strip

  Panel(String this.panelName, Plot this.plot, Selection this._host) {

    if (plot.panel != null) {
      // if you have panels
      List idx = plot.subscripts[panelName];
      idx.forEach((i) {
        xValues.add(plot.xValues[i]);
        yValues.add(plot.yValues[i]);
      });

      panelNumber = plot.panelNames.indexOf(panelName);
      Layout layout = new Layout(plot.layout[0], plot.layout[1]);
      num height = plot.plotArea.height / plot.layout[0];
      num width = plot.plotArea.width / plot.layout[1];
      int i = layout.rowIndex(panelNumber);
      int j = layout.colIndex(panelNumber);
      num x = i * width;
      num y = j * height;
      position = new Rect(x, y, width, height);

    } else {
      // if you don't have panels
      xValues = plot.xValues;
      yValues = plot.yValues;
      position = new Rect(0, 0, plot.plotArea.width, plot.plotArea.height);
      _doStrip = false;
    }
    
    
    Selection _group;
     _group = _host.append('g')..classed("panel-${panelNumber}");
    // TODO:  do I need to do a translate()?  Yes I do!
    
    // map the renderers to use
    if (plot.type != null) {
      renderers = plot.type.map((String e) {
        if (e == "p") {
          return new PointsRenderer(xValues, yValues, this, _group, col: plot.col);
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
