library plots.panel;


//import 'package:charted/selection/selection.dart';
//import 'package:chartxl/renderers/renderer.dart';
//import 'package:chartxl/plots/plot.dart';
//import 'package:chartxl/plots/layout.dart';
//import 'package:chartxl/renderers/points_renderer.dart';
//import 'package:charted/core/core.dart';

//class Panel {
//  String panelName;
//  int panelNumber = 0;
//  Plot plot;
//  List<Renderer> renderers;
//  Selection _host; // selection for the html Element of this panel
//
//  Rect position; // the screen coordinates of this panel
//  List xValues = []; // the xValues associated with this panel
//  List yValues = []; // the yValues associated with this panel
//
//  bool _doStrip = true; // draw the strip
//  num stripHeight = 0;  // in pixels
//  
//  Panel(String this.panelName, Plot this.plot, Selection this._host) {
//
//    if (plot.panel != null) {
//      // if you have panels
//      List idx = plot.subscripts[panelName];
//      idx.forEach((i) {
//        xValues.add(plot.xValues[i]);
//        yValues.add(plot.yValues[i]);
//      });
//
//      panelNumber = plot.panelNames.indexOf(panelName);
//      Layout layout = new Layout(plot.layout[0], plot.layout[1]);
//      num height = plot.plotArea.height / plot.layout[0];
//      num width = plot.plotArea.width / plot.layout[1];
//      int i = layout.rowIndex(panelNumber);
//      int j = layout.colIndex(panelNumber);
//      num x = j * width + plot.plotArea.x;
//      num y = i * height + plot.plotArea.y;
//      position = new Rect(x, y, width, height);
//      stripHeight = (plot.theme.textSize*2);
//
//
//    } else {
//      // if you don't have panels
//      xValues = plot.xValues;
//      yValues = plot.yValues;
//      position = new Rect(0, 0, plot.plotArea.width, plot.plotArea.height);
//      _doStrip = false;
//    }
//
//    Selection _group;
//    _group = _host.append('g')
//        ..classed("panel-${panelNumber}")
//        ..attrWithCallback('transform', (d, i, c) => 'translate(${position.x}, ${position.y})');
//    
//    if (_doStrip) {
//      DataSelection border = _group.selectAll('.border').data([0]);
//      border.enter.append('rect');
//      border
//          ..attr('width', position.width)
//          ..attr('height', position.height)
//          ..style('shape-rendering', 'crispEdges') // how to pass this in the style sheet!
//          ..style('fill', "#ffffff")
//          ..style('stroke-width', "1")
//          ..style('stroke', "#000000");
//      border.exit.remove();
//      DataSelection strip = _group.selectAll('.strip').data([0]);
//      strip.enter.append('rect');
//      strip
//          ..attr('width', position.width)
//          ..attr('height', stripHeight)
//          ..style('shape-rendering', 'crispEdges') // how to pass this in the style sheet!
//          ..style('fill', plot.theme.STRIP_COLORS.first)
//          ..style('stroke-width', "1")
//          ..style('stroke', "#000000");
//      strip.exit.remove();
//
//      DataSelection stripText = _group.selectAll('.stripText').data([0]);
//      stripText.enter.append('text');
//      stripText
//          ..text(panelName)
//          ..attr('x', position.width / 2)
//          ..attr('y', 0.5*(plot.theme.textSize + stripHeight))
//          ..attr('text-anchor', 'middle')
//          ..style('fill', "#000000");
//      stripText.exit.remove();
//    }
//
//
//    // map the renderers to use
//    if (plot.type != null) {
//      renderers = plot.type.map((String e) {
//        if (e == "p") {
//          return new PointsRenderer(xValues, yValues, this, _group, col: plot.col);
//        }
//      }).toList();
//    }
//
//  }
//
//
//
//  void draw() {
//    renderers.forEach((renderer) => renderer.draw());
//  }
//
//}


