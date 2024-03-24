import 'package:demos/math/ai/connect4/old/board.dart';
import 'package:demos/math/ai/connect4/old/chip.dart';
import 'package:tuple/tuple.dart';

class Move {
  Chip chip;
  int column;
  // // The move number, first move has number 0, etc.
  // static int number = 0;
  Move(this.chip, this.column);

  // Check if this move is valid.
  bool isValid(Board board) {
    if (board[column].length >= board.rows) return false;
    if (column > board.columns || column < 0) return false;
    if (board.chipsCount >= board.rows * board.columns) return false;
    return true;
  }

  /// Check if this move is a winning move given the input board
  /// Only check from the point of view of the player who makes the move.
  bool isWinning(Board board) {
    var board1 = board.copy(); // don't mutate the board
    board1.add(column);
    if (board1.chipsCount < 7) return false;
    var coords = board1.coordinates(chip);
    if (_checkHorizontal(coords, board1.columns) ||
        _checkVertical(coords, board1.rows) ||
        _checkSlopePlus1(coords, board1.rows) ||
        _checkSlopeMinus1(coords, board1.rows)) return true;
    return false;
  }

  bool _checkHorizontal(Set<Tuple2<int, int>> coords, int columns) {
    for (var e in coords.where((e) => e.item2 < columns - 3)) {
      if (coords.contains(Tuple2(e.item1, e.item2 + 1)) &&
          coords.contains(Tuple2(e.item1, e.item2 + 2)) &&
          coords.contains(Tuple2(e.item1, e.item2 + 3))) return true;
    }
    return false;
  }

  bool _checkSlopePlus1(Set<Tuple2<int, int>> coords, int rows) {
    for (var e in coords.where((e) => e.item1 < rows - 3)) {
      if (coords.contains(Tuple2(e.item1 + 1, e.item2 + 1)) &&
          coords.contains(Tuple2(e.item1 + 2, e.item2 + 2)) &&
          coords.contains(Tuple2(e.item1 + 3, e.item2 + 3))) return true;
    }
    return false;
  }

  bool _checkSlopeMinus1(Set<Tuple2<int, int>> coords, int rows) {
    for (var e in coords.where((e) => e.item1 < rows - 3)) {
      if (coords.contains(Tuple2(e.item1 + 1, e.item2 - 1)) &&
          coords.contains(Tuple2(e.item1 + 2, e.item2 - 2)) &&
          coords.contains(Tuple2(e.item1 + 3, e.item2 - 3))) return true;
    }
    return false;
  }

  bool _checkVertical(Set<Tuple2<int, int>> coords, int rows) {
    for (var e in coords.where((e) => e.item1 < rows - 3)) {
      if (coords.contains(Tuple2(e.item1 + 1, e.item2)) &&
          coords.contains(Tuple2(e.item1 + 2, e.item2)) &&
          coords.contains(Tuple2(e.item1 + 3, e.item2))) return true;
    }
    return false;
  }
}
