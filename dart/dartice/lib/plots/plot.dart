
library plot.plot;

import 'package:dartice/theme/theme.dart';
import 'dart:html' as html;
import 'package:charted/selection/selection.dart';
import 'package:dartice/core/aspect.dart';

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
  Function x;        // an extractor for the x values
  Function y;        // an extractor for the y values
  Function group;    // an extractor for the group 
  Function panel;    // an extractor for the panel
  
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
  
  
  html.Element host;
  SelectionScope _scope;
  Selection _svg, _group;
  
  
  
  Plot(html.Element this.host){
    
  }
  
  void draw() {
    assert(data != null);
    
    /* Create SVG element and other one-time initializations. */
    if (_scope == null) {
      _scope = new SelectionScope.element(host);
      _svg = _scope.append('svg:svg')..classed('dartice-plot');
      _group = _svg.append('g')..classed('plot-wrapper');
    }

    
    
    
    
  }
  
  
  
}

