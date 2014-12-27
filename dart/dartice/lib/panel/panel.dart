library panel.panel;

import 'package:charted/selection/selection.dart';
import 'package:dartice/renderers/renderer.dart';
import 'package:dartice/plots/plot.dart';

class Panel {
  String panelName;
  int panelNumber;
  Plot plot;
  List<Renderer> renderers;
  Selection _host;               // the parent of this panel (the plotArea)
  
  num x;       // the screen x coordinate for the top-left corner of this panel           
  num y;       // the screen y coordinate for the top-left corner of this panel
  num width;   // the width of this panel in px
  num height;  // the heigth of this panel in px
  
  bool _doStrip;
  
  Panel(int this.panelNumber, 
      String this.panelName, 
      Plot this.plot,  
      Selection this._host) {
    
    
    if (plot.panelValues.length == 0) {
      height = plot.plotAreaHeight;
      width  = plot.plotAreaWidth;
    } else {
      height = plot.plotAreaHeight/plot.layout.nRows;
      width  = plot.plotAreaWidth/plot.layout.nCols;
    }

    if (panelName != null)
      _doStrip = true;
    
    // map the renderers to use
    if (plot.type != null) {
      renderers = plot.type.map((String e) {
        if (e == "p") {
          return new PointsRenderer(xValues, yValues, panelNumber, plot, _svggroup, col: plot.col);
        }
      }).toList();
    }
    
    
    int i = plot.layout.rowIndex(panelNumber);
    int j = plot.layout.colIndex(panelNumber);
    panelX = i*panelWidth;
    panelY = j*panelHeight;
        
  }
  
  
  
  void draw(){
    renderers.forEach((renderer) => renderer.draw());
  }
  
}


//        switch (e) {
//          case "p":
//            return new PointsRenderer(_x, _y, subscripts, col, _svggroup);
//          default:
//            throw new StateError("renderer type ${e} not implemented");
//        }