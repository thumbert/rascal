library plot.plot;

import 'package:dartice/theme/theme.dart';
import 'dart:html' as html;
import 'package:charted/selection/selection.dart';
import 'package:dartice/core/aspect.dart';
import 'package:dartice/renderers/points_renderer.dart';
import 'package:dartice/renderers/renderer.dart';
import 'package:charted/charted.dart' as charted;
import 'package:dartice/scale/interpolator.dart';

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
  List<Renderer> renderers;
  int height; // svg height in px
  int width; // svg width in px


  List _xValues; // in screen coordinates
  List _yValues; // in screen coordinates
  List _groupValues = [];
  List _panelValues = [];
  Interpolator scaleX;
  Interpolator scaleY;
  Interpolator scaleGroup;

  html.Element host;
  SelectionScope _scope;
  Selection _svg, _svggroup;

  Plot(html.Element this.host);

  void draw() {
    assert(data != null);

    prepareData();
    
    renderers.forEach((renderer) => renderer.draw());

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

    if (panel != null) {
      _panelValues = data.map(panel).toSet().toList();
    }
    

    var _x = data.map( x ).toList();
    var _y = data.map( y ).toList();
    var subscripts = null;
    
    if (col == null) {
      if (group == null) {
        col = (d, i, e) => theme.COLORS.first;
      } else {
        _groupValues = data.map(group).toSet().toList();
        scaleGroup = new OrdinalInterpolator(_groupValues, values: theme.COLORS);
        col = (d, i, e) => scaleGroup( group(d) );
      }
    }

    // map the renderers to use
    if (type != null) {
      renderers = type.map((String e) {
        if (e == "p") {
          return new PointsRenderer(_x, _y, subscripts, col, _svggroup);
        }
//        switch (e) {
//          case "p":
//            return new PointsRenderer(_x, _y, subscripts, col, _svggroup);
//          default:
//            throw new StateError("renderer type ${e} not implemented");
//        }
      }).toList();
    }
    
  }

}
