library test_manyseries;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
//import 'package:chartxl/src/figure.dart';
import 'package:chartxl/src/chart.dart';
//import 'package:chartxl/src/grid.dart';
import 'package:csv/csv.dart';
import 'package:more/ordering.dart';
import 'package:chartxl/plots/plot.dart';

List _formatData(List<List<String>> input) {
  
  // each element of the list is [datetime, nodeName, LMP]
  List<List> out = input.skip(1).map((row) => [
    DateTime.parse(row[0]).toUtc(),    // Hour Beginning GMT
    row[6],                            // node name  
    row[14]                 // LMP
    ]).toList();
  
  var ord = new Ordering.natural();
  Ordering byTimestamp = ord.onResultOf((e) => e[0]);
  Ordering byName= ord.onResultOf((e) => e[1]);
  Ordering byNameTimestamp = byName.compound( byTimestamp );
  byNameTimestamp.sort(out);
  
  return out;
}


main() {
  ResourceManager resourceManager;
    
  // setup the Stage and RenderLoop
//  html.CanvasElement canvas = html.querySelector('#stage');
//  var stage = new Stage(canvas, width: canvas.width, height: canvas.height);
//  canvas.width = 900;
//  canvas.height = 900;
//  stage.scaleMode = StageScaleMode.NO_SCALE;
//  stage.align = StageAlign.TOP_LEFT;
  var stage = new Stage( html.querySelector('#stage') );
  stage.backgroundColor = Color.AliceBlue;

  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  resourceManager = new ResourceManager()
      ..addTextFile("table", "../datasets/20150206_20150206_PRC_LMP_DAM_LMP_short.csv")
      ..load().then((result) {
        var aux = const CsvToListConverter(eol: "\n").convert(resourceManager.getTextFile("table"));
        
        List data = _formatData(aux);
        
        Plot plot = new Plot(600, 600)
            ..data = data
            ..xFun = ((e) => e[0])
            ..yFun = ((e) => e[1])
            ..groupFun = ((e) => e[2])
            ..draw();
        stage.addChild( plot );
      });




}
