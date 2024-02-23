// library math.or.cassie_square;

// import 'dart:math';

// /**
//  * Problem brought home by Cassie (3rd grade) 1/19/2016
//  * A 4x4 matrix is to be filled with the integers 1 to 16
//  * such that the sum of rows, sum of columns and sum of diagonals
//  * equals 34.
//  */

// bool checkConstraints(List<int> x) {
//   if (x.length < 16) return false;

//   if (x.toSet().length != 16) return false;

//   bool r1 = x[0] + x[1] + x[2] + x[3] == 34;
//   bool r2 = x[4] + x[5] + x[6] + x[7] == 34;
//   bool r3 = x[8] + x[9] + x[10] + x[11] == 34;
//   bool r4 = x[12] + x[13] + x[14] + x[15] == 34;

//   bool c1 = x[0] + x[4] + x[8] + x[12] == 34;
//   bool c2 = x[1] + x[5] + x[9] + x[13] == 34;
//   bool c3 = x[2] + x[6] + x[10] + x[14] == 34;
//   bool c4 = x[3] + x[7] + x[11] + x[15] == 34;

//   bool d1 = x[0] + x[5] + x[10] + x[15] == 34;
//   bool d2 = x[12] + x[9] + x[6] + x[3] == 34;

//   return r1 && r2 && r3 && r4 && c1 && c2 && c3 && c4 && d1 && d2;
// }

// List<int> generate(Random r) {
//   /// the solution
//   List<int> x = new List(16);

//   int i;
//   List<int> z = new List.generate(16, (i) => i+1);

//   i = r.nextInt(z.length);
//   x[0] = z[i];
//   z.removeAt(i);

//   i = r.nextInt(z.length);
//   x[6] = z[i];
//   z.removeAt(i);

//   i = r.nextInt(z.length);
//   x[9] = z[i];
//   z.removeAt(i);

//   i = r.nextInt(z.length);
//   x[3] = z[i];
//   z.removeAt(i);

//   x[12] = 34 - x[3] - x[6] - x[9]; /// guaranteed
//   if (x[12] <= 0) return z;
//   z.remove(x[12]);

//   i = r.nextInt(z.length);
//   x[4] = z[i];
//   z.removeAt(i);

//   x[8] = 34 - x[0] - x[4] - x[12]; /// guaranteed
//   if (x[8] <= 0) return z;
//   z.remove(x[7]);

//   i = r.nextInt(z.length);
//   x[10] = z[i];
//   z.removeAt(i);

//   x[11] = 34 - x[8] - x[9] - x[10]; /// guaranteed
//   if (x[11] <= 0) return z;
//   z.remove(x[11]);

//   i = r.nextInt(z.length);
//   x[15] = z[i];
//   z.removeAt(i);

//   x[7] = 34 - x[3] - x[11] - x[15]; /// guaranteed
//   if (x[7] <= 0) return z;
//   z.remove(x[7]);

//   x[5] = 34 - x[4] - x[6] - x[7]; /// guaranteed
//   if (x[5] <= 0) return z;
//   z.remove(x[5]);

//   i = r.nextInt(z.length);
//   x[1] = z[i];
//   z.removeAt(i);

//   x[2] = 34 - x[0] - x[1] - x[3]; /// guaranteed
//   if (x[2] <= 0) return z;
//   z.remove(x[2]);

//   x[14] = 34 - x[2] - x[6] - x[10]; /// guaranteed
//   if (x[14] <= 0) return z;
//   z.remove(x[14]);

//   x[13] = 34 - x[1] - x[5] - x[9]; /// guaranteed
//   if (x[13] <= 0) return z;
//   z.remove(x[13]);

//   return x;
// }

// String pretty(List<int> x) {
//   var y = x.map((e) => e.toString().padLeft(2)).toList();
//   return y[0] + ' ' + y[1] + ' ' + y[2] + ' ' + y[3] + '\n' +
//          y[4] + ' ' + y[5] + ' ' + y[6] + ' ' + y[7] + '\n' +
//       y[8] + ' ' + y[9] + ' ' + y[10] + ' ' + y[11] + '\n' +
//       y[12] + ' ' + y[13] + ' ' + y[14] + ' ' + y[15] + '\n';
// }

// main() {

//   Random r = new Random();

//   List<int> x;

//   for (int i=0; i<100; i++) {
//     do {
//       x = generate(r);
//     } while (!checkConstraints(x));

//     print(pretty(x));
//   }


// }
