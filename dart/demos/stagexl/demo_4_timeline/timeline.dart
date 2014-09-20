library timeline;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

Stage stage = new Stage(html.querySelector('#stage'));

RenderLoop renderLoop = new RenderLoop();


class Stake extends Sprite {
  Stake(int width, int height) {
    graphics.beginPath();
    graphics.rect(0, 0, width, height);
    graphics.closePath();
    graphics.fillColor(Color.Navy);
  }
}



class Timeline extends DisplayObjectContainer {

  Shape bar;
  Stake handleLeft;
  Stake handleRight;
    
  Timeline({int width: 500, int height: 20}) {
    
    bar = new Shape()
      ..graphics.beginPath()
      ..graphics.rect(0, 20, width, height)
      ..graphics.fillColor(Color.Gray);
    
    handleLeft = new Stake(20, 60)
      ..x = 50
      ..y = 0
      ..useHandCursor = true;
    
    handleLeft.onMouseDown.listen( (me) => handleLeft.startDrag(true, new Rectangle(0, 30, width, 0))); 
    handleLeft.onMouseUp.listen( (me) => handleLeft.stopDrag());;
    handleLeft.addTo( stage );  
    
    addChild(bar);
    addChild(handleLeft);
    
  }


  
}


addGrid() {
  var grid = new Shape();
  
  num h = 0;
  while( h < stage.stageHeight) {
    grid.graphics.moveTo(0, h);
    grid.graphics.lineTo(stage.stageWidth, h);
    h += 100;
  }
  num v = 0;
  while( v < stage.stageWidth) {
    grid.graphics.moveTo(v, 0);
    grid.graphics.lineTo(v,stage.stageHeight);
    v += 100;
  }
  grid.graphics.strokeColor(Color.Gray, 1);
  
  stage.addChild( grid );
}

main() {
  //stage.scaleMode = StageScaleMode.NO_SCALE;
  //stage.align = StageAlign.TOP_LEFT;
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);

  stage.backgroundColor = Color.Beige;

  addGrid();

  var tline = new Timeline()
    ..x = 100
    ..y = 200;
   
  
  stage.addChild( tline );
  
  
//  Stake stake = new Stake(50, 50);
//  stake.x = 100;
//  stake.y = 100;
//  stake.useHandCursor = true;
//  stake.addTo( stage );
//  stake.onMouseDown.listen( (me) => stake.startDrag(true, new Rectangle(125, 125, 100, 0))); 
//  stake.onMouseUp.listen( (me) => stake.stopDrag());
}




//  var sprite = new Sprite();
//  sprite.graphics.beginPath();
//  sprite.graphics.circle(0, 0, 50);
//  sprite.graphics.closePath();
//  sprite.graphics.fillColor(Color.Magenta);
//  sprite.x = 100;
//  sprite.y = 100;
//  sprite.useHandCursor = true;
//  sprite.addTo(stage);
//
//  bool lockCenter = false;
//  sprite.onMouseDown.listen((me) => sprite.startDrag(lockCenter));
//  sprite.onMouseUp.listen((me) => sprite.stopDrag());



