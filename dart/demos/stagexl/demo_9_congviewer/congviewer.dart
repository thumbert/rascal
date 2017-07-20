
import 'dart:html';
import 'package:stagexl/stagexl.dart';
import 'package:tuple/tuple.dart';

import 'package:demos/graphics/chart.dart';

main() {
  StageOptions stageOptions = new StageOptions()
    ..inputEventMode = InputEventMode.MouseAndTouch
    ..backgroundColor = Color.Beige
    ..antialias = true
    ..renderEngine = RenderEngine.Canvas2D;
  Stage stage = new Stage(querySelector('#stage'), options: stageOptions);

  var renderLoop = new RenderLoop();
  var juggler = renderLoop.juggler;
  renderLoop.addStage(stage);

  print("stage width = ${stage.width}, height=${stage.height}");
  print("contentRectange = ${stage.contentRectangle}");

  Chart chart =  new Chart();
  chart.xLimit( new Tuple2(0,100) );
  chart.yLimit( new Tuple2(0,50) );



  stage.addChild(chart);


}