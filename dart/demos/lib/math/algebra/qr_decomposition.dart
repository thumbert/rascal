library math.qr_decomposition;

import 'dart:math';
import 'package:demos/math/algebra/matrix.dart';
//import 'package:demo/math/decomposition_solver.dart';

class QRDecomposition {
  Matrix Q, R;
  /// threshold for the singularity test of the matrix
  num threshold;
  Matrix _qrt, _cachedQ, _cachedQT, _cachedR, _cachedH;

  // the diagonal elements of R
  List<num> _rDiag;

  QRDecomposition(Matrix x, {num this.threshold: 1E-14}) {
    _qrt = x.transpose();

    _rDiag = new List.filled(min(x.nrow, x.ncol), 0.0);

    decompose(_qrt);
  }

  decompose(Matrix matrix) {
    for (int minor=0; minor<min(matrix.nrow, matrix.ncol); minor++)
      householderReflection(minor);
  }

  void householderReflection(int minor) {
    List<num> qrtMinor = _qrt.row(minor).data;

    num xNormSqr = qrtMinor.skip(minor).fold(0, (prev, e) => prev + e*e);

    final a = qrtMinor[minor] > 0 ? -sqrt(xNormSqr) :  sqrt(xNormSqr);
    _rDiag[minor] = a;

    if (a != 0.0) {
      qrtMinor[minor] -= a;
      _qrt[[minor,minor]] = qrtMinor[minor];
      for (int col = minor+1; col < _qrt.nrow; col++) {
        List qrtCol = _qrt.row(col).data;
        double alpha = 0.0;
        for (int row = minor; row < qrtCol.length; row++) {
          alpha -= qrtCol[row] * qrtMinor[row];
        }
        alpha /= a * qrtMinor[minor];

        // Subtract the column vector alpha*v from x.
        for (int row = minor; row < qrtCol.length; row++)
          qrtCol[row] -= alpha * qrtMinor[row];

        _qrt.setRow(col, qrtCol);
      }
    }
  }

  Matrix getR() {
    int m = _qrt.ncol;
    int n = _qrt.nrow;
    Matrix ra = new Matrix.filled(0.0, m, n);
    for (int row=min(m,n)-1; row >=0; row--) {
      ra[[row,row]] = _rDiag[row];
      for (int col=row+1; col<n; col++)
        ra[[row,col]] = _qrt[[col,row]];
    }

    return ra;
  }

  /**
   * Return the Q matrix of the QR decomposition.
   * Matrix Q is orthogonal and has size [m x m]
   */
  Matrix getQ() {
    if (_cachedQ == null)
      _cachedQ = _getQT().transpose();

    return _cachedQ;
  }

  Matrix _getQT() {
    if (_cachedQT == null) {
      int m = _qrt.ncol;
      int n = _qrt.nrow;
      _cachedQT = new Matrix.filled(0.0, m, m);

      for (int minor=m-1; minor>=min(m,n); minor--)
        _cachedQT[[minor,minor]] = 1.0;

      for (int minor=min(m,n)-1; minor>=0; minor--){
        List qrtMinor=_qrt.row(minor).data;
        _cachedQT[[minor,minor]] = 1.0;
        if (qrtMinor[minor] != 0.0) {
          for (int col=minor; col<m; col++) {
            num alpha = 0.0;
            for (int row=minor; row<m; row++)
              alpha -= _cachedQT[[col,row]] * qrtMinor[row];
            alpha /= _rDiag[minor] * qrtMinor[minor];

            for (int row=minor; row<m; row++)
              _cachedQT[[col,row]] += -alpha * qrtMinor[row];
          }
        }
      }
    }

    return _cachedQT;
  }

  /**
   * Return the Householder reflector vectors.
   */
//  Matrix getH() {
//    if (_cachedH == null) {
//
//    }
//
//    return _cachedH;
//  }

  DecompositionSolver getSolver() => new _Solver(_qrt, _rDiag, threshold);

}

class _Solver implements DecompositionSolver {
  Matrix _qrt;
  List _rDiag;
  num threshold;

  _Solver(Matrix this._qrt, List this._rDiag, num this.threshold);

  bool isNonSingular() {
    for (num diag in _rDiag) {
      if (diag.abs() <= threshold)
        return false;
    }
    return true;
  }

  ColumnMatrix solve(ColumnMatrix b) {
    final int n = _qrt.nrow;
    final int m = _qrt.ncol;
    if (b.nrow != m)
      throw 'Dimensions mismatch';

    List<num> x = new List.filled(n, 0.0);
    List<num> y = new List.from(b.data, growable: false);

    // apply Householder transforms to solve Q.y = b
    for (int minor=0; minor<min(n,m); minor++) {
      List qrtMinor = _qrt.row(minor).data;
      num dotProduct = 0.0;
      for (int row = minor; row < m; row++)
        dotProduct += y[row] * qrtMinor[row];
      dotProduct /= _rDiag[minor] * qrtMinor[minor];

      for (int row = minor; row < m; row++)
        y[row] += dotProduct * qrtMinor[row];
    }

    // solve triangular system R.x = y
    for (int row = _rDiag.length - 1; row >= 0; --row) {
      y[row] /= _rDiag[row];
      final num yRow = y[row];
      final List qrtRow = _qrt.row(row).data;
      x[row] = yRow;
      for (int i = 0; i < row; i++) {
        y[i] -= yRow * qrtRow[i];
      }
    }

    return new ColumnMatrix(x);
  }

  Matrix inverse() {
    return new Matrix([1], 1, 1);  // TODO:
  }

}