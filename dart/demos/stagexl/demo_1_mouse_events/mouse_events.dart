import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

class Marker extends Sprite {  
  num x;
  num y;
  Shape shape;
  
  Marker(this.x, this.y) {
    this.graphics.circle(x, y, 60);
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
  var stage = new Stage(canvas);
  var renderLoop = new RenderLoop();
  var juggler = renderLoop.juggler;
  renderLoop.addStage(stage);
  
  // you need to be a Sprite and NOT a Shape if you want to respond to MouseEvents
  Marker mark = new Marker(100, 100);
  stage.addChild(mark); 
       
  var shape2 = new Shape();
  shape2.graphics.circle(200, 200, 60);
  shape2.graphics.fillColor(Color.Violet);
  stage.addChild(shape2);

  // simple animation
  var tween = new Tween(shape2, 2.0, TransitionFunction.linear);
  tween.animate.x.to(100);
  tween.animate.y.to(100);
  juggler.add(tween);
  
  var txt = new TextField();
  txt.x = 100;
  txt.y = 500;
  stage.addChild(txt);
  
  stage.addChild( new TextField()
    ..x = 100
    ..y = 400
    ..width = 700
    ..text = "Move the mouse over the red circle to see its color change!"
    );
  
  _onEnterFrame( EnterFrameEvent e) {
    txt.text = "(x=${stage.mouseX}, y=${stage.mouseY})";
  }  
  stage.onEnterFrame.listen( _onEnterFrame );
  
}


