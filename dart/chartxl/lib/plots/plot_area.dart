library plots.plot_area;

import 'package:stagexl/stagexl.dart';
import 'package:chartxl/plots/plot.dart';

/**
 * Class to keep track of what needs to be drawn inside the plotting area. 
 * Axes and other annotations are treated separately.  
 */
class PlotArea extends DisplayObjectContainer {

  num width;
  num height;
  
  Plot _plot;
  
  PlotArea(this.width, this.height);
  
}