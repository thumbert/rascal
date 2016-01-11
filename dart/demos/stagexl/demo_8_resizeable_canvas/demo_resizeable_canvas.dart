library demo_resizeable_canvas;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/figure.dart';
import 'package:demos/graphics/key.dart';

void main() {
  StageOptions stageOptions = new StageOptions()
    ..backgroundColor = Color.Beige
    ..antialias = true
    ..renderEngine = RenderEngine.Canvas2D;

  Stage stage = new Stage(html.querySelector('#stage'), options: stageOptions);
  RenderLoop renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  List xData = [100, 200, 300, 400, 500];
  List y1Data = [100, 300, 200, 100, 500];
  List y2Data = [100, 500, 400, 360, 200];

  Figure fig = new Figure(stage)
    ..line(xData, y1Data)
    ..line(xData, y2Data)
    ..key = new Key()
    ..draw();



//  Layout layout = new Layout(stage)
//    ..matrix = [1,2]
//    ..panel(1, fig)
//    ..panel(2, fig)
//    ..draw();


}
