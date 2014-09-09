library basic_chart1;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:chartxl/src/figure.dart';
import 'package:chartxl/src/chart.dart';

void main() {

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

  Figure fig = new Figure(width: 800, height: 800);
  fig.add(new Shape() 
    ..graphics.circle(400, 100, 60)
    ..graphics.fillColor(Color.Red));
  
  Chart chart = new Chart();
  fig.add(chart);
  
  
}


//main() {
//  
//  Chart chart = new Chart();
//  
//  // setup the Stage and RenderLoop 
//    var canvas = html.querySelector('#stage');
//    var stage = new Stage(canvas);
//    var renderLoop = new RenderLoop();
//    renderLoop.addStage(stage);
//  
//    // draw a red circle
//     var shape = new Shape();
//     shape.graphics.circle(100, 100, 60);
//     shape.graphics.fillColor(Color.Red);
//     stage.addChild(shape);
//  
//}

