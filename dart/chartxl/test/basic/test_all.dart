library test_all;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

import 'package:chartxl/src/theme.dart';
import 'test_ticks_position.dart';
import 'test_markers.dart';

import 'package:chartxl/src/interpolator.dart';

html.CanvasElement canvas = html.querySelector('#stage');
Stage stage = new Stage(canvas, color: Color.Beige);

RenderLoop renderLoop = new RenderLoop();


main() {
  renderLoop.addStage(stage);
  
  print(theme);
  
  //test_ticks_position();
  test_markers();
  
  var fun = new NumericalInterpolator.fromSlope(1, 0);
  print(fun(0.5));
  var fun2 = new NumericalInterpolator.fromPoints(0, 1, 2, 12);
  print(fun2(0.4));
  
  num c = 0xf0f8ff;
  print(c.toString());
  
}
