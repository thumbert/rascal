library plot.plot;

import 'package:chartxl/theme/theme.dart';
import 'dart:html' as html;
import 'dart:math' as math;
import 'package:charted/selection/selection.dart';
import 'package:chartxl/core/aspect.dart';
import 'package:chartxl/renderers/renderer.dart';
import 'package:charted/charted.dart' as charted;
import 'package:chartxl/scale/interpolator.dart';
import 'package:chartxl/plots/panel.dart';
import 'package:chartxl/plots/layout.dart';
import 'package:charted/core/core.dart';

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
  Function markerSize; // a function to control the size of the marker

  Aspect aspect = Aspect.current;
  /**
   * A text label for the x-axis
   */
  String xlab;
  /**
   * A text label for the left y-axis
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
  /**
   * A two element List<int> for manually specifiying the arrangement of the panels in number 
   * of rows and columns, [nRows, nCols].  Number of panels in the layout to be larger than the 
   * actual number of panels to plot.       
   */
  List<int> layout;
  /**
   * The order of the groupValues.  An optional List<String>. 
   */
  List<String> groupOrder;
  /**
   * The order of the panelValues.  An optional List<String>. 
   */
  List<String> panelOrder;


  List<Renderer> renderers;
  /**
   * Specify the height in pixels of the svg that contains the plot.
   */
  int height;
  /**
   * Specify the width in pixels of the svg that contains the plot.
   */
  int width;


  List xValues;
  List yValues;
  List<String> groupNames = [];
  List<String> panelNames = [];
  Map<String, List<int>> subscripts =
      new Map(); // from panelName to a List of indices for that panel
  Interpolator scaleX;
  Interpolator scaleY;
  Interpolator scaleGroup;
  List<Panel> panels;

  /**
   * Screen coordinates of the plotting area.  This includes all the panels.  The panel strip and 
   * the ticks of axes are included in the plotting area.
   */
  Rect plotArea; // screen coordinates of the plot area

  /**
   * The top html Element that contains the plot.
   */
  html.Element host;
  SelectionScope _scope;
  Selection _svg, _svggroup;

  Plot(html.Element this.host);

  void draw() {
    assert(data != null);

    prepareData();

    panels.forEach((panel) => panel.draw());

    if (xlab != null) {
      DataSelection _xlab = _svggroup.selectAll('xlab').data([0]);
      _xlab.enter.append('text');
      _xlab
          ..classed("xlab", true)
          ..text(xlab)
          ..attr('text-anchor', 'middle')
          ..attr(
              'transform',
              'translate(${0.5*width}, ${height-0.5*theme.textSize}) rotate(${theme.xlabRotation})')
          ..style('fill', "#000000");
      _xlab.exit.remove();
    }

    if (ylab != null) {
      DataSelection _ylab = _svggroup.selectAll('ylab').data([0]);
      _ylab.enter.append('text');
      _ylab
          ..classed("ylab", true)
          ..text(ylab)
          ..attr('text-anchor', 'middle')
          ..attr(
              'transform',
              'translate(${theme.textSize}, ${plotArea.y + 0.5*plotArea.height}) rotate(${theme.ylabRotation})')
          ..style('fill', "#000000");
      _ylab.exit.remove();
    }

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
      var aux = data.asMap();
      aux.forEach((idx, obs) {
        //print("idx=${idx}, obs=${obs}");
        subscripts.putIfAbsent(panel(obs), () => []).add(idx);
      });
      panelNames = subscripts.keys.toList(growable: false);
    } else {
      subscripts = {
        null: new List.generate(data.length, (i) => i, growable: false)
      };
    }

    if (layout == null) {
      // if the layout is not set by hand, get the default one
      Layout _layout = Layout.defaultLayout(math.max(panelNames.length, 1));
      layout = [_layout.nRows, _layout.nCols];
    } else {
      assert(layout.length == 2);
      assert(layout[0] * layout[1] >= subscripts.length);
    }

    // TODO:  be ugly and consider traversing the data only once instead of 8 times!!!

    xValues = data.map(x).toList(growable: false); // all the x values
    yValues = data.map(y).toList(growable: false); // all the y values

    if (xlim == null) xlim = [charted.min(xValues), charted.max(xValues)];
    if (ylim == null) ylim = [charted.min(yValues), charted.max(yValues)];

    // if the color function has not been specified, specify it here
    if (col == null) {
      if (group == null) {
        col = (d, i, e) => theme.COLORS.first;
      } else {
        groupNames = data.map(group).toSet().toList();
        scaleGroup = new OrdinalInterpolator(groupNames, values: theme.COLORS);
        col = (d, i, e) => scaleGroup(group(data[i]));
      }
    }

    /**
     * 
     */
    plotArea = new Rect(
        _spacingLeft(),
        _spacingTop(),
        width - _spacingLeft() - _spacingRight(),
        height - _spacingTop() - _spacingBottom()); // TODO: fix me!!!

    if (markerSize == null) markerSize = (d) => (0.35 * theme.textSize).round();


    // construct the panels
    if (panelNames.isEmpty) {
      panels = [new Panel(null, this, _svggroup)];
    } else {
      panels = panelNames.map((String panelName) => new Panel(panelName, this, _svggroup)).toList();
    }


  }

  // from the top side of the figure to the top side of the plotting area
  num _spacingTop() => theme.textSize + (title != null ? theme.textSize * 1.5 : 0);

  // from the left side of the figure to the left side of the plotting area
  num _spacingLeft() => theme.textSize + (ylab != null ? theme.textSize * 1.5 : 0);

  // from the right side of the figure to the right side plotting area
  num _spacingRight() => theme.textSize;

  // from the bottom side of the figure to the bottom side of the plotting area
  num _spacingBottom() => theme.textSize + (xlab != null ? theme.textSize * 1.5 : 0);


}
