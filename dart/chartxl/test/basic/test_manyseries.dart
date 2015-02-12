library test_manyseries;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
//import 'package:chartxl/src/figure.dart';
import 'package:chartxl/src/chart.dart';
//import 'package:chartxl/src/grid.dart';
import 'package:csv/csv.dart';

List _formatData(List<List<String>> input) {
  
  // need to sort the data
  
  List out = input.map((row) => [
    DateTime.parse(row[0]).toUtc(),    // Hour Beginning GMT
    row[6],                            // node name  
    num.parse(row[14])                 // LMP
    ]).toList();
  
  
  return out;
}


main() {
  ResourceManager resourceManager;
  final csvCodec = new CsvCodec();
  final decoder = csvCodec.decoder;
    
  // setup the Stage and RenderLoop
  html.CanvasElement canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, width: canvas.width, height: canvas.height);
  canvas.width = 900;
  canvas.height = 900;
  stage.scaleMode = StageScaleMode.NO_SCALE;
  stage.align = StageAlign.TOP_LEFT;
  stage.backgroundColor = Color.AliceBlue;

  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  resourceManager = new ResourceManager()
      ..addTextFile("table", "../datasets/20150206_20150206_PRC_LMP_DAM_LMP_short.csv")
      ..load().then((result) {
        var aux = const CsvToListConverter(eol: "\n").convert(resourceManager.getTextFile("table"));
        print(aux.length);
        
        
        
        Chart chart = new Chart(900, 900)
            ..data = data
            ..xData = ((e) => e["Petal.Length"])
            ..yData = ((e) => e["Petal.Width"])
            ..groups = ((e) => e["Species"])
            ..draw();
        stage.addChild(chart);
      });




}
