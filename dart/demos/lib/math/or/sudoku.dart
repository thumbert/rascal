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
  /// the size of the board, usually 9 for a 9x9 board
  int n;
  /// the size of the small square unit, usually 3
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

  /// keep track of the choices made when solving.  You constantly add and
  /// delete from this list until you find the solution!
  List<Cell> _path;


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

    if (isSolved()) return;

    /// the baseline I always return to
    Map<Coord, List<int>> cells0 = {};
    cells.forEach((k,v) {cells0[k] = new List.from(v);});
    _path = [];

    cells[new Coord(0,5)] = [8];

    /// if simply enforcing the constraints does not solve the Sudoku,
    /// you need to start making choices.
    while ( true ) {
      _path = _makeChoice(_path);
      print('path is: $_path');

      /// _makeChoice returns either when you're done or when
      if ( isSolved()) return;
      else {
        /// it was a conflict, backtrack until no conflict!
        while ( isBoardInConflict() ) {
          cells0.forEach((k,v) {cells[k] = new List.from(v);});
          Cell last = _path.removeLast();
          print('Backtracking: Remove $last from path');
          if (_path.isNotEmpty) {
            _path.forEach((Cell c) => setCellValue(c.coord, c.value));
            enforceConstraintsAll();
          }
          /// always can remove the last value as for sure it doesn't work
          cells[last.coord].remove(last.value);
          ///if (cells[last.coord].length == 1) enforceConstraintsAll();
          print('Board in conflict? ${isBoardInConflict()}');
          cells.forEach((k,v) => print('$k: $v'));
        }
      }
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

  /// Pick a value for a cell and enforce the constraints.
  /// If the choice creates a conflict, return.
  ///
  /// Returns the path of choices made.  When it returns, either the board
  /// is solved, or there is a conflict.
  ///
  List<Cell> _makeChoice(List<Cell> path) {

    if (isBoardInConflict() || isSolved()) {
      return path;
    } else {
      var aux = cells.values.where((v) => v.length > 1);
      /// find the minimum length of value among the remaining cells
      int minLength = aux.fold(aux.first.length, (a,b) => min(a, b.length));
      print('Min length is $minLength');
      /// there may be several cells with minLength values, so pick the first one
      Coord coord = cells.keys.firstWhere((k) => cells[k].length == minLength);

      /// chose a value to guess on this cell
      int chosen = cells[coord].first;
      print('  Chosen for $coord: $chosen');
      path.add( new Cell(coord, chosen) );

      /// set the value and check if there are conflicts
      setCellValue(coord, chosen);
      enforceConstraintsAll();
      /// after all constraints are enforced, board can become in conflict!

      return _makeChoice( path );
    }
  }

  /// Return the number of single cells on the board
  int numberOfSingleCells() {
    return cells.values.where((e) => e.length == 1).length;
  }


  /// Check if the board has been solved.
  bool isSolved() {

    /// have only one value left in each cell
    if (!cells.values.every((e) => e.length == 1))
      return false;

    /// if you have only one value, check that constraints are satisfied
    return !isBoardInConflict();
  }



  /// Test if the board is in conflict.  Returns true if the board is
  /// in conflict (constraints are violated) or false if the board is
  /// sound.
  bool isBoardInConflict() {
    bool res = false;

    /// For each row, check that the values already set and the values remaining to be set
    /// are the whole _values, i.e. you are not missing a value!
    for (int r = 0; r < n; r++) {
      List _row = new List.generate(n, (i) => new Coord(r, i));
      if (_row.any((ij) => cells[ij].isEmpty)) {
        print('Row $r fails!  Empty cell.');
        return true;
      }
      Set aux = _row.expand((ij) => cells[ij]).toSet();
      if (aux.length != _values.length) {
        print('Row $r fails!  Missing or duplicate values.');
        return true;
      }
//      /// make sure that you don't have already the same value set in the same row!
//      List oneVals = _row.where((ij) => cells[ij].length == 1)
//          .map((ij) => cells[ij].first).toList(growable: false);
//      if (oneVals.length != oneVals.toSet().length) {
//        print('Row $r fails!  Duplicate values.');
//        return true;
//      }

    }
    /// check cols
    for (int c = 0; c < n; c++) {
      List _col = new List.generate(n, (i) => new Coord(i,c));
      if (_col.any((ij) => cells[ij].isEmpty)) {
        print('Row $c fails!  Empty cell.');
        return true;
      }
      Set aux = _col.map((ij) => cells[ij]).toSet();
      if (aux.length != _values.length) {
        print('Column $c fails!  Missing or duplicate values!');
        return true;
      }
//      /// make sure that you don't have already the same value set in the same row!
//      List oneVals = _col.where((ij) => cells[ij].length == 1)
//          .map((ij) => cells[ij].first).toList(growable: false);
//      if (oneVals.length != oneVals.toSet().length) {
//        print('Col $c fails!  Duplicate values.');
//        return true;
//      }
    }

    /// check unit blocks
    List _rows = new List.generate(_blockSize, (i) => i);
    for (int b = 0; b < n; b++) {
      /// coordinate of top cell in the block b
      int ib = (b % _blockSize) * _blockSize;
      int jb = (b ~/ _blockSize) * _blockSize;

      List coords = [];
      _rows.forEach((int r) {
        coords.addAll(
            new List.generate(_blockSize, (i) => new Coord(ib + r, jb + i)));
      });

      Set aux = coords.expand((ij) => cells[ij]).toSet();
      if (aux.length != _values.length) {
        print('Block $b fails.  Missing or duplicate values.');
        return true;
      }
//      /// make sure you don't have duplicates in the block
//      List oneVals = coords
//          .where((ij) => cells[ij].length == 1)
//          .map((ij) => cells[ij].first).toList();
//      if (oneVals.length != oneVals.toSet().length) {
//        print('Block $b fails!  Duplicate values.');
//        return true;
//      }
    }

    return  res;
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
    _value = 1024*column + row;
  }

  int get hashCode => _value;
  bool operator ==(Coord other) => other != null && row == other.row && column == other.column;
  String toString() => '($row, $column)';
}

class Cell {
  Coord coord;
  int value;
  Cell(this.coord, this.value);

  int get hashCode => 1024*coord._value + value;
  bool operator ==(Cell other) => other != null && value == other.value && coord == other.coord;
  String toString() => coord.toString() + ': $value';
}