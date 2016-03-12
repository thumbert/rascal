library math.sudoku;

import 'dart:math' show sqrt;
import 'package:tuple/tuple.dart';

/**
 * A sudoku solver
 */

class Sudoku {
  /// internal representation
  List<List<int>> data;
}

/**
 * Represent the board.
 */
class Board {
  /// the size of the board
  int n;
  int _blockSize;

  /// allowed values, e.g. [1, 2, ..., n]
  List<int> _values;

  /// The board is represented as a collection of cells.
  /// Each cell associates a Tuple2<int,int> to a list of (possible) values.
  /// The board is solved when for all the keys, the values are a list of length 1.
  Map<Tuple2<int, int>, List<int>> cells = {};

  /// the constraints

  /// the peers of each cell is a list of other cells.  This allows to check
  /// for constraints quickly.
  Map<Tuple2<int, int>, List<Tuple2<int, int>>> peers = {};

  Board({this.n: 9}) {
    _values = new List.generate(n, (i) => i + 1);
    _blockSize = sqrt(n).round();
  }

  /// Create a board from a list input.
  Board.fromList(List<List<int>> input) {}

  /// Input should be a string, row based, each row separated by newline.
  /// Empty cells should be entered as 0's. This only work for traditional
  /// sudokus with 9x9 boards.  Bigger boards are accommodated by the fromList
  /// method.
  Board.fromString(String input) {
    n = 9;
    _blockSize = 3;
    _values = new List.generate(n, (i) => i + 1);

    var aux = input.replaceAll(' ', '').split('\n').where((e) => e.isNotEmpty);
    int i = 0;
    aux.forEach((String row) {
      //print('row is: -$row-');
      if (row.length != 9) throw 'Input row has more than 9 characters!';
      for (int j = 0; j < 9; j++) {
        int value = int.parse(row[j]);

        /// the value 0 is special, it means the cell is empty
        if (value == 0) {
          cells[new Tuple2(i, j)] = new List.from(_values);
        } else {
          cells[new Tuple2(i, j)] = [value];
        }
      }
      i += 1;
    });

    _makePeers();
  }

  /// solve the board
  solve() {}

  /// Enforce constraints for all the cells
  enforceConstraintsAll() {
    cells.forEach((ij, values) {
      if (values.length == 1) setCellValue(ij, values.first);
    });
  }

  /// Set the value for cell [i,j]
  /// Return true if you created a new cell in the elimination process.
  bool setCellValue(Tuple2<int, int> ij, int value) {
    bool haveNewSingle = false;

    /// only if it's in the existing list
    if (!cells[ij].contains(value))
      throw 'Cannot remove from cell $ij the value $value.  It does not exist!';

    /// set the value of this cell
    cells[ij] = [value];

    /// remove this value from all the cell's peers
    peers[ij].forEach((Tuple2 peer) {
      cells[peer]..retainWhere((e) => e != value);
      if (cells[peer].length == 1) haveNewSingle = true;
    });

    return haveNewSingle;
  }

  /// If a cell has only one value V, look for
  /// 1) another V in the other two rows of the block
  /// 2) another V in the other two columns of the block
  ///
  enforceSecondOrderConstraints(Tuple2<int, int> ij, int value) {

  }


  /// Check if the board has been solved.
  bool isSolved() {
    return cells.values.every((e) => e.length == 1);
  }


  _makePeers() {
    /// row peers
    for (int r = 0; r < n; r++) {
      List aux = new List.generate(n, (i) => new Tuple2(r, i));
      aux.forEach((Tuple2 t) {
        peers[t] = new List.from(aux)..removeWhere((e) => e == t);
      });
    }

    /// column peers
    for (int c = 0; c < n; c++) {
      List aux = new List.generate(n, (i) => new Tuple2(i, c));
      aux.forEach((Tuple2 t) {
        peers[t] = new List.from(aux)..removeWhere((e) => e == t);
      });
    }

    /// block peers
    List _rows = new List.generate(_blockSize, (i) => i);
    for (int b = 0; b < n; b++) {
      /// coordinate of top cell in the block b
      int ib = (b % _blockSize) * _blockSize;
      int jb = (b ~/ _blockSize) * _blockSize;

      /// all the cells in this block
      List<Tuple2> aux = [];
      _rows.forEach((int r) {
        aux.addAll(
            new List.generate(_blockSize, (i) => new Tuple2(ib + r, jb + i)));
      });

      /// assign the peers for the cells in the block, except the cell itself
      aux.forEach((e) {
        peers[e] = new List.from(aux)..retainWhere((peer) => peer != e);
      });
    }
  }
}

class Cell {
  int row, column;
  List<int> allowedValues;
  int maxValue;
  int _value;

  Cell(this.row, this.column, {int this.maxValue: 9}) {}

  int get value => _value;

  ///
  set value(int number) {}
}
