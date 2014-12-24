
library plot.plot;

import 'package:dartice/theme/theme.dart';
import 'dart:html' as html;
import 'package:charted/selection/selection.dart';

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
  
  html.Element _host;
  SelectionScope _scope;
  Selection _svg, _group;
  
  html.Element get host => _host;
    
  
  Plot(){
    
  }
  
  void draw() {
    assert(data != null);
    
    /* Create SVG element and other one-time initializations. */
    if (_scope == null) {
      _scope = new SelectionScope.element(host);
      _svg = _scope.append('svg:svg')..classed('charted-chart');
      _group = _svg.append('g')..classed('chart-wrapper');
    }

    
    
    
    
  }
  
  
  
}

