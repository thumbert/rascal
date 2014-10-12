library test_all;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

import 'package:chartxl/src/theme.dart';
import 'test_ticks_position.dart';
import 'test_markers.dart';

html.CanvasElement canvas = html.querySelector('#stage');
Stage stage = new Stage(canvas, color: Color.Beige);

RenderLoop renderLoop = new RenderLoop();


main() {
  renderLoop.addStage(stage);
  
  print(theme);
  
  //test_ticks_position();
  test_markers();
  
  
}