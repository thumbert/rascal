library timeline;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

Stage stage = new Stage(html.querySelector('#stage'));

RenderLoop renderLoop = new RenderLoop();


class Stake extends Sprite {
//  num x;
//  num y;
//  num width;
//  num height;

  //Stake(this.x, this.y, this.width, this.height) {
  Stake(int width, int height) {
    graphics.beginPath();
    graphics.rect(0, 0, width, height);
    graphics.closePath();
    graphics.fillColor(Color.Navy);
  }


}

class Timeline extends Sprite {
  num x; // the x coord
  num y; // the y coord
  num width;
  num height;

  Timeline(this.x, this.y, {num width: 500, num height: 50}) {
    graphics.beginPath();
    graphics.rect(x, y, width, height);
    graphics.fillColor(Color.Gray);
  
    
    onMouseOver.listen(_onMouseOver);
    onMouseOut.listen(_onMouseOut);
  }

  _onMouseOver(MouseEvent e) {
    this.graphics.fillColor(Color.Orange);
  }
  _onMouseOut(MouseEvent e) {
    this.graphics.fillColor(Color.Red);
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
  
  Stake stake = new Stake(50, 50);
  stake.x = 100;
  stake.y = 100;
  stake.useHandCursor = true;
  stake.addTo( stage );
  stake.onMouseDown.listen( (me) => stake.startDrag(false)); 
//  stake.onMouseDown.listen( (me) {
//    var xpos = me.currentTarget.x;
//    var ypos = me.currentTarget.y;
//    print("xpos=$xpos, ypos=$ypos, currentTarget.width=${me.currentTarget.width}");
//    stake.startDrag(false, 
//      new Rectangle(125, 50, 100, 0));
//  });
  stake.onMouseUp.listen( (me) => stake.stopDrag());

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




}
