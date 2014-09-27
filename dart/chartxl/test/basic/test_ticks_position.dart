library ticks_position;

import 'dart:html' as html;
import 'dart:math';

import 'package:stagexl/stagexl.dart';
import 'package:chartxl/src/util.dart';
import 'package:chartxl/src/tick.dart';

html.CanvasElement canvas = html.querySelector('#stage');
Stage stage = new Stage(canvas);

RenderLoop renderLoop = new RenderLoop();

addGrid() {
  var grid = new Shape();

  num h = 0;
  while (h < stage.stageHeight) {
    grid.graphics.moveTo(0, h);
    grid.graphics.lineTo(stage.stageWidth, h);
    h += 100;
  }
  num v = 0;
  while (v < stage.stageWidth) {
    grid.graphics.moveTo(v, 0);
    grid.graphics.lineTo(v, stage.stageHeight);
    v += 100;
  }
  grid.graphics.strokeColor(Color.Bisque, 1);

  stage.addChild(grid);
}


main() {
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  stage.backgroundColor = Color.Beige;
  addGrid();

  var tickDown = new Tick("A really superlong Text", 20, 10, Direction.DOWN)
      ..x = 100
      ..y = 100;
  stage.addChild(tickDown);

  var tickUp = new Tick("A text for an UP Tick", 20, 10, Direction.UP)
      ..x = 100
      ..y = 400;
  stage.addChild(tickUp);

  var tickLeft = new Tick("Another long text label", 20, 10, Direction.LEFT)
      ..x = 300
      ..y = 100;
  stage.addChild(tickLeft);

  var tickRight = new Tick("A text for a RIGHT tick", 20, 10, Direction.RIGHT)
      ..x = 300
      ..y = 400;
  stage.addChild(tickRight);

  
  var dataURL = canvas.toDataUrl();
  print(dataURL);

}
