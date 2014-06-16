library test_custom_iterator;

import 'package:demos/collection/custom_iterator.dart';


main() {
  DateTime dt1 = new DateTime(2014,1,1);
  DateTime dt2 = new DateTime(2014,1,2);

  Obs o1 = new Obs(dt1, 1);
  Obs o2 = new Obs(dt2, "A");
  
  TimeSeries ts = new TimeSeries([o1, o2]);
  print(ts.length);

  
  
  
}