library chart;


import 'package:chartxl/src/theme.dart';
import 'package:stagexl/stagexl.dart';
import 'package:chartxl/src/axis.dart';
import 'package:chartxl/src/mark.dart' as mark;
import 'package:chartxl/src/interpolator.dart';
import 'package:chartxl/src/grid.dart';
import 'package:chartxl/src/mark.dart';


class PlotArea extends DisplayObjectContainer {
  
  Chart _chart;
  Function _interpolatorX;
  Function _interpolatorY;
  
  
  PlotArea(num width, num height, Chart this._chart) {
    Shape background = new Shape()
      ..width = width
      ..height = height
      ..graphics.rect(0, 0, width, height)    
      ..graphics.strokeColor(Color.Black, 1.5, JointStyle.MITER)
      ..graphics.fillColor(Color.White);
    addChild(background);   
    
    _interpolatorX = new NumericalInterpolator.fromPoints(0, 7.5, 0, width); 
    _interpolatorY = new NumericalInterpolator.fromPoints(0, 2.6, height, 0); 
        
    var v = new List.generate(width ~/ 100,  (i) => (i+1) * 100);
    var h = new List.generate(height ~/ 100, (i) => (i+1) * 100);
    
    Grid grid = new Grid( v, h, width, height);
    addChild(grid);
    
    
    
    _addMarkers();
   
  } 
  
  _addMarkers() {
    
    var colors = [Color.Blue, Color.Red, Color.Green];
    
    if (_chart._uGroups != null) {
      _chart.marker = (e) => new mark.Circle(color: colors[_chart._uGroups[_chart.groups(e)]]);
    }
    
     
    _chart.data.forEach((e) {
      var m = _chart.marker(e)
        ..x = _interpolatorX( _chart.xData(e) ) 
        ..y = _interpolatorY( _chart.yData(e) );
      addChild( m );
    });
  } 
  
}


class Chart extends DisplayObjectContainer {

  num height;
  num width;
  List<Map> data;
  Function xData;
  Function yData;
  
  List<Axis> axes; 
  Function groups;         // from (e) => String
  Function marker = (e) => new mark.Circle();         
  Function markerColor = (e) => Color.Blue;
  
  Map<String, int> _uGroups;   // unique group names
  //Function _groupIndex;        // from groupName to groupIndex 
  List<String> type;
  
  
  
  //num get height => stage.height;
  //num get width  => stage.width;
  
  
  num get plotAreaX => theme.marginLeft * theme.textSize;
  num get plotAreaY => theme.marginTop * theme.textSize;
  num get plotAreaWidth => width  - (theme.marginBottom + theme.marginTop)*theme.textSize;
  num get plotAreaHeight => height - (theme.marginRight + theme.marginLeft)*theme.textSize;
  
  
  PlotArea plotArea;
  
  Function _interpolatorX;  // move from plot coordinate to stage coordinate
  Function _interpolatorY;
  
  
  /**
   * Each element of data contains a Map with keys: "x", "y", "group", "panel".  
   * If "x" is missing, it's assumed to be 1:length(y). 
   */
  Chart(num this.width, num this.height) {
    if (theme == null) theme = new DefaultTheme();     
    
  }

  
  
  void draw() {
    
    if (type == null) {
      type = ["p"];
    }
    
    print("width=${width}, heigth=${height}");
    print("plotAreaWidth = ${plotAreaWidth}, plotAreaHeight = ${plotAreaHeight}, plotAreaX =${plotAreaX}");
    
    
    
    if ( groups != null) {
      var aux = data.map( groups ).toSet(); 
      print( groups(data.first) );
      _uGroups = new Map.fromIterables(aux, new List.generate(aux.length, (i) => i));
      print(_uGroups);
    }
        
    var plotArea = new PlotArea(plotAreaWidth, plotAreaHeight, this)
      ..x = plotAreaX
      ..y = plotAreaY;
    
    
    
    addChild(plotArea);
    
  }
  

  
  
  bool hasX() {
    if (data.first.keys.contains("x")) return true; else return false;
  }
  bool hasY() {
    if (data.first.keys.contains("y")) return true; else return false;
  }

  _addAxes() {
    Map obs = data.first;
    if (obs.keys.contains("x")) {
      Axis xAxis = new Axis();      
    }

  }
  
  
  
}
