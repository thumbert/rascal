library term;

import 'package:parsers/parsers.dart';
import 'package:utilio/datetime.dart';


/*
 * Define a Term as a convenience class to represent common time 
 * periods, for example a year, quarters, a couple of months, a 
 * range of days. 
 * 
 * Allowed formats include: 
 *   - a calendar year: 'Cal 14', 'CAL14', '2014'
 *   - a quarter: 'Q1,2014', 'Q1,14'
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
  
  final Map<String,int> _months = {"jan":1, "feb":2, "mar":3, "apr":4, 
                                   "may":5, "jun":6, "jul":7, "aug":8, 
                                   "sep":9, "oct":10, "nov":11, "dec":12};
  final _mcode = "fghjkmnquvxz";
  
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
  
  simpleTerm() => aYear() | aMonth() ;
  
  aYear() => D4();
  D4() => digit + digit + digit + digit ^ (a,b,c,d) {
    int year = digits2int([a,b,c,d]);
    return new Term(new DateTime(year), new DateTime(year+1));
  };
  D2() => digit + digit ^ (a,b) => digits2int([a,b]);
  
  aMonth() => monYY();
  monYY() => (mon() + D2()) ^ (a,b) {
    int year = b < 50 ? 2000+b : 1900+b;
    int mthIdx = _months[a.toLowerCase()];
    DateTime start = new DateTime(year, mthIdx);
    return new Term(start, nextMonth(asOf: start));
  };
  mon() => string("Jan") | string("Feb") | string("Mar") | string("Apr") |  
      string("May") | string("Jun") | string("Jul") | string("Aug") | 
      string("Sep") | string("Oct") | string("Nov") | 
      string("Dec"); 
  
  Parser<String> lowerString(String x) => string(x.toLowerCase());

  digits2int(digits) => int.parse(digits.join());
  
  
}




