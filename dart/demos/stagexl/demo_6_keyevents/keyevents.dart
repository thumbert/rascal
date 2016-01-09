library keyevents;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

var keyMap = new Map<int, bool>();

class Line extends Sprite {
  List<num> xData;
  List<num> yData;
  int color;

  Line(this.xData, this.yData, this.color) {
    mouseEnabled = true;
    onMouseOver.listen(_onMouseOver);
    onMouseOut.listen(_onMouseOut);
    onMouseWheel.listen(_onMouseWheel);
  }

  draw({num strokeWidth: 1.5}) {
    graphics.moveTo(xData.first, yData.first);
    for (int i = 1; i < xData.length; i++) {
      graphics.lineTo(xData[i], yData[i]);
    }
    graphics.strokeColor(color, width = strokeWidth);
  }

  void _onMouseWheel(Event e) {
    print('Wheelling!');
  }

  void _onMouseOver(Event e) {
    print('over!');
    graphics.clear();
    draw(strokeWidth: 5);
  }

  void _onMouseOut(Event e) {
    graphics.clear();
    draw(strokeWidth: 1.5);
  }
}

class Spaceship extends DisplayObjectContainer implements Animatable {
  Spaceship() {
    var bitmap = new Bitmap(new BitmapData(64, 64, Color.Magenta));
    addChild(bitmap);
  }
  bool advanceTime(num deltaTime) {
    if (keyMap[87] == true) this.y -= deltaTime * 100; // W
    if (keyMap[83] == true) this.y += deltaTime * 100; // S
    if (keyMap[65] == true) this.x -= deltaTime * 100; // A
    if (keyMap[68] == true) this.x += deltaTime * 100; // D
    return true;
  }
}

main() {
  StageOptions stageOptions = new StageOptions()
    ..inputEventMode = InputEventMode.MouseAndTouch
    ..backgroundColor = Color.Beige
    ..antialias = true
    ..renderEngine = RenderEngine.Canvas2D;
  Stage stage = new Stage(html.querySelector('#stage'), options: stageOptions);
  RenderLoop renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  stage.onKeyDown.listen((ke) => keyMap[ke.keyCode] = true);
  stage.onKeyUp.listen((ke) => keyMap[ke.keyCode] = false);

  var txt1 = new TextField('Move square with W(up), S(down), A(left), D(right)',
      new TextFormat("Arial", 20, Color.Black))
    ..x = 0
    ..y = 545
    ..width = 700;
  stage.addChild(txt1);
  var txt2 = new TextField('Move mouse over the red line to highlight it',
      new TextFormat("Arial", 20, Color.Black))
    ..x = 0
    ..y = 570
    ..width = 700;
  stage.addChild(txt2);

  var spaceship = new Spaceship();
  stage.juggler.add(spaceship);
  stage.addChild(spaceship);
  stage.focus = stage;

  List xData = [100, 200, 300, 400, 500];
  List yData = [100, 300, 200, 100, 500];

  var line = new Line(xData, yData, Color.Red);
  stage.addChild(line);
  line.draw();
}
