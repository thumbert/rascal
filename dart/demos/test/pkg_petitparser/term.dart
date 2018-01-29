library term;

import 'package:petitparser/petitparser.dart';
import 'package:date/date.dart';

Set<String> mon = new Set.from([
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

Map _monthIdx = {
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

class Term {
  Date start;
  Date end;

  Term(this.start, this.end) {
    if (end.isBefore(start))
      throw new ArgumentError('End date can\'t be before start date.');
  }

  Term.parse(String x) {}
}

class TermGrammar extends GrammarParser {
  TermGrammar() : super(const TermGrammarDefinition());
}
class TermGrammarDefinition extends GrammarDefinition {
  const TermGrammarDefinition();

  start() => ref(value).end();
  token(Parser p) => p.flatten().trim();
  simpleDayToken() => ref(dayToken) & ref(monthToken) & ref(yearToken);
  simpleMonthToken() => ref(monthToken) & ref(yearToken);
  simpleToken() => ref(simpleMonthToken) | ref(simpleDayToken);

  compoundDayToken() =>
      ref(simpleDayToken) & ref(token, char('-')) & ref(simpleDayToken);
  compoundMonthToken() =>
      ref(simpleMonthToken) & ref(token, char('-')) & ref(simpleMonthToken);
  compoundToken() => compoundMonthToken() | compoundDayToken();
  value() => ref(simpleToken) | ref(compoundToken);

  dayToken() => token(digit().repeat(1, 2));
  monthToken() => token(letter().repeat(3, 3));
  yearToken() => token(digit().repeat(2, 4));
}

class TermParser extends GrammarParser {
  /// The parser will fail with hard to understand message if input is not
  /// correct.
  TermParser() : super(const TermParserDefinition());
}

/// the parser definition
class TermParserDefinition extends TermGrammarDefinition {
  const TermParserDefinition();

  simpleMonthToken() => super.simpleMonthToken().map((List<String> each) {
        print(each);
        Month month = new Month(_yyToYear(each[1]), _monthIdx[each[0].toLowerCase()]);
        return new Term(month.startDate, month.endDate);
      });
  simpleDayToken() => super.simpleDayToken().map((List<String> each) {
    print(each);
    Date day = new Date(_yyToYear(each[2]), _monthIdx[each[1].toLowerCase()], int.parse(each[0]));
    return new Term(day, day);
  });
}

/// Convert a two digit string to a year value.
int _yyToYear(String yy) {
  int value = int.parse(yy);
  if (value > 50) return 1900 + value;
  else return 2000 + value;
}


main() {
//  Parser d2 = digit().repeat(2, 2).end(); // two digits
//  Result r = d2.parse('15');
//  print(r.value);

  var parser = new TermParser();
  var jan17 = parser.parse('jan 17');
  print(jan17.value);

  var d1jan17 = parser.parse('1 jan 17');
  print(d1jan17.value);

  //parser.parse('jav 17');  // blows-up

}
