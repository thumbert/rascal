library demos.demo_panels;

import 'dart:convert';
import 'package:stagexl/src/resources.dart';
import 'package:dartice/plots/plot.dart';
import 'dart:html' as html;


simple_panel() {
  var data = [[1, 1, "L"], 
              [2, 2, "L"], 
              [3, 3, "L"], 
              [4, 4, "L"], 
              [1, 1, "Q"], 
              [2, 4, "Q"], 
              [3, 9, "Q"],
              [4,16, "Q"]];
  
  new Plot( html.querySelector('.simplepanel') )
    ..data = data
    ..x = ((e) => e[0])
    ..y = ((e) => e[1])
    ..panel = ((e) => e[2])  
    ..type = ["p"]
    ..height = 300
    ..width = 600
    ..draw();    
  
}

plot_quakes( quakes ) {
  
  new Plot( html.querySelector('.earthquakes') )
    ..data = quakes
    ..x = ((e) => e["long"])
    ..y = ((e) => e["lat"])
    ..panel = ((e) => e["depth"] <= 360 ? "(39.4,360]" : "(360,681]")  
    ..type = ["p"]
    ..markerSize = ((e) => 2)
    ..xlab = "Longitude"
    ..ylab = "Latitude"
    ..height = 300
    ..width = 600
    ..draw();  
}


main() {
  
  //simple_panel();
  
  ResourceManager rm = new ResourceManager()..addTextFile("quakes", "quakes.json");
  rm.load().then((_) {
    List quakes = JSON.decode(rm.getTextFile("quakes"));

    plot_quakes( quakes );
    
  });


}