library keyevents;


import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

var keyMap = new Map<int, bool>();

main() {
  Stage stage = new Stage(html.querySelector('#stage'), webGL:false);
  RenderLoop renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  stage.focus = stage;
  stage.onKeyDown.listen((ke) => keyMap[ke.keyCode] = true);
  stage.onKeyUp.listen((ke) => keyMap[ke.keyCode] = false);

  var spaceship = new Spaceship();
  stage.juggler.add(spaceship);
  stage.addChild(spaceship);
}

class Spaceship extends DisplayObjectContainer implements Animatable {
  
  Spaceship() {
    var bitmap = new Bitmap(new BitmapData(64, 64, true, Color.Magenta));
    addChild(bitmap);
  }

  bool advanceTime(num deltaTime) {
    if (keyMap[87] == true) this.y -= deltaTime * 100;  // W
    if (keyMap[83] == true) this.y += deltaTime * 100;  // S
    if (keyMap[65] == true) this.x -= deltaTime * 100;  // A
    if (keyMap[68] == true) this.x += deltaTime * 100;  // D
    return true;
  }
}