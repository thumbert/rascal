library basic_chart1;

import 'dart:html' as html;
import 'package:chartxl/src/chart.dart';
import 'package:stagexl/stagexl.dart';

// an editable text field ...
void main() {

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas);
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  var textField = new TextField();
  textField.defaultTextFormat = new TextFormat("Arial", 22, Color.Black, bold:true);
  textField.text = "test";
  textField.background = true;
  textField.backgroundColor = Color.LightGray;
  textField.width = 700;
  textField.height = 30;
  textField.x = 50;
  textField.y = 100;

  stage.addChild(textField);
  stage.focus = textField;

  textField.onKeyDown.listen((KeyboardEvent e) {
    if (e.keyCode == 8 && textField.text.length > 0) {
      var len = textField.text.length;
      textField.text = textField.text.substring(0, len - 1);
    }
  });

  textField.onTextInput.listen((TextEvent e) {
    textField.text = textField.text + e.text;
  });

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

