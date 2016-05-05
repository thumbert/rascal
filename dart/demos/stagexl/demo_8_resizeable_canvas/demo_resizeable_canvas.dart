library demo_resizeable_canvas;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:demos/graphics/figure.dart';
import 'package:demos/graphics/layout.dart';
import 'package:demos/graphics/key.dart';

void main() {
  StageOptions stageOptions = new StageOptions()
    ..backgroundColor = Color.Beige
    ..antialias = true
    ..renderEngine = RenderEngine.Canvas2D;

  Stage stage = new Stage(html.querySelector('#stage'), options: stageOptions);
  RenderLoop renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  List xData  = [100, 200, 300, 400, 500];
  List y1Data = [10, 30, 27, 10, 50];
  List y2Data = [15, 50, 40, 36, 20];


  new Figure()
    ..line(xData, y1Data)
    ..line(xData, y2Data, color: Color.HotPink)
    ..xLabel = 'Number of days, ${new String.fromCharCode(0x03BC)}'
    ..yLabel = 'Intensity'
    ..title = 'Dynamics of bat population in underground Spanish caves'
    //..key = new Key()
    ..addTo(stage)
    ..draw();

//  Layout layout = new Layout(stage)
//    ..matrix = [1,2]
//    ..panel(1, fig)
//    ..panel(2, fig)
//    ..draw();




}
