library test_pkg_more;

import 'package:more/iterable.dart';
import 'package:more/ordering.dart';


test_permutations() {
  var x = permutations(['A', 'B', 'C']);
  print(x.length); // 6

  Iterator it = x.iterator;
  print(it.moveNext());
  print(it.current);
}

test_orderings() {
  // Sort with nulls
  var natural = new Ordering.natural();
  var ordering = natural.nullsLast();
  print(ordering.sorted([2, null, 3, 1]));

  // explicit sort
  var byMonthExplicit = new Ordering.explicit(["Jan", "Feb", "Mar", "Apr"]);
  print(byMonthExplicit.sorted(["Feb", "Feb", "Jan", "Apr", "Mar", "Mar"])); // [Jan, Feb, Feb, Mar, Mar, Apr]


  var data = [["BOS", "Jan", 25],
  ["LAX", "Jan", 55],
  ["BOS", "Apr", 54],
  ["BOS", "Feb", 28],
  ["LAX", "Feb", 58]];
  var byCode = natural.onResultOf((obs) => obs[0]);
  print(byCode.sorted(data)); // [[BOS, Jan, 25], [BOS, Apr, 54], [BOS, Feb, 28], [LAX, Jan, 55], [LAX, Feb, 58]]

  // sort by two variables: code & month
  var byMonth = byMonthExplicit.onResultOf((obs) => obs[1]);
  var byCodeMonth = byCode.compound( byMonth );
  print(byCodeMonth.sorted(data)); // [[BOS, Jan, 25], [BOS, Feb, 28], [BOS, Apr, 54], [LAX, Jan, 55], [LAX, Feb, 58]]

  // can sort datetimes too
  var dt = [new DateTime(2014), new DateTime(2010), new DateTime(2011)];
  print(natural.sorted(dt));
  // [2010-01-01 00:00:00.000, 2011-01-01 00:00:00.000, 2014-01-01 00:00:00.000]

  print('sort a List of Maps with nulls');
  var map1 = [
    {'station': 'A', 'value': 10},
    {'station': 'A', 'value': null},
    {'station': 'B', 'value': 15},
    {'station': 'A', 'value': 7},
  ];
  Ordering ord = new Ordering.natural().nullsFirst().onResultOf((Map row) => row['value']);
  print(ord.sorted(map1));
}

main() {

  test_permutations();

  test_orderings();

}