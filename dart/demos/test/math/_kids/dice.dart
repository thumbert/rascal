


import 'dart:math';

List roll(Random random, int n) {
  List draw = new List(n);
  for (int i=0; i<n; i++) {
    draw[i] = random.nextInt(6)+1;
  }
  return draw;
}

/// Decide when game is over.
bool gameOver(List draw) {
  if (draw.where((e) => e == 6).) return true;
  return false;
}

int count6(List x) {
  return x.where((e) => e == 6).length;

}
int count4(List x) {
  return x
      .where((e) => e == 4)
      .length;
}

int countGeneral(List x, int n) {
  return x
      .where((e) => e == n)
      .length;
}

table(List x){
  Map out = {};
  for (int n=1; n<=6; n++) {
    out[n] = countGeneral(x, n);
  }
  return out;
}


main(){
  int n = 5;
  var m = 10;


  Random random = new Random();

//  List draw=roll(random,n);
//  print(draw);
//  print(gameOver(draw));


   List x = [2, 3, 6, 6, 1, 2, 5];
//   print(count6(x));
//   print(count4(x));
//   print(countGeneral(x, 2));

  print(table(x));



}
