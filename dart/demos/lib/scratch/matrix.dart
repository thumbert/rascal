library scratch.matrix;



abstract class Matrix {
  int nrow;
  int ncol;

  Matrix._empty(int this.nrow, int this.ncol);

  factory Matrix.fromList(List x, int nrow, int ncol) {

  }
}

class DoubleMatrix extends Matrix {
  List<double> x;

  DoubleMatrix(List this.x, int nrow, int ncol): super._empty(nrow, ncol) {

  }
}