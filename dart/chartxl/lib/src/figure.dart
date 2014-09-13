library figure;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';
import 'dart:html';


/**
 * A Figure can hold one or more charts.
 */
class Figure {
  
  CanvasElement canvas;
  Stage stage;
  
  Figure({int width: 800, int height: 600}){
    canvas = html.querySelector('#stage');
    canvas.height = height;
    canvas.width  = width;
    
    stage = new Stage(canvas, width: width, height: height);
    //stage.scaleMode = StageScaleMode.SHOW_ALL;
    stage.scaleMode = StageScaleMode.NO_SCALE;
    stage.align = StageAlign.TOP_LEFT;
    var renderLoop = new RenderLoop();
    renderLoop.addStage(stage);
    
    stage.addChild( new Bitmap(
        new BitmapData(width, height, false, Color.Beige)));
  } 
  
  void add(DisplayObject obj) {
    stage.addChild( obj );
  }
  
  void draw() {
    
  }
  
}
