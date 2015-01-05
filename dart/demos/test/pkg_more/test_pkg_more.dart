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
  var ordering2 = new Ordering.explicit(["Jan", "Feb", "Mar", "Apr"]);
  print(ordering2.sorted(["Feb", "Feb", "Jan", "Apr", "Mar", "Mar"]));
  
  // sort by two variables
  var data = [["BOS", "Jan", 25],
              ["LAX", "Jan", 55],
              ["BOS", "Feb", 28],
              ["LAX", "Feb", 58]];
  var o3 = new Ordering.from(comparator)
  
  
  
  
}