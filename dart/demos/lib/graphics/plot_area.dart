

import 'package:stagexl/stagexl.dart';

import 'scale.dart';

class PlotArea extends Sprite {

  Sprite rect;
  bool isSelected = false;
  List<num> topLeft = [];
  List<num> bottomRight = [];

  Scale myScaleX, myScaleY;


  PlotArea(num width, num height) {
    graphics.rect(0, 0, width, height);
    graphics.strokeColor(Color.Black);
    graphics.fillColor(Color.White);

    rect = new Sprite();
    addChild(rect);

    onMouseDown.listen(_onMouseDown);
    onMouseUp.listen(_onMouseUp);
    onMouseMove.listen(_onMouseMove);
  }



  _onMouseDown(Event e) {
    print('Start selection');
    isSelected = true;
    topLeft = [mouseX, mouseY];
  }
  _onMouseUp(Event e) {
    print('Selection is $topLeft to $bottomRight');
    rect.graphics.clear();
    isSelected = false;
  }
  _onMouseMove(Event e) {
    bottomRight = [mouseX, mouseY];
    rect.graphics.clear();
    if (isSelected) {
      rect.graphics.rect(topLeft[0], topLeft[1],
          bottomRight[0]-topLeft[0], bottomRight[1]-topLeft[1]);
      rect.graphics.strokeColor(Color.Blue);
    }
  }


}