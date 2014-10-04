library basic_chart1;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'package:chartxl/src/figure.dart';
import 'package:chartxl/src/chart.dart';
import 'package:chartxl/src/grid.dart';
import 'dart:html';


void main() {

 

//  Figure fig = new Figure(width: 800, height: 600);
//  
//  Chart chart = new Chart();
//  fig.add(chart);
//  chart.draw();

  // setup the Stage and RenderLoop 
    html.CanvasElement canvas = html.querySelector('#stage');        
    var stage = new Stage(canvas, width: canvas.width, height: canvas.height);
    canvas.width  = 800;
    canvas.height = 600;
    stage.scaleMode = StageScaleMode.NO_SCALE;
    stage.align = StageAlign.TOP_LEFT;
    stage.backgroundColor = Color.AliceBlue;
    var renderLoop = new RenderLoop();
    renderLoop.addStage(stage);
  
  Grid grid = new Grid(
      new List.generate(stage.stageWidth~/100, (i) => i*100), 
      new List.generate(stage.stageHeight~/100, (i) => i*100), 
      stage.stageWidth, stage.stageHeight)
      ..graphics.strokeColor(Color.YellowGreen, 1);
    
  print("grid width = ${grid.width}");
  
  
  grid.addTo(stage);
  print("done");
  
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

