

void main() {
  var x = '😀';
  var charCodes = x.codeUnits; // UTF-16 code units
  var codePoints = x.runes.toList(); // Unicode code points
  // var charCodes = x.charCodes; // Unicode code points, same as runes
  print(x); // 😀
  print(codePoints); // [128512]  UTF-16 code units
  print(x.codeUnits); // [55357, 56832]
  print(x.length); // 2
  print(String.fromCharCodes(charCodes)); // 😀


  print('Grinning face: \u{1F600}');
  print('Grinning face: ${String.fromCharCode(0x1F600)}');



}