library demo1;

import 'dart:html';
import 'package:charted/charts/charts.dart';
import 'dart:math';


makeData( {int variables: 4} ) {
  DateTime startDateTime = new DateTime(2014, 1, 1, 1);    
  DateTime endDateTime = new DateTime(2014, 2, 1);
  Duration h1 = new Duration(hours: 1);
  Random rand = new Random();
  
  // initialize it
  List<List> res = [];
  res.add([startDateTime]..addAll(new List.filled(variables, 40.0)));  
    
  DateTime t = startDateTime;
  while (t.isBefore(endDateTime)) {
    List last = res.last.sublist(1);
    res.add([t]..addAll(last.map((double e) => (100*(e + rand.nextDouble()-0.5)).round()/100)));
    t = t.add(h1); 
  }
  
  return res;
}



makeColumns(int variables) {
  List res = [new ChartColumnSpec(label:'Timestamp', type:ChartColumnSpec.TYPE_TIMESTAMP)];
  for (int i=0; i<variables; i++){
    res.add(new ChartColumnSpec(label:'X${i}'));
  }

  return res;
}


main() {
  int variables = 4;
  List DATA = makeData(variables: variables);
  List COLUMNS = makeColumns( variables );
  
  
  var series = new List.generate(variables, (i) => new ChartSeries('X$i', [i+1], new LineChartRenderer())),
      data = new ChartData(COLUMNS, DATA),
      config = new ChartConfig(series, [0]),
      area = new ChartArea(querySelector('.hourly-chart'),
          data, config, autoUpdate:false, dimensionAxesCount:1);
  
  area.addChartBehavior( new AxisMarker() );    // cross-hair
  area.addChartBehavior( new ChartTooltip() );  // tooltip
  area.draw();
  
  // too slow, so avoid writing the individual <circle> elements.  Keep the paths only.
  // or at least, do those later ... 
}
