library plot.plot;

import 'dart:html' as html;
import 'dart:math' as math;
import 'package:chartxl/theme/theme.dart';
import 'package:chartxl/core/aspect.dart';
import 'package:chartxl/renderers/renderer.dart';
import 'package:charted/charted.dart' as charted;
import 'package:chartxl/scale/interpolator.dart';
import 'package:chartxl/plots/panel.dart';
import 'package:charted/core/core.dart';
import 'package:stagexl/stagexl.dart';

/**
 * The standard xyplot in lattice 
 */
class Plot extends DisplayObjectContainer {
  Theme theme = Theme.currentTheme;

  List data;

  /**
   * A shorthand for a corresponding panel function. Accepted values are 
   * [p] for points, [g] for grid, [l] for lines, [o] for both line and points, 
   *  
   */
  List<String> type;
  Function xFun; // an extractor for the x values
  Function yFun; // an extractor for the y values
  Function groupFun; // an extractor for the group
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
  num height;
  /**
   * Specify the width in pixels of the svg that contains the plot.
   */
  num width;


  List xValues;
  List yValues;
  List<String> groupNames = [];
  List<String> panelNames = [];
  Map<String, List<int>> subscripts =
      new Map(); // from panelName to a List of indices for that panel
  Interpolator xScale;
  Interpolator yScale;
  Interpolator scaleGroup;
  List<Panel> panels;

  /**
   * Screen coordinates of the plotting area.  
   */
  Rect plotArea;


  Plot(this.width, this.height) {
    // use the stage dimensions for plot dimensions if not specified
    // TODO: stage is null at this stage as the plot has not been tied to a stage ... 
    //width = this.stage.width;     
    //height = this.stage.height;
  }

  void draw() {
    prepareData();

    //panels.forEach((panel) => panel.draw());

    if (xlab != null) {
    }

    if (ylab != null) {
    }

  }

  void prepareData() {

    if (width == null) width = theme.width;
    if (height == null) height = theme.height;

    // TODO:  be ugly and consider traversing the data only once instead of 8 times!!!

    if (x == null) {
      xValues = new List.generate(data.length, (i) => i + 1);
    } else {
      xValues = data.map(xFun).toList(growable: false); // all the x values
    }

    // if no y extractor is specified, take the first element of the observation
    if (yFun == null) yFun = (obs) => obs[0];
    yValues = data.map(yFun).toList(growable: false); // all the y values

    // calculate the axes limits, what do I with multiple series, etc.?
    // TODO: fix me 
    if (xlim == null) xlim = [charted.min(xValues), charted.max(xValues)];
    if (ylim == null) ylim = [charted.min(yValues), charted.max(yValues)];

    // if the color function has not been specified, specify it here
    if (col == null) {
      if (groupFun == null) {
        col = (d, i, e) => theme.COLORS.first;
      } else {
        groupNames = data.map(groupFun).toSet().toList();
        scaleGroup = new OrdinalInterpolator(groupNames, values: theme.COLORS);
        col = (d, i, e) => scaleGroup(groupFun(data[i]));
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

    //if (markerSize == null) markerSize = (d) => (0.35 * theme.textSize).round();

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
