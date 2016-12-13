

num fraction1(num x) {
  return x/(x*x+1);
}

num fraction2 (num x){
  return x*x/(x*x+1);
}

main(){
  List xs = [10,20,30,40,50];

  print(fraction1(10));

  print('First fraction:)');
  xs.forEach((x) => print('$x => ${fraction1(x)}'));

  print('Second fraction');
  xs.forEach((x) => print(fraction2(x)));

}