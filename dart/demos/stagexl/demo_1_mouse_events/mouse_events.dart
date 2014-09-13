import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

class Marker extends Sprite {  
  num x;
  num y;
  //Shape shape;
  
  Marker(this.x, this.y) {
    this.graphics.circle(x, y, 10);
    this.graphics.fillColor(Color.Red);
    this.onMouseOver.listen( _onMouseOver );
    this.onMouseOut.listen( _onMouseOut );
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
  var stage = new Stage(canvas, width: 600, height: 600);
  //stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.TOP_LEFT;
  
  var renderLoop = new RenderLoop();
  var juggler = renderLoop.juggler;
  renderLoop.addStage(stage);
  
  print("stage width = ${stage.width}, height=${stage.height}");
  print("contentRectange = ${stage.contentRectangle}");
  stage.addChild(new Bitmap(
    new BitmapData(stage.contentRectangle.width.toInt(), stage.contentRectangle.height.toInt(), false, Color.Beige)));
  
  // you need to be a Sprite and NOT a Shape if you want to respond to MouseEvents
  Marker mark = new Marker(50, 50);
  stage.addChild(mark); 
       
  var shape2 = new Shape();
  shape2.graphics.circle(100, 100, 60);
  shape2.graphics.fillColor(Color.Violet);
  stage.addChild(shape2);

  // simple animation
  var tween = new Tween(shape2, 2.0, TransitionFunction.linear);
  tween.animate.x.to(100);
  tween.animate.y.to(100);
  juggler.add(tween);
  
  var txt = new TextField();
  txt.x = 100;
  txt.y = stage.contentRectangle.height-50;
  stage.addChild(txt);
  
  stage.addChild( new TextField()
    ..x = 100
    ..y = stage.contentRectangle.height-75
    ..width = 700
    ..text = "Move the mouse over the red circle to see its color change!"
    );
  
  _onEnterFrame( EnterFrameEvent e) {
    txt.text = "(x=${stage.mouseX}, y=${stage.mouseY})";
  }  
  stage.onEnterFrame.listen( _onEnterFrame );
  
}


