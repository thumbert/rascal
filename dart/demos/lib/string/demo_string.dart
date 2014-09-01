library demo_string;

import 'dart:convert';

main() {
  
  
  String x = "One, two, three";
  print(x.codeUnits);
  
  List<int> bytes = UTF8.encode(x);
  print(bytes);
  
  // convert to codeUnits and back
  String jsonData = '{"language":"dart"}';
  var list = jsonData.codeUnits;
  print(new String.fromCharCodes(list));
  
  
}
