
/// convert from celsius to farenheit.
num c2f(num x){
  return (9/5)*x + 32;
}

num f2c(num y){
  return (5/9)*(y-32);
}

num mean(List x){
  num sum=0;
  for (int i=0; i<x.length; i++){
    sum = sum + x[i];
  }
  return sum/x.length;
}




main(){

  print('0C is ${c2f(0)}F');
  print('100C is ${c2f(100)}F');

  print('0f is ${f2c(0)}c');
  print('32f is ${f2c(32)}c');
//  List x= new List.generate(500, (i) => i+1);
  List x= [10, 1, 3, 6, 12];
  print(mean(x));

}

