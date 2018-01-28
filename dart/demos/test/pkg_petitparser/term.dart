library term;

import 'package:petitparser/petitparser.dart';
import 'package:date/date.dart';

class Term {
  Date start;
  Date end;

  static Set<String> mon = new Set.from([
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ]);

  Term(this.start, this.end);

  Term.parse(String x) {}

  _parseCompound(String x) {}
}

Map _monIdx = {
  'jan': 1,
  'feb': 2,
  'mar': 3,
  'apr': 4,
  'may': 5,
  'jun': 6,
  'jul': 7,
  'aug': 8,
  'sep': 9,
  'oct': 10,
  'nov': 11,
  'dec': 12
};

List _monthNames = [
  'january',
  'february',
  'march',
  'april',
  'may',
  'june',
  'july',
  'august',
  'september',
  'october',
  'november',
  'december',
];

/// Return the month integer or null if it fails
/// to parse a month name.  Parses 'Jan' or 'january'.
int _parseMonth(String x) {
  int res;
  var key = x.toLowerCase().substring(0, 3);
  if (_monIdx.containsKey(key)) {
    res = _monIdx[key];
    /// if you pass the full month name, you have to spell correctly
    if (x.length > 3 && x != _monthNames[res])
      res = null;
  }
  return res;
}

Parser _yyParser = digit().repeat(2, 4);
Parser _mmmParser = letter().repeat(3, 3);
Parser _monthParser = letter('Jan').or(letter('Feb'));

Parser _mmmyyParser = _mmmParser.seq(_yyParser).flatten();

Parser simpleTermParser = letter().plus() & digit().repeat(2, 4);
Parser compositeTermParser = simpleTermParser.seq(char('-')).seq(simpleTermParser);

main() {
  Parser d2 = digit().repeat(2, 2).end(); // two digits
  Result r = d2.parse('15');
  print(r.value);

  Result r2 = p3.parse('January17');
  print(r2.position);
  print(r2.isSuccess);

  List x = [];
}
