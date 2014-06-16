


main() {
  var year = new RegExp(r'\d{4}');
  print('2014'.contains(year));
  
  RegExp MONYY = new RegExp(r'^[A-Z]{3}\d{2}$');
  print('JAN12'.contains(MONYY));
  print('JANN12'.contains(MONYY));
  
  var chars = 'Jan12'.split('');
  chars.forEach((e) => print(e));
  
  final RANGE = new RegExp(r'(.*)-(.*)');       
  
  
  
  print('Jan12 - Feb13'.replaceAll(" ", ""));
  
  //print(int.parse('A'));
  
  print('9'.codeUnitAt(0));
  
  print("Done");
}
