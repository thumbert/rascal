library demo_axis_datetime;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'dart:math';
import 'dart:html';

CanvasElement canvas = html.querySelector('#stage');
Stage stage = new Stage(canvas);


main() {
  RenderLoop renderLoop = new RenderLoop();
  renderLoop.addStage(stage);
  stage.backgroundColor = Color.Beige;





}