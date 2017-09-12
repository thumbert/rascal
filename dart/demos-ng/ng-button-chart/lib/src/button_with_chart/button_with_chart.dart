
import 'dart:math';
import 'dart:html';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'package:dygraphs_dart/dygraphs_dart.dart';


@Component(
  selector: 'button-with-chart',
  templateUrl: 'button_with_chart.html',
  directives: const [
    MaterialButtonComponent,
    MaterialFabComponent,
    MaterialIconComponent,
  ],
)
class ButtonWithChart implements OnInit {
   Dygraph chart;
   Option option;
   int count = 0;

   @override
   ngOnInit() {
     option = new Option(
         animatedZooms: true,
         highlightSeriesOpts: new HighlightSeriesOpts(
             pointSize: 2,
             strokeWidth: 2,
             strokeBorderWidth: 10,
             highlightCircleSize: 0),
         showLabelsOnHighlight: false
     );
   }

   plotMe() {
     count = count + 1;
     List data = getData(10, 200);
     new Dygraph(querySelector('#graphdiv'), data, option);
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
