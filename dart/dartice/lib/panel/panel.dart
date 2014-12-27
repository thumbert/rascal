library panel.panel;

import 'package:charted/selection/selection.dart';
import 'package:dartice/renderers/renderer.dart';
import 'package:dartice/plots/plot.dart';

class Panel {
  String panelName;
  int panelNumber;
  Plot plot;
  List<Renderer> renderers;
  Selection _host;
  
  num panelX;           
  num panelY;
  num panelHeight;
  num panelWidth;
  
  bool _doStrip;
  
  Panel(int this.panelNumber, 
      String this.panelName, 
      Plot this.plot,  
      Selection this._host) {
    
    
    if (plot.panelValues.length == 0) {
      panelHeight = plot.plotAreaHeight;
      panelWidth  = plot.plotAreaWidth;
    } else {
      panelHeight = plot.plotAreaHeight/plot.layout.nRows;
      panelWidth  = plot.plotAreaWidth/plot.layout.nCols;
    }

    if (panelName != null)
      _doStrip = true;
    
    // map the renderers to use
    if (plot.type != null) {
      renderers = plot.type.map((String e) {
        if (e == "p") {
          return new PointsRenderer(_x, _y, subscripts, theme, _svggroup, panelWidth, panelHeight, col: col);
        }
      }).toList();
    }
  
    
    
    int _panelI = plot.layout.rowIndex(panelNumber);
    
    panelX = 
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