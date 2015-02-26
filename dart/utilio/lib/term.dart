library term;

import 'package:utilio/datetime.dart';
import 'package:parsers/parsers.dart';



final Map<String,int> _months = {"jan":1, "feb":2, "mar":3, "apr":4,
    "may":5, "jun":6, "jul":7, "aug":8,
    "sep":9, "oct":10, "nov":11, "dec":12};
final _mcode = "fghjkmnquvxz";

/**
 * Define a Term as a convenience class to represent common time
 * periods, for example a year, quarters, a couple of months, a
 * range of days.
 *
 * Allowed formats include:
 *   - a calendar year: 'Cal 14', 'CAL14', '2014'
 *   - a quarter: 'Q1,2014', 'Q1,14', 'Q1, 2014'
 *   - a month: Jan14, F14,
 */
class Term {
  DateTime start;
  DateTime end;

  Term(this.start, this.end);

  bool operator==(Term other) {
    return start == other.start && end == other.end;
  }

  toString() => start.toString() + " to " + end.toString();
}



class TermParser {

  // Some combinators: functions that take parsers and return a parser.
  //lexeme(parser) => parser < spaces;
  token(str)     => string(str);
  range(parser)  => parser + token('-') + parser  ^ (a,b,c) {
    print("Here!");  
    return [a, c];
  };

  // The axiom of the grammar is an expression followed by end of file.
  get start => expr() < eof;
  expr() => range(rec(simpleTerm)) | simpleTerm();
  
  simpleTerm() => aYear() | aQuarter() | aMonth() ;
  
  // parsing years:  
  aYear() => Cal() | D4();
  D4() => digit + digit + digit + digit ^ (a,b,c,d) {
    return digits2int([a,b,c,d]);
  };
  D2() => digit + digit ^ (a,b) {
    int yy = digits2int([a,b]);
    return yy < 50 ? 2000+yy : 1900+yy;
  };
  D4orD2() => D4() | D2();  
  Cal() => string("Cal") + char(' ').orElse('') + D4orD2() ^ (a,b,c) {
    return new Term(new DateTime(c), new DateTime(c));
  };
  
  // parsing quarters: 'Q1,12', 'Q1, 12', 'Q1, 2012'
  final _quarters = "1234";
  aQuarter() => char("Q") + oneOf(_quarters) + char(",") + char(' ').orElse('') + D4orD2() ^ (a,b,c,d,e) {
    int quarter = int.parse(b);
    return new Term(new DateTime(e, (quarter-1)*3+1), new DateTime(e, quarter*3));
  };
  
  // parsing months
  aMonth() => monYY();
  monYY() => (mon() + D2()) ^ (a,b) {
    int mthIdx = _months[a.toLowerCase()];
    DateTime start = new DateTime(b, mthIdx);
    return new Term(start, nextMonth(asOf: start));
  };
  mon() => string("Jan") | string("Feb") | string("Mar") | string("Apr") |  
      string("May") | string("Jun") | string("Jul") | string("Aug") | 
      string("Sep") | string("Oct") | string("Nov") | 
      string("Dec"); 
 
  digits2int(digits) => int.parse(digits.join());
  
  
}



