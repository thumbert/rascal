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
    
  _onEnterFrame( EnterFrameEvent e) {
    txt.text = "(x=${stage.mouseX}, y=${stage.mouseY})";
  }  
  stage.onEnterFrame.listen( _onEnterFrame );
  
}



//  int N = 10000;
//  var rand = new Random();
//  for (int i = 0; i < N; i++) {
//    stage.addChild( 
//       new Shape()
//          ..graphics.circle(800*rand.nextDouble(), 600*rand.nextDouble(), 3)
//          ..graphics.strokeColor(Color.Olive)
//     );
//  }

  
  
   

  // draw a red circle
//  Shape shape = new Shape();
//  shape.graphics.circle(100, 100, 60);
//  shape.graphics.fillColor(Color.Red);
//  stage.addChild(shape);
//
//  var shape2 = new Shape();
//  shape2.graphics.circle(200, 200, 60);
//  shape2.graphics.strokeColor(Color.Orange, 3);
//  stage.addChild(shape2);
  

