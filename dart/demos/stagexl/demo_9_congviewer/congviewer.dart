
import 'dart:html';
import 'package:stagexl/stagexl.dart';
import 'package:tuple/tuple.dart';

import 'package:demos/graphics/chart.dart';

Stage stage;

main() {
  StageOptions stageOptions = new StageOptions()
    ..inputEventMode = InputEventMode.MouseAndTouch
    ..backgroundColor = Color.Beige
    ..antialias = true
    ..renderEngine = RenderEngine.Canvas2D;
  stage = new Stage(querySelector('#stage'), options: stageOptions);

  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  print("stage width = ${stage.width}, height=${stage.height}");
  print("contentRectange = ${stage.contentRectangle}");

  Chart chart =  new Chart(800,600)
   ..xLimit(0,100)
   ..yLimit(0,50);

//  Chart chart =  new Chart(800,600)
//    ..xLimit(new DateTime(2017,1,1), new DateTime(2017,7,1))
//    ..yLimit(0, 50);



  stage.addChild(chart);


}