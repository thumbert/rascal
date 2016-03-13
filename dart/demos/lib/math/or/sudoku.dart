library math.sudoku;

import 'dart:math' show sqrt, min;
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
  Set<int> _values;

  /// The board is represented as a collection of cells.
  /// Each cell associates a Tuple2<int,int> to a list of (possible) values.
  /// The board is solved when for all the keys, the values are a list of length 1.
  Map<Coord, List<int>> cells = {};

  /// the constraints

  /// the peers of each cell is a list of other cells.  This allows to check
  /// for constraints quickly.
  Map<Coord, Set<Coord>> peers = {};

  /// Memory of the board state when choices are made.  Need this for backtracking.
  List<Map<Coord, List<int>>> _states;

  /// keep track of the choices made when solving.  You only chose 1 value
  /// at a time.  Length of _choices is one less than length of _states
  List<Map<Coord, int>> _choices;


  Board({this.n: 9}) {
    _values = new List.generate(n, (i) => i + 1).toSet();
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
    _values = new List.generate(n, (i) => i + 1).toSet();

    var aux = input.replaceAll(' ', '').split('\n').where((e) => e.isNotEmpty);
    int i = 0;
    aux.forEach((String row) {
      //print('row is: -$row-');
      if (row.length != 9) throw 'Input row has more than 9 characters!';
      for (int j = 0; j < 9; j++) {
        int value = int.parse(row[j]);

        /// the value 0 is special, it means the cell is empty
        if (value == 0) {
          cells[new Coord(i, j)] = new List.from(_values);
        } else {
          cells[new Coord(i, j)] = [value];
        }
      }
      i += 1;
    });

    _makePeers();
  }

  /// solve the board
  solve() {
    enforceConstraintsAll();

    /// if simply enforcing the constraints does not solve the Sudoku,
    /// you need to start making choices.
    while ( !isSolved() ) {

    }

  }

  /// Enforce constraints for all the cells
  enforceConstraintsAll() {
    int baseline = numberOfSingleCells();
    cells.forEach((ij, values) {
      if (values.length == 1) setCellValue(ij, values.first);
    });

    int current = numberOfSingleCells();
    if (current > baseline) {
      print('have $current single cells');
      enforceConstraintsAll();
    }
  }

  /// Set the value for cell [i,j], and remove this value from the peers.
  /// Return true if you created a new cell in the elimination process.
  setCellValue(Coord ij, int value) {
    /// only if it's in the existing list
    if (!cells[ij].contains(value))
      throw 'Cannot remove from cell $ij the value $value.  It does not exist!';

    /// set the value of this cell, in case it wasn't set
    cells[ij] = [value];

    /// remove this value from all the cell's peers
    peers[ij].forEach((Coord peer) {
      cells[peer]..retainWhere((e) => e != value);
    });
  }

  /// pick a value for a cell and enforce the constraints
  _makeChoice() {
    int minLength = cells.values.fold(0, (a,b) => min(a.length, b.length));

  }

  int numberOfSingleCells() {
    return cells.values.where((e) => e.length == 1).length;
  }


  /// Check if the board has been solved.
  bool isSolved() {

    /// need only one value for each cell
    if (!cells.values.every((e) => e.length == 1))
      return false;

    bool res = true;
    /// check rows
    for (int r = 0; r < n; r++) {
      Set aux = new List.generate(n, (i) => new Coord(r, i))
          .map((ij) => cells[ij].first).toSet();
      if (aux.difference(_values).isNotEmpty) {
        print('Row $r fails!');
        return false;
      }
    }
    /// check cols
    for (int c = 0; c < n; c++) {
      Set aux = new List.generate(n, (i) => new Coord(i,c))
          .map((ij) => cells[ij].first).toSet();
      if (aux.difference(_values).isNotEmpty) {
        print('Column $c fails!');
        return false;
      }
    }

    /// check unit blocks
    List _rows = new List.generate(_blockSize, (i) => i);
    for (int b = 0; b < n; b++) {
      /// coordinate of top cell in the block b
      int ib = (b % _blockSize) * _blockSize;
      int jb = (b ~/ _blockSize) * _blockSize;

      Set aux = new Set();
      _rows.forEach((int r) {
        aux.addAll(
            new List.generate(_blockSize, (i) => new Coord(ib + r, jb + i))
            .map((ij) => cells[ij].first).toSet());
      });
      if (aux.difference(_values).isNotEmpty) {
        print('Block $b fails');
        return false;
      }

    }

    return res;
  }

  String toString() {
    StringBuffer sb = new StringBuffer();
    for (int r = 0; r < n; r++) {
      for (int c = 0; c < n; c++) {
        if (c % _blockSize == 0 && c != 0) sb.write('|');
        if (cells[new Coord(r,c)].length > 1) {
          sb.write(' ');
        } else {
          sb.write(cells[new Coord(r,c)].first);
        }
      }
      if (r % _blockSize == 2 && r != 0) sb.write('\n-----------\n');
      else sb.write('\n');
    }
    return sb.toString();
  }


  _makePeers() {
    /// row peers
    for (int r = 0; r < n; r++) {
      List aux = new List.generate(n, (i) => new Coord(r, i));
      aux.forEach((Coord t) {
        peers[t] = new Set.from(aux)..removeWhere((e) => e == t);
      });
    }

    /// column peers
    for (int c = 0; c < n; c++) {
      List aux = new List.generate(n, (i) => new Coord(i, c));
      aux.forEach((Coord t) {
        peers[t].addAll(new Set.from(aux)..removeWhere((e) => e == t));
      });
    }

    /// block peers
    List _rows = new List.generate(_blockSize, (i) => i);
    for (int b = 0; b < n; b++) {
      /// coordinate of top cell in the block b
      int ib = (b % _blockSize) * _blockSize;
      int jb = (b ~/ _blockSize) * _blockSize;

      /// all the cells in this block
      List<Coord> aux = [];
      _rows.forEach((int r) {
        aux.addAll(
            new List.generate(_blockSize, (i) => new Coord(ib + r, jb + i)));
      });

      /// assign the peers for the cells in the block, except the cell itself
      aux.forEach((e) {
        peers[e].addAll(new Set.from(aux)..retainWhere((peer) => peer != e));
      });
    }
  }
}

class Coord {
  int row, column;
  int _value;

  Coord(this.row, this.column) {
    _value = 1024*column +  row;
  }

  int get hashCode => _value;
  bool operator ==(Coord other) => other != null && _value == other._value;
  String toString() => '[$row, $column]';
}
