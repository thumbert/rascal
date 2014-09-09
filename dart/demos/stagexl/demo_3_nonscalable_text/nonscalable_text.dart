library nonscalable_text;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

/**
 * Impossible to make a non-scalable text.  Text will scale together with the rest 
 * of the objects and 
 */

void main() {

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, width: 800, height: 600);
  stage.scaleMode = StageScaleMode.NO_SCALE;
  //stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.TOP_LEFT;
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);
  
  stage.addChild(new Bitmap(
     new BitmapData(stage.contentRectangle.width.toInt(), stage.contentRectangle.height.toInt(), false, Color.Beige)));
  
  stage.addChild(new Shape()
    ..graphics.circle(100, 100, 50)
    ..graphics.fillColor(Color.Red));
  
  var textField = new TextField();
  textField.defaultTextFormat = new TextFormat("Arial", 32, Color.Black, bold:false);
  textField.text = "Hello world!";
  textField.background = true;
  textField.backgroundColor = Color.LightGray;
  textField.width = 700;
  textField.height = 32;
  textField.x = 50;
  textField.y = 200;
  stage.addChild(textField);  
}
