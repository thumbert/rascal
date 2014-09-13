library timeline;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

class Stake extends Sprite {
  num x;
  num y;
  num width;
  num height;
  
  bool isSelected;
    
  Stake(this.x, this.y, this.width, this.height) {
    graphics.rect(x, y, width, height);
    graphics.fillColor(Color.Navy);  
    
    onMouseOver.listen( _onMouseOver );
    onMouseDown.listen( _onMouseDown );
    onMouseOut.listen( _onMouseOut );
  } 
  
  _onMouseDown( MouseEvent e) {
    if (isSelected) {
      
      x = stage.mouseX;
      y = stage.mouseY;
      print("selected! x=${stage.mouseX}");
    }
  }
  _onMouseOut( MouseEvent e) {
    isSelected = false;
  }  
  _onMouseOver( MouseEvent e) {
    isSelected = true;
  }
   
}

class Timeline extends Sprite {
  num x;     // the x coord
  num y;     // the y coord
  num width;
  num height;
  
  Timeline(this.x, this.y, {num width:500, num height:50}) {
    graphics.rect(x, y, width, height);
    graphics.fillColor(Color.Gray);
    
    onMouseOver.listen( _onMouseOver );
    onMouseOut.listen( _onMouseOut );
  }
  
  _onMouseOver( MouseEvent e) {
     this.graphics.fillColor(Color.Orange);    
   }
   _onMouseOut( MouseEvent e) {
     this.graphics.fillColor(Color.Red);        
   }
  
}


main() {
  var canvas = html.querySelector('#stage');
  var stage = new Stage(canvas, width: 800, height: 600);
  stage.scaleMode = StageScaleMode.NO_SCALE;
  stage.align = StageAlign.TOP_LEFT;
  var renderLoop = new RenderLoop();
  renderLoop.addStage(stage);
  
  stage.addChild(new Bitmap(
     new BitmapData(stage.contentRectangle.width.toInt(), stage.contentRectangle.height.toInt(), false, Color.Beige)));

  Stake stake = new Stake(100, 100, 50, 50);
  stage.addChild( stake );
  
  
  
  
  
}