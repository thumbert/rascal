library test_list_copy;


num modify1(List x) {
  x[2]=10;
  return x.reduce((a,b) => a+b);
}

num modify2(List x) {
  List y = new List.from(x);
  y[2]=30;
  return y.reduce((a,b) => a+b);
}

num modify3(List z) {
  List zz = new List.from(z); /// not a deep copy!
  zz[0]['A'] = 999;
  return 1;
}


main() {

  List x = [1,2,3,4];
  print(x);

  modify1(x);
  print(x);

  modify2(x);
  print(x);

  List z = [{'A': 1}, {'A': 2}];
  modify3(z);
  print(z);
  /// [{A: 999}, {A: 2}] !!
}
