library basic_chart1;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

void main() {

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  List<Map> data = [
    {"x" : 1, "y": 1,  "group": "linear"}, 
    {"x" : 2, "y": 2,  "group": "linear"},
    {"x" : 3, "y": 3,  "group": "linear"}, 
    {"x" : 4, "y": 4,  "group": "linear"},
    {"x" : 1, "y": 1,  "group": "quadratic"}, 
    {"x" : 2, "y": 4,  "group": "quadratic"},
    {"x" : 3, "y": 9,  "group": "quadratic"}, 
    {"x" : 4, "y": 16, "group": "quadratic"}
    ]; 
  
  
  
  
}



