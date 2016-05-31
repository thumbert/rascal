///calculating powers of a number

import 'dart:math';

main() {
  int n = 12;

  for ( var i = 1; i < 100 ; i++) {
    int res = pow(n, i);
    print ("i=$i, result = $res");
  }

}