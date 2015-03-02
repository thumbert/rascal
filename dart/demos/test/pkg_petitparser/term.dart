library term;

import 'package:petitparser/petitparser.dart';

/**
 * A period of contiguous days, say a month: "Jan15", a year "Cal15", a quarter "Q2,2015"
 */
class Term {

  Set<String> Mon = new Set.from(['Jan', 'Feb', 'Mar',  'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']);

}

main() {

  Parser d2 = digit().repeat(2,2).end();    // two digits
  Result r = d2.parse('15');
  print(r.value);


}