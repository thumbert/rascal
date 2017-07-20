
library demos.select_area;

import 'dart:math';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

/// Select a rectangular area on the screen with the mouse
main() {
  StageOptions stageOptions = new StageOptions()
    ..inputEventMode = InputEventMode.MouseAndTouch
    ..backgroundColor = Color.Beige
    ..antialias = true
    ..renderEngine = RenderEngine.Canvas2D;
  Stage stage = new Stage(html.querySelector('#stage'), options: stageOptions);

  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  bool isSelected = false;
  Sprite rect = new Sprite();
  rect.addTo(stage);
  List<num> topLeft = [];
  List<num> bottomRight = [];

  _onMouseDown(Event e) {
    print('Start selection');
    isSelected = true;
    topLeft = [stage.mouseX, stage.mouseY];
  }
  _onMouseUp(Event e) {
    print('Selection is $topLeft to $bottomRight');
    rect.graphics.clear();
    isSelected = false;
  }
  _onMouseMove(Event e) {
    bottomRight = [stage.mouseX, stage.mouseY];
    rect.graphics.clear();
    if (isSelected) {
      rect.graphics.rect(topLeft[0], topLeft[1],
          bottomRight[0]-topLeft[0], bottomRight[1]-topLeft[1]);
      rect.graphics.strokeColor(Color.Blue);
    }
  }

  stage.onMouseDown.listen(_onMouseDown);
  stage.onMouseUp.listen(_onMouseUp);
  stage.onMouseMove.listen(_onMouseMove);



  /// mouse coordinates on the stage
  var txt = new TextField();
  txt.x = 100;
  txt.y = stage.contentRectangle.height - 50;
  stage.addChild(txt);
  _onEnterFrame(Event e) {
    txt.text = "(x=${stage.mouseX}, y=${stage.mouseY})";
  }
  stage.onEnterFrame.listen(_onEnterFrame);
  stage.addChild(
      new TextField('Select an area on the screen with the mouse',
          new TextFormat("Arial", 20, Color.Black))
    ..x = 100
    ..y = stage.contentRectangle.height - 25
    ..width = 500 );




}
