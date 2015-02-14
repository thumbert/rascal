library container;

import 'dart:html' as html;
import 'package:stagexl/stagexl.dart';

Stage stage = new Stage(html.querySelector('#stage'));
RenderLoop renderLoop = new RenderLoop();

class PlotArea extends DisplayObjectContainer {
   
  PlotArea(int width, int height) {
    print("Plot area width={$width} and heigth={$height}");
    Shape background = new Shape()
       ..width = width
       ..height = height
       ..graphics.rect(0, 0, width, height)    
       ..graphics.strokeColor(Color.Black, 1.5, JointStyle.MITER)
       ..graphics.fillColor(Color.White);
     addChild(background);   
  }
  
}

class Line extends Sprite {
  List<num> xData;
  List<num> yData;
  int color;
  String seriesName;
  TextField textField;
  
  Line(this.xData, this.yData, {this.color: Color.Tomato, this.seriesName}) {
    draw();
    graphics.strokeColor(color, width=1.5);    
    textField = new TextField( seriesName )
      ..x=250
      ..y=50
      ..alpha = 0;
    //addChild(textField);
    
    onMouseOver.listen( _onMouseOver );
    onMouseOut.listen( _onMouseOut );
  }
  
  draw() {
    graphics.moveTo(xData.first, yData.first);
    for (int i=1; i<xData.length; i++) {
      graphics.lineTo(xData[i], yData[i]);      
    }
  }
  
  _onMouseOver( MouseEvent e) {
    textField.alpha = 1;
    graphics.clear();
    draw();
    graphics.strokeColor(color, width=5);    
  }
  _onMouseOut( MouseEvent e) {
    graphics.clear();
    draw();
    graphics.strokeColor(color, width=1.5);
  }  
  
}

void main() {
  //stage has width=800, height=500 
  renderLoop.addStage(stage);
  stage.backgroundColor = Color.AliceBlue;

  List xData = new List.generate(7, (i) => 50 + 100*i);
  List y1Data = [50, 150, 300, 375, 325, 275, 315];
  List y2Data = [100, 250, 250, 305, 225, 255, 325];
  
  var area = new PlotArea(700, 400)
    ..x = 50
    ..y = 50
    ..addTo(stage);
  
  area.addChild( new Line(xData, y1Data, color: Color.Tomato, seriesName:"Series 1") );
  area.addChild( new Line(xData, y2Data, color: Color.BlueViolet, seriesName:"Series 2") );
  
   
}


