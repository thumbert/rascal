library html_parsing;

import 'dart:io';
import 'package:html/parser.dart';

/// I've pasted the html div with the jpg links into a file.
/// Extract the jpg pictures from the html document
getPictures() {
  Map env = Platform.environment;
  String path = env['HOME'] + '/Downloads/zillow.html';
  File file = new File(path);
  var dom = parseFragment(file.readAsStringSync());
  var ul = dom.children.first;
  List li = ul.getElementsByClassName('hip-photo');
  print(li);

  List links = li.map((e) {
    var attr = e.attributes;
    if (attr.containsKey('src')) return e.attributes['src'];
    else if (attr.containsKey('href')) return e.attributes['href'];
  }).toList();
  links.forEach(print);
}


main() {
  getPictures();
}