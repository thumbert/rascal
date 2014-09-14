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

class Timeline extends Sprite {

  Stake stakeLeft;
  Stake stakeRight;
  
  Timeline({int width: 500, int height: 20}) {
    graphics.beginPath();
    graphics.rect(0, 20, width, height);
    graphics.fillColor(Color.Gray);
    
    stakeLeft = new Stake(20, 60)
      ..x = 100
      ..y = 30
      ..useHandCursor = true;
    
    stakeLeft.onMouseDown.listen( (me) => stakeLeft.startDrag(true, new Rectangle(70, 0, 100, 0))); 
    stakeLeft.onMouseUp.listen( (me) => stakeLeft.stopDrag());;
    stakeLeft.addTo( stage );  
    
    
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

  stage.addChild( new Timeline() );
  
  
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



