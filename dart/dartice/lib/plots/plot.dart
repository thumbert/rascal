library plot.plot;

import 'package:dartice/theme/theme.dart';
import 'dart:html' as html;
import 'dart:math' as math;
import 'package:charted/selection/selection.dart';
import 'package:dartice/core/aspect.dart';
import 'package:dartice/renderers/points_renderer.dart';
import 'package:dartice/renderers/renderer.dart';
import 'package:charted/charted.dart' as charted;
import 'package:dartice/scale/interpolator.dart';
import 'package:dartice/panel/panel.dart';
import 'package:dartice/plots/layout.dart';

/**
 * The standard xyplot in lattice 
 */
class Plot {
  Theme theme = Theme.currentTheme;
  List data;
  /**
   * A shorthand for a corresponding panel function. Accepted values are 
   * [p] for points, [g] for grid, [l] for lines, [o] for both line and points, 
   *  
   */
  List<String> type;
  Function x; // an extractor for the x values
  Function y; // an extractor for the y values
  Function group; // an extractor for the group
  Function panel; // an extractor for the panel
  Function col; // a function to specify color (d,i,e) => Color String

  Aspect aspect = Aspect.current;
  /**
   * A text label for the x-axis
   */
  String xlab;
  /**
   * A text label for the y-axis
   */
  String ylab;
  /**
   * A text for the title of this plot
   */
  String title;
  /**
   * Normally a List of two numeric (or DateTime) elements giving left and right limits 
   * for the x-axis.  It can also be list of such lists if there are multiple panels and the 
   * scales are free. 
   */
  List xlim;
  /**
   * Normally a List of two numeric (or DateTime) elements giving left and right limits 
   * for the x-axis.  It can also be list of such lists if there are multiple panels and the 
   * scales are free. 
   */
  List ylim;
  Layout layout;
  
  
  List<Renderer> renderers;
  int height; // svg height in px
  int width; // svg width in px


  List xValues; 
  List yValues; 
  List groupValues = [];
  List panelValues = [];
  Interpolator scaleX;
  Interpolator scaleY;
  Interpolator scaleGroup;
  List<Panel> panels; 
  
  num plotAreaX; 
  num plotAreaY;
  num plotAreaHeight;
  num plotAreaWidth;
  
  html.Element host;
  SelectionScope _scope;
  Selection _svg, _svggroup;

  Plot(html.Element this.host);

  void draw() {
    assert(data != null);

    prepareData();
    
    panels.forEach((panel) => panel.draw());
    

  }

  void prepareData() {
    
    if (width == null) width = theme.width;
    if (height == null) height = theme.height;
    
    /* Create SVG element and other one-time initializations. */
    if (_scope == null) {
      _scope = new SelectionScope.element(host);
      _svg = _scope.append('svg:svg')
          ..classed('dartice-plot')
          ..attr('width', width)
          ..attr('height', height);
      _svggroup = _svg.append('g')..classed('plot-wrapper');
    }

    if (panel != null) 
      panelValues = data.map(panel).toSet().toList();
    
    layout = Layout.defaultLayout( math.max(panelValues.length,1) );
    
    xValues = data.map( x ).toList();  // all the x values 
    yValues = data.map( y ).toList();  // all the y values
    
    if (col == null) {
      if (group == null) {
        col = (d, i, e) => theme.COLORS.first;
      } else {
        groupValues = data.map(group).toSet().toList();
        scaleGroup = new OrdinalInterpolator(groupValues, values: theme.COLORS);
        col = (d, i, e) => scaleGroup( group(data[i]) );
      }
    }    
   
  }

}
