library basic_chart1;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

void main() {

  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas);
  stage.backgroundColor = Color.AliceBlue;
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  var textField = new TextField();
  textField.defaultTextFormat = new TextFormat("Arial", 22, Color.Black, bold: true);
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


