import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

class Marker extends Sprite {  
  num x;
  num y;

  Marker(this.x, this.y) {
    this.graphics.circle(x, y, 10);
    this.graphics.fillColor(Color.Red);
    this.onMouseOver.listen( _onMouseOver );
    this.onMouseOut.listen( _onMouseOut );
  }
    
  _onMouseOver( MouseEvent e) {
    print('changing color!');
    this.graphics.fillColor(Color.Orange);    
  }
  _onMouseOut( MouseEvent e) {
    this.graphics.fillColor(Color.Red);        
  }
  
}

main() {
  StageOptions stageOptions = new StageOptions()
    ..inputEventMode = InputEventMode.MouseAndTouch
    ..backgroundColor = Color.Beige
    ..antialias = true
    ..renderEngine = RenderEngine.Canvas2D;
  Stage stage = new Stage(html.querySelector('#stage'), options: stageOptions);
  //stage.scaleMode = StageScaleMode.SHOW_ALL;
  stage.align = StageAlign.TOP_LEFT;
  
  var renderLoop = new RenderLoop();
  var juggler = renderLoop.juggler;
  renderLoop.addStage(stage);
  
  print("stage width = ${stage.width}, height=${stage.height}");
  print("contentRectange = ${stage.contentRectangle}");

  // you need to be a Sprite and NOT a Shape if you want to respond to MouseEvents
  Marker mark = new Marker(50, 50);
  stage.addChild(mark); 
       
  var shape2 = new Shape();
  shape2.graphics.circle(100, 100, 60);
  shape2.graphics.fillColor(Color.Violet);
  stage.addChild(shape2);

  var shape3 = new Shape();
  shape3.graphics.moveTo(10, 10);
  shape3.graphics.lineTo(400, 400);
  shape3.graphics.strokeColor(Color.Tomato);
  stage.addChild(shape3);
  
  ///simple animation
  var tween = new Tween(shape2, 2.0, Transition.linear);
  tween.animate.x.to(100);
  tween.animate.y.to(100);
  juggler.add(tween);
  
  var rect = new Shape()
    ..graphics.rect(300, 50, 300, 200)
    ..graphics.strokeColor(Color.Blue, 1, JointStyle.MITER);
  stage.addChild(rect);
  
  var txt = new TextField();
  txt.x = 100;
  txt.y = stage.contentRectangle.height-50;
  stage.addChild(txt);
  
  stage.addChild(
      new TextField('Move the mouse over the red circle to see its color change to orange',
          new TextFormat("Arial", 20, Color.Black))
    ..x = 100
    ..y = stage.contentRectangle.height-75
    ..width = 700);
  stage.addChild(
      new TextField('Move the mouse over the green line to see it highlighted',
          new TextFormat("Arial", 20, Color.Black))
        ..x = 100
        ..y = stage.contentRectangle.height-25
        ..width = 700);

  _onEnterFrame( Event e) {
    txt.text = "(x=${stage.mouseX}, y=${stage.mouseY})";
  }  
  stage.onEnterFrame.listen( _onEnterFrame );

  var sprite = new Sprite();
  sprite.graphics.moveTo(350, 25);
  sprite.graphics.lineTo(350, 500);
  sprite.graphics.strokeColor(Color.GreenYellow, 2);

  sprite.onMouseOver.listen((MouseEvent e) {
    print('over');  /// don't seem to ever get here!
    sprite.graphics.clear();
    sprite.graphics.moveTo(350, 25);
    sprite.graphics.lineTo(350, 500);
    sprite.graphics.strokeColor(Color.Green, 10);
  });

  sprite.onMouseOut.listen((MouseEvent e){
    print('out');
    sprite.graphics.clear();
    sprite.graphics.moveTo(350, 25);
    sprite.graphics.lineTo(350, 500);
    sprite.graphics.strokeColor(Color.GreenYellow, 2);
  });
  stage.addChild(sprite);

}


