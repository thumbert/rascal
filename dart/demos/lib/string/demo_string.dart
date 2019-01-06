library demo_string;

import 'dart:convert';

codeUnits() {
  String x = "One, two, three";
  print(x.codeUnits);

  List<int> bytes = utf8.encode(x);
  print(bytes);

  // convert to codeUnits and back
  String jsonData = '{"language":"dart"}';
  var list = jsonData.codeUnits;
  print(new String.fromCharCodes(list));
}

replaceString() {
  String x = 'Bad A\$\$';
  String y = x.replaceAll('\$', '\\\$');
  print(y);
}

main() {
  codeUnits();

  replaceString();
  
}
