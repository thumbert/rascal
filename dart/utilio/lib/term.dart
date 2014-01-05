library term;

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
  String frequency;   // should be an enumeration

  static final YEAR  = new RegExp(r'^\d{4}$');
  static final CAL   = new RegExp(r'^CAL\s+\d{2,4}$');  //'CAL 2015', 'CAL15' 
  static final RANGE = new RegExp(r'(.*)-(.*)');        // a range
  
  // one simple term first
  parseSimple(String term) {
    
  }
  
  Term.parse(String term) {
    String x = term.toUpperCase();
    bool isRange = x.contains("-");
    
    if ( isRange ) {
      List<String> xp = x.split("-");
      assert(xp.length == 2);
      Term x1 = parseSimple( xp[0] );
      Term x2 = parseSimple( xp[1] );

    } 
    
  }
  
}


// A fast way to do it ... 
//codeUnit = x[i].codeUnitAt(0); 
//if (codeUnit >= 48 || codeUnit <= 57) {
//  // it's a digit!
//}

