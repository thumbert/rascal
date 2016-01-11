
import 'dart:math';
import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';


main() {
  StageOptions stageOptions = new StageOptions()
    ..inputEventMode = InputEventMode.MouseAndTouch
    ..backgroundColor = Color.Beige
    ..antialias = true
    ..renderEngine = RenderEngine.Canvas2D;
  Stage stage = new Stage(html.querySelector('#stage'), options: stageOptions);

  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  num left;
  num right;
  List<num> coords = [];

  Sprite area = new Sprite();
  Sprite selection = new Sprite();
  selection.y = 50;

  area.graphics.rect(300, 50, 300, 200);
  area.graphics.fillColor(Color.Blue);
  area.addTo( stage );
  selection.addTo(stage);  // needs to be added after the area
  _onMouseDown(Event e) {
    print('inside');
    coords = [];
    if (stage.mouseX >= 300 && stage.mouseX <= 600) {
      if (left == null) left = stage.mouseX;
      //isSelecting = true;
      right = left;
      selection.x = left;
    }
  }
  _onMouseUp(Event e) {
    coords = [left, right];
    print('Selection is ${[left,right]}');
    /// do something special with the selection
    left = null;
    right = null;
    //isSelecting = false;
    selection.graphics.clear();
  }
  _onMouseMove(Event e) {
    if (left != null) {
      if (stage.mouseX < right) {
        // going left
        selection.graphics.rect(0, 0, max(right-stage.mouseX,0), 200);
        selection.graphics.fillColor(Color.Blue);
      } else {
        // going right
        selection.graphics.rect(0, 0, max(right-left,0), 200);
        selection.graphics.fillColor(Color.Pink);
      }
      right = max(min(max(right, stage.mouseX), 600), left);
    }
  }

  area.onMouseDown.listen(_onMouseDown);
  area.onMouseUp.listen(_onMouseUp);
  area.onMouseMove.listen(_onMouseMove);



  /// mouse coordinates on the stage
  var txt = new TextField();
  txt.x = 100;
  txt.y = stage.contentRectangle.height - 50;
  stage.addChild(txt);
  _onEnterFrame(Event e) {
    txt.text = "(x=${stage.mouseX}, y=${stage.mouseY})";
  }
  stage.onEnterFrame.listen(_onEnterFrame);





}
