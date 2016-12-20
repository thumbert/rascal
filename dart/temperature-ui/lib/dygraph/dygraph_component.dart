
import 'dart:math' show Random;
import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:dygraphs_dart/dygraphs_dart.dart';

@Component(
    selector: 'dygraph',
    template: '''
      <div #dygraphvis
        width="300"
        height="100"></div>
    ''')
class DygraphComponent implements AfterViewInit {

  @ViewChild('dygraphvis')
  ElementRef dygraphvis;

  ngAfterViewInit() {
    List data = getData(5, 200);
    Option opt = new Option(
        animatedZooms: true,
        highlightSeriesOpts: new HighlightSeriesOpts(
            pointSize: 30,
            strokeWidth: 2,
            strokeBorderWidth: 10,
            highlightCircleSize: 3),
        showLabelsOnHighlight: false
    );
    new Dygraph(dygraphvis.nativeElement, data, opt);
  }

}



List<List<num>> getData(int noSeries, int noObs) {
  Random r = new Random();
  List<List<num>> res = new List.generate(noObs, (i) => [i]);
  res.first.addAll(new List.generate(noSeries, (i) => r.nextDouble() - 0.5));

  for (int i = 1; i < noObs; i++) {
    for (int j = 0; j < noSeries; j++) {
      res[i].add(res[i - 1][j + 1] + r.nextDouble() - 0.5);
    }
  }

  return res;
}