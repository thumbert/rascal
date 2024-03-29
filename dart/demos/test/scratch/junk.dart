library scratch.junk;

import 'package:intl/intl.dart';

tests() {
  num x = 7*0.8;
  print(x.round());

  print(double.nan > 1.0);  // false
  print(double.nan < 1.0);  // false

  final _initialHeroes = [
    {'id': 11, 'name': 'Mr. Nice'},
    {'id': 12, 'name': 'Narco'},
    {'id': 13, 'name': 'Bombasto'},
    {'id': 14, 'name': 'Celeritas'},
    {'id': 15, 'name': 'Magneta'},
    {'id': 16, 'name': 'RubberMan'},
    {'id': 17, 'name': 'Dynama2'},
    {'id': 18, 'name': 'Dr IQ'},
    {'id': 19, 'name': 'Magma'},
    {'id': 20, 'name': 'Tornado'}
  ];

  var hero = _initialHeroes.firstWhere((h) => h['id']==18);
  hero['name'] = 'Plasma';
  print(_initialHeroes);
}

main() {
//  var m = Month.parse('202005', fmt: DateFormat('yyyyMM'));
  var fmt =
      NumberFormat.simpleCurrency(decimalDigits: 0, name: '');
  print(fmt.format(123456.23));
  print(fmt.format(-123456.23));

}