library demo.string;

dateParse() {
  var year = new RegExp(r'\d{4}');
  print('2014'.contains(year));  // true

  RegExp MONYY = new RegExp(r'^[A-Z]{3}\d{2}$');
  print('JAN12'.contains(MONYY));  // true
  print('JANN12'.contains(MONYY)); // false

  var chars = 'Jan12'.split('');  // [J, a, n, 1, 2]
  chars.forEach(print);

  final RANGE = new RegExp(r'(.*)-(.*)');
  print('Jan12 - Feb13'.replaceAll(" ", ""));  // Jan12-Feb13
}

/// filter lines by content
tminOrTmax() {
  var x = [
    'wban,10,SNOW,,,10',
    'wban,10,TMAX,,,10',
    'wban,10,TMIN,,,10',
    'wban,10,PREP,,,10',
  ];
  RegExp reg = new RegExp(r'TMAX|TMIN');

  return x.where((String line) => line.contains(reg));
}