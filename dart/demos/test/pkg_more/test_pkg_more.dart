library test_pkg_more;

import 'package:more/iterable.dart';
import 'package:more/ordering.dart';


main() {
  
  var x = permutations(['A', 'B', 'C']);
  
  print(x.length);

  Iterator it = x.iterator;
  print(it.moveNext());
  print(it.current);
  
  //print(x);
  
  
  // Sort with nulls
  var natural = new Ordering.natural();  
  var ordering = natural.nullsLast();
  print(ordering.sorted([2, null, 3, 1]));

  // explicit sort
  var byMonth = new Ordering.explicit(["Jan", "Feb", "Mar", "Apr"]);
  print(byMonth.sorted(["Feb", "Feb", "Jan", "Apr", "Mar", "Mar"]));
  
  // sort by two variables
  var data = [["BOS", "Jan", 25],
              ["LAX", "Jan", 55],
              ["BOS", "Apr", 54],
              ["BOS", "Feb", 28],
              ["LAX", "Feb", 58]];
  var byCode = natural.onResultOf((obs) => obs[0]);
  print(byCode.sorted(data));
  
  var byCodeMonth = byCode.compound(byMonth.onResultOf((obs) => obs[1]));
  print(byCodeMonth.sorted(data));
  
  // can sort datetimes too
  var dt = [new DateTime(2014), new DateTime(2010), new DateTime(2011)];
  print(natural.sorted(dt));
  
  
  
  
  
  
  
}