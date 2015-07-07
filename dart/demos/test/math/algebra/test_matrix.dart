
library math.test_matrix;

import 'dart:math';
import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:demos/math/algebra/matrix.dart';
//import 'package:demo/math/matrix2.dart';
//import 'package:demo/math/qrdecomposition.dart';
//import 'package:demo/math/decomposition_solver.dart';

equalsWithPrecision(num value, {num precision: 1E-10}) => new _EqualsWithPrecision(value, precision);

class _EqualsWithPrecision extends Matcher {
  num value;
  num precision;
  _EqualsWithPrecision(this.value, this.precision);

  bool matches(num item, Map matchState) {
    if (item.isNaN){

    }
    if ((item.isNaN && !value.isNaN) || (!item.isNaN && value.isNaN))
      return false;
    else {
      var res = ((item-value).abs() > precision) ? false : true;
      return res;
    }
  }

  Description describe(Description description) =>
  description.addDescriptionOf(value).add(' up to precision $precision');
}

basic_ops() {
//  test('unit matrix', (){
//    Matrix m = new Matrix.unit(3);
//    expect(m.diag, [1,1,1]);
//  });
  test('matrix toList method', (){
    Matrix m = new Matrix([0,1,2,3,4,5], 2, 3);
    expect(m.toList(), [0,1,2,3,4,5]);
  });
  test('matrix creation by row', (){
    Matrix m = new Matrix([0,1,2,3,4,5], 2, 3, byRow: true);
    expect(m.toList(), [0,3,1,4,2,5]);
  });
  test('matrix equality', () {
    Matrix m1 = new Matrix([0,1,2,3], 2, 2);
    Matrix m2 = new Matrix([0,1,2,3], 2, 2);
    expect(m1, m2);
  });
  test('set/get element', (){
    Matrix m = new Matrix([0,1,2,3,4,5], 2, 3);
    expect(m.element(1,2), 5);
    m.setElement(1,2,10);
    expect(m.element(1,2), 10);
  });
  test('extract row', (){
    Matrix m1 = new Matrix([0,1,2,3,4,5], 3, 2);
    expect(m1.row(1), new Matrix([1,4], 1, 2));
  });
  test('extract column', (){
    Matrix m1 = new Matrix([0,1,2,3,4,5], 2, 3);
    expect(m1.column(1), new Matrix([2,3], 2, 1));
    expect(m1.column(2), new Matrix([4,5], 2, 1));
    Matrix m2 = new Matrix([12,6,-4,-51,167,24,4,-68,-41], 3, 3);
    expect(m2.column(1).toList(), [-51, 167, 24]);
  });
  test('extract elements', (){
    Matrix m1 = new Matrix([0,1,2,3,4,5], 2, 3);
    expect(m1[[1,1]], 3);
    expect(m1[[0,2]], 4);
    expect(m1[[1,2]], 5);
  });
  test('set element', () {
    Matrix m1 = new Matrix([0,1,2,3,4,5], 2, 3);
    m1[[0,2]] = 10;
    expect(m1[[0,2]], 10);
  });
  test('set row', () {
    Matrix m1 = new Matrix([0,1,2,3,4,5], 2, 3);
    m1.setRow(1, [6,7,8]);
    expect(m1.row(1).toList(), [6,7,8]);
  });
  test('set column', () {
    Matrix m1 = new Matrix([0,1,2,3,4,5], 2, 3);
    m1.setColumn(1, [6,7]);
    expect(m1.column(1).toList(), [6,7]);
  });
  test('rbind', (){
    Matrix m1 = new Matrix([0,1,2,3], 2, 2);
    Matrix m2 = new Matrix([4,5,6,7], 2, 2);
    Matrix m3 = m1.rbind(m2);
    expect(m3.toList(), [0,1,4,5,2,3,6,7]);
  });
  test('cbind', (){
    Matrix m1 = new Matrix([0,1,2,3], 2, 2);
    Matrix m2 = new Matrix([4,5,6,7], 2, 2);
    Matrix m3 = m1.cbind(m2);
    expect(m3.toList(), [0,1,2,3,4,5,6,7]);
  });
  test('get matrix diagonal', () {
    Matrix m1 = new Matrix([0,1,2,3,4,5], 2, 3);
    expect(m1.diag, [0,3]);
  });
  test('set matrix diagonal', () {
    Matrix m = new Matrix([0,0,0,0,0,0], 2, 3);
    m.diag = [1,1];
    expect(m.data, [[1,0,0],[0,1,0]]);
  });
  test('row apply', (){
    Matrix m1 = new Matrix([0,1,2,3,4,5], 2, 3);
    Function sum = (List x) => x.fold(0.0, (a,b) => a+b);
    expect(m1.rowApply(sum).toList(), [6,9]);
  });
  test('column apply', (){
    Matrix m1 = new Matrix([0,1,2,3,4,5], 2, 3);
    Function sum = (List x) => x.fold(0.0, (a,b) => a+b);
    expect(m1.columnApply(sum).toList(), [1,5,9]);
  });
  test('matrix norm', (){
    Matrix m = new Matrix([-3,2,0, 5,6,2, 7,4,8], 3, 3);
    expect(m.norm(p: '1'), 19);
    expect(m.norm(p: 'INFINITY'), 15);
  });
  test('matrix multiplication', (){
    Matrix m1 = new Matrix([0,1,2,3,4,5], 2, 3);
    Matrix m2 = new Matrix([0,1,2,3,4,5], 3, 2);
    Matrix m = m1.multiply(m2);
    expect(m, new Matrix([10, 13, 28, 40], 2, 2));
  });

}

diagMatrix() {
  group('Diagonal matrix: ', (){
    test('create and check elements', (){
      Matrix m = new DiagonalMatrix([1,2,3]);
      expect(m.element(1,1), 2);
      expect(m.element(0,1), 0);
    });
    test('multiply a diagonal matrix', (){
      Matrix m1 = new DiagonalMatrix([1,2,3]);
      Matrix m2 = new Matrix([0,1,2,3,4,5], 3, 2);
      Matrix m = m1.multiply(m2);
      expect(m, new Matrix([0,2,6, 3,8,15], 3, 2));
    });
  });

}

printMatrix() {
  print("Int matrix:");
  Matrix m1 = new Matrix([0,1,2,3,4,5,6,7,8,9,10,11], 4, 3);
  print(m1.toString());

  print("Double matrix:");
  Matrix m2 = new Matrix([0,1.123,2,3,4,5,6,7,8,9,10.1,11], 4, 3);
  print(m2.toString());

//  print("\nTranspose it:");
//  print(m1.transpose().toString());
//
//  print("\nTranspose it along minor diagonal:");
//  print(m1.transpose_minor_diagonal().toString());
//
//  print("\nReflect it along major diagonal:");
//  print(m1.reflect_diagonal().toString());
//
//  print("\nTranspose twice gets you back");
//  assert(m1 == m1.transpose().transpose());
//
//  print(m1.isSimilar(m1.transpose()));

}

qrDecomposition() {

  group('QR decomposition: ', (){
    test('3x3 non singular', (){
      Matrix m = new Matrix([12,6,-4,-51,167,24,4,-68,-41], 3, 3);
      QRDecomposition qr = new QRDecomposition(m);
      Matrix rExp = new Matrix([-14, 0, 0, -21, -175, 0, 14, 70, 35], 3, 3);
      Matrix qExp = new Matrix([-0.8571428571,0.3942857143,-0.3314285714,-0.4285714286,-0.9028571429,0.0342857143,
      0.2857142857,-0.1714285714,-0.9428571429], 3, 3, byRow: true);
      expect(qr.getR().norm(), equalsWithPrecision(rExp.norm()));
      expect(qr.getQ().norm(), equalsWithPrecision(qExp.norm()));

      DecompositionSolver solver = qr.getSolver();
      List x = solver.solve(new ColumnMatrix([1,1,1])).data;
      List xExp = [0.0514285714285714, -0.0102857142857143, -0.0354285714285714];
      [0,1,2].forEach((i) => expect(x[i], equalsWithPrecision(xExp[i], precision: 1E-14)));
    });
    test('3x3 singular', (){
      Matrix m = new Matrix([1,2,3,4,5,6,7,8,9], 3, 3);
      QRDecomposition qr = new QRDecomposition(m);
      Matrix rExp = new Matrix([-3.7416573868,0,0,-8.5523597412,1.9639610121,0,-13.3630620956,3.9279220242,0.0], 3, 3);
      Matrix qExp = new Matrix([-0.2672612419,0.8728715609,0.4082482905, -0.5345224838,0.2182178902,-0.8164965809,
      -0.8017837257,-0.4364357805,0.4082482905], 3, 3, byRow: true);
      expect(qr.getR().norm(), equalsWithPrecision(rExp.norm()));
      expect(qr.getQ().norm(), equalsWithPrecision(qExp.norm()));

      DecompositionSolver solver = qr.getSolver();
      List x = solver.solve(new ColumnMatrix([1,1,1])).data;
      expect(true, x.every((double e) => e.isNaN));  // singular
    });
    test('3x4 matrix', (){
      Matrix m = new Matrix([12,-51,4,1, 6,167,-68,2, -4,24,-41,3], 3, 4, byRow: true);
      QRDecomposition qr = new QRDecomposition(m);
      Matrix rExp = new Matrix([-14.0,-21.0,14.0,-0.8571428571,0.0,-175.0,70.0,-1.9257142857,0.0,0.0,35.0,-3.0914285714],
      3, 4, byRow: true);
      Matrix qExp = new Matrix([-0.8571428571,0.3942857143,-0.3314285714, -0.4285714286,-0.9028571429,0.0342857143,
      0.2857142857,-0.1714285714,-0.9428571429], 3, 3, byRow: true);
      expect(qr.getR().norm(), equalsWithPrecision(rExp.norm()));
      expect(qr.getQ().norm(), equalsWithPrecision(qExp.norm()));
    });
    test('4x3 matrix', (){
      Matrix m = new Matrix([12,-51,4, 6,167,-68, -4,24,-41, -5,34,7], 4, 3, byRow: true);
      QRDecomposition qr = new QRDecomposition(m);
      Matrix rExp = new Matrix([-14.8660687473,-8.3411426456,15.5387415413, 0.0,-179.3109738398,67.906547377, 0.0,0.0,38.95187203, 0.0,0.0,0.0],
      4, 3, byRow: true);
      Matrix qExp = new Matrix([-0.8072073528,0.3219715472,-0.1366042098,0.475489119, -0.4036036764,-0.9125681527,0.0061831614,-0.0654614965,
      0.2690691176,-0.1463621737,-0.9047587127,0.2959587739, 0.336336397,-0.2052603311,0.4033766604,0.8258530707], 4, 4, byRow: true);
      expect(qr.getR().norm(), equalsWithPrecision(rExp.norm()));
      expect(qr.getQ().norm(), equalsWithPrecision(qExp.norm()));
    });
    test('solve 3x3 non-singular', (){
      Matrix m = new Matrix([12,6,-4,-51,167,24,4,-68,-41], 3, 3);
      DecompositionSolver solver = new QRDecomposition(m).getSolver();
      List x = solver.solve(new ColumnMatrix([1,1,1])).data;
      List xExp = [0.0514285714285714, -0.0102857142857143, -0.0354285714285714];
      [0,1,2].forEach((i) => expect(x[i], equalsWithPrecision(xExp[i], precision: 1E-14)));
    });
  });

}

/**
 * Compare with other implementations
 * https://github.com/kostya/benchmarks/tree/master/matmul
 * pretty decent results.
 */
speed_test() {
  Matrix _makeTestMatrix(int N) {
    List m = [];
    var aux = 1.0/N/N;
    for (int i=0; i<N; i++)
      for (int j=0; j<N; j++)
        m.add(aux*(i-j)*(i+j));

    return new Matrix(m, N, N);
  }

  int N = 1500;
  print('Speed test Matrix');
  Stopwatch sw = new Stopwatch()..start();
  Matrix a = _makeTestMatrix(N);
  Matrix b = _makeTestMatrix(N);
  sw.stop();
  print('created in ${sw.elapsed}');
  sw.start();
  Matrix c = a.multiply(b);
  print(c.element(N~/2, N~/2)); // -143.50016666665678
  print('multiplied in ${sw.elapsed}');
}



main() {


  //basic_ops();
//  diagMatrix();
//  qrDecomposition();

//  IntMatrix m = new Matrix([0,1,20005,3], 2, 2);
//  Matrix d = m.toDoubleMatrix();
//  //print(m is IntMatrix);
//  //print(m.data.first is Int32List);
//  print(d);



  //speed_test();

  //speed_test_extract();

//  Matrix2 m = new Matrix2([1,2,3,4], 2, 2);
//  print(m.data);


  List x = [1,2,3,4];
  Matrix m = new Matrix(x, 2, 2);
  print('m=$m');
  print('change x[1]');
  x[1] = 100;
  print('m=\n$m');





}
