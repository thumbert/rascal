library renderers.points_renderer;
import 'package:charted/selection/selection.dart';
import 'package:dartice/renderers/renderer.dart';
import 'package:charted/charted.dart' as charted;
import 'package:dartice/scale/interpolator.dart';
import 'package:dartice/theme/theme.dart';
import 'package:dartice/plots/plot.dart';
import 'package:dartice/plots/panel.dart';


class PointsRenderer extends Renderer {

  String classed;
  List x; // data for the x variable for this panel
  List y; // data for the y variable for this panel
  int panelNumber; // the number of the panel this corresponds to
  Plot plot; // the parent plot
  Selection _host;
  Panel panel;
  int panelWidth; // this panel width
  int panelHeight; // this panel height

  Function col; // a function (d,i,e) => string color
  Function cex; // a function (d,i,e) => percent of plotting text

  Theme theme;
  num minX, maxX, minY, maxY;
  Interpolator scaleX, scaleY;


  PointsRenderer(List this.x, List this.y, Panel this.panel, Selection this._host, {Function
      this.col, Function this.cex, String this.classed}) {

    classed = "panel-${panel.panelNumber}-points";
    plot = panel.plot;
    minX = plot.xlim[0];
    maxX = plot.xlim[1];
    scaleX = new NumericalInterpolator.fromPoints(minX, maxX, 10, panel.position.width - 10); //TODO

    minY = plot.ylim[0];
    maxY = plot.ylim[1];
    scaleY = new NumericalInterpolator.fromPoints(minY, maxY, panel.position.height - 10, 10 + panel.stripHeight);

    theme = plot.theme;

    if (col == null) col = (d, i, e) => theme.COLORS.first;

  //  if (cex == null) cex = (d, i, e) => 0.8;
  }

  void draw() {
    Selection _group;
    _group = _host.append('g')..classed(classed);


    var points = _group.selectAll(classed).data(y);
    points.enter.append('circle')
        ..classed(classed, true)
        ..attrWithCallback('r', (d, i, e) => panel.plot.markerSize(d))
        ..attrWithCallback('data-row', (d, i, e) => i)
        ..attrWithCallback('cx', (d, i, e) => scaleX(x[i]))
        ..attrWithCallback('cy', (d, i, e) => scaleY(y[i]))
        ..styleWithCallback('stroke', col)
        ..styleWithCallback('fill', (d, i, e) => theme.backgroundColor)
        ..style('fill-opacity', '0')
        ..style('opacity', '1');


  }

}
