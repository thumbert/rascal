

main() {
  var x = <int>[36, 9, 1, 11, 42, 10, 6, 7,-1,-1, 0,0, 911];

  var min = x[0];
  var max= x[0];

  for (var i = 1; i<x.length; i++ ){
    if (x[i] < min)
      min= x[i];
    if (x[i]> max)
      max= x[i];

  }

  print (min);
  print (max);

  if (max == 911) print('okey dokey');



}