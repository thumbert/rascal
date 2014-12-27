library demos.demo_panels;

import 'dart:convert';
import 'package:stagexl/src/resources.dart';
import 'package:dartice/plots/plot.dart';
import 'dart:html' as html;



plot_quakes( quakes ) {
  
  new Plot( html.querySelector('.earthquakes') )
    ..data = quakes
    ..x = ((e) => e["lat"])
    ..y = ((e) => e["long"])
    ..panel = ((e) => e["depth"] <= 360 ? "(39.4,360]" : "(360,681]")  
    ..type = ["p"]
    ..xlab = "Latitude"
    ..ylab = "Longitude"
    ..height = 300
    ..width = 600
    ..draw();  
}


main() {
  ResourceManager rm = new ResourceManager()..addTextFile("quakes", "quakes.json");

  rm.load().then((_) {
    List quakes = JSON.decode(rm.getTextFile("quakes"));

    plot_quakes( quakes );
    
  });


}