library test_markers;

import 'package:chartxl/src/mark.dart';
import 'package:chartxl/src/grid.dart';

import 'test_all.dart';
import 'package:stagexl/stagexl.dart' as stagexl;


test_markers() {
  Grid grid = new Grid(new List.generate(stage.stageWidth ~/ 100, (i) => i * 100), new List.generate(stage.stageHeight ~/ 100, (i) => i * 100), stage.stageWidth, stage.stageHeight);
  stage.addChild(grid);
  
  var c1 = new Circle(radius: 10)
    ..x = 100
    ..y = 100;
  stage.addChild(c1);
  
  
  var c2 = new Circle(radius: 10, fillColor: stagexl.Color.Aquamarine)
  ..x = 100
  ..y = 200;
  stage.addChild(c2);
  
  var c3 = new Circle(radius: 10, fillColor: stagexl.Color.Aquamarine, alpha: 0.25)
  ..x = 100
  ..y = 300;
  stage.addChild(c3);
  
  var c4 = new Circle(radius: 10, fillColor: stagexl.Color.Aquamarine, 
      alpha: 1, color: stagexl.Color.Black, strokeWidth: 3)
  ..x = 100
  ..y = 400;
  stage.addChild(c4);
  
  
}