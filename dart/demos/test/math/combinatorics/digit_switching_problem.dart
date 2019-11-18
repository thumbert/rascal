
/// See:
/// https://mathenchant.wordpress.com/2018/04/16/who-knows-two/
/// https://laurentlessard.com/bookproofs/number-shuffle/
/// 
/// From Joseph Converse, a puzzle of digital manipulation:
//
// Imagine taking a number and moving its last digit to the front.
// For example, 1,234 would become 4,123. What is the smallest positive
// integer such that when you do this, the result is exactly double the
// original number? (For bonus points, solve this one without a computer.)




int flip(int n) {
  var x = n.toString();
  int l = x.length;
//  print(x[l-1]);
//  print(x.substring(0,l-1));
  return int.parse(x[x.length-1] + x.substring(0,l-1));
}

solution() {
  var n = 10;
  var found = false;
  while (!found) {
    n += 1;
    if (n % 10000000 == 0) print('got to $n');
    if (flip(n) == 4*n) found = true;
  }
  print(n);

}

/// The number we are looking for needs to be an even number.
/// Assume the last digit of the solution is 4, that means the next-to-last
/// digit is 8 (2×4), the third-to-last digit is 6 (2×8=16, carry the one),
/// fourth-to-last digit is 3 (2×6+1 carried from previously),
/// fifth-to-last digit is 7 (2×3+1), etc. Continue until the first digit
/// repeats the last digit. At that point you will be guaranteed to have
/// a number which taking the last digit and moving to the front is double
/// the original number, i.e., a “solution” but not necessarily the
/// smallest solution.

//2×105263157894736842 (18 digits)
//3×1034482758620689655172413793 (28 digits)
//4×102564 (6 digits)
//5×102040816326530612244897959183673469387755 (42 digits)
//6×1016949152542372881355932203389830508474576271186440677966 (58 digits)
//7×1014492753623188405797 (22 digits)
//8×1012658227848 (13 digits)
//9×10112359550561797752808988764044943820224719 (44 digits)


main() {
  /// solution: 5,263,157,894,736,842
  //print(flip(1234));
  solution();
}