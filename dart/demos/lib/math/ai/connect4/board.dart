import 'package:demos/math/ai/connect4/chip.dart';
import 'package:demos/math/ai/connect4/move.dart';
import 'package:tuple/tuple.dart';

class Board {
  /// number of columns for the board, 7 in the board game
  int columns;

  /// number of rows for the board, 6 in the board game
  int rows;
  Chip chip1, chip2;

  /// the number of chips on the board
  int chipsCount = 0;

  /// Columns, then rows
  late List<List<Chip>> _board;
  late Chip _nextChip;

  Board(
      {this.columns = 7,
      this.rows = 6,
      this.chip1 = const Chip('X'),
      this.chip2 = const Chip('O')}) {
    _board = List.generate(columns, (i) => <Chip>[]);
    _nextChip = chip1;
  }

  /// Parse a board from a list of Strings.  Each element is a column.
  /// If the number of characters is odd, the player with fewer chips is next.
  ///
  /// [
  ///   'XO',
  ///   '',
  ///   'XX'
  ///   'OO',
  ///   'O',
  ///   'X',
  ///   'X',
  /// ]
  Board.parse(List<String> xs,
      {this.columns = 7,
      this.rows = 6,
      this.chip1 = const Chip('X'),
      this.chip2 = const Chip('O')}) {
    assert(xs.length == columns);
    var chars = xs.join('').split('').toSet();
    if (chars.length != 2) {
      throw StateError('You must have exactly 2 chips.  '
          'You have ${chars.length}');
    }
    _board = List.generate(columns, (i) => <Chip>[]);
    for (var c = 0; c < columns; c++) {
      var ys = xs[c].split('');
      ys.forEach((element) {
        if (element == chip1.printChar) {
          _board[c].add(chip1);
          chipsCount += 1;
        } else if (element == chip2.printChar) {
          _board[c].add(chip2);
          chipsCount += 1;
        } else {
          throw ArgumentError('Wrong chip character $element');
        }
      });
    }
  }

  /// Create a board by parsing a string of digits, e.g. '445512'.
  static Board parseDigits(String x, {bool oneBased = true}) {
    var digits = x.split('').map((e) => int.parse(e));
    if (oneBased) {
      digits = digits.map((e) => e + 1);
    }
    return Board()..addAll(digits);
  }

  /// Add one chip to the board to column [column].  Check if it's a legal
  /// move. [column] is an integer from 0 to [columns-1].
  void add(int column, [Chip? chip]) {
    chip ??= nextChip;
    if (_board[column].length < rows) {
      _board[column].add(chip);
      _nextChip = nextChip == chip1 ? chip2 : chip1;
      chipsCount += 1;
    } else {
      throw StateError('Column ${column} is already full.');
    }
  }

  /// Add a list of chips to the board.  No need to worry about the chip color.
  /// It's all kept in sync behind the scenes.
  void addAll(Iterable<int> columns) {
    for (var column in columns) {
      add(column);
    }
  }

  /// Calculate the value/score for any non final position on the board.
  /// Follow http://blog.gamesolver.org/solving-connect-four/02-test-protocol/
  /// Score is a positive integer between 1 and 22.  If the player to move wins
  /// with the last chip (when chipsCount == 41), value = 1; if he wins with the
  /// second to last chip (when chipsCount == 39), value = 2, etc.  If there are
  /// 6 chips on the board and he can win on the next chip, the position score
  /// is 18 (which is the highest possible score.)  The fewer chips you use
  /// for the win, the higher the score
  ///
  /// If the game will end in a tie, the score is zero.
  ///
  /// The score is a negative integer between -22 and -1, if the current player
  /// loses whatever chip position he plays.  The score is -22 + number of
  /// his chips on the board.
  int negamax(Board board) {
    if (chipsCount == rows * columns) return 0;

    for (var c = 0; c < columns; c++) {
      var move = Move(nextChip, c);
      if (move.isValid(board) && move.isWinning(board)) {
        return (rows * columns + 1 - chipsCount) ~/ 2;
      }
    }

    // iterate forward
    var bestScore = -rows * columns;
    for (var c = 0; c < columns; c++) {
      var move = Move(nextChip, c);
      if (move.isValid(board)) {
        var board1 = board.copy();
        board1.add(c);
        // print(board1);
        var score = -negamax(board1);
        if (score > bestScore) bestScore = score;
      }
    }

    return bestScore;
  }

  /// What chip needs to be added next to the board.
  Chip get nextChip {
    if (_nextChip == null) {
      chipsCount % 2 == 0 ? _nextChip = chip1 : _nextChip = chip2;
    }
    return _nextChip;
  }

  /// Get the board coordinates (row,column) for all the chips of this kind.
  Set<Tuple2<int, int>> coordinates(Chip chip) {
    var res = <Tuple2<int, int>>{};
    for (var c = 0; c < columns; c++) {
      var column = _board[c];
      for (var r = 0; r < column.length; r++) {
        if (column[r] == chip) {
          res.add(Tuple2(r, c));
        }
      }
    }
    return res;
  }

  /// Get the list of columns that can still accept chips (not full)
  List<int> indexOfUnfilledColumns() {
    var out = <int>[];
    for (var c = 0; c < columns; c++) {
      if (_board[c].length < rows) out.add(c);
    }
    return out;
  }

  List<Chip> operator [](int column) {
    return _board[column];
  }

  String toString() {
    var sb = StringBuffer();
    sb.write('-------\n');
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < columns; c++) {
        var column = _board[c];
        var e = ' ';
        if (column.length > r) {
          e = _board[c][r].printChar;
        }
        sb.write(e);
      }
      sb.write('\n');
    }
    return sb.toString().split('\n').reversed.join('\n') + '\n0123456';
  }

  /// Make a copy
  Board copy() {
    var board = Board(columns: columns, rows: rows, chip1: chip1, chip2: chip2);
    for (var column = 0; column < columns; column++) {
      _board[column].forEach((chip) {
        board.add(column, chip);
      });
    }
    return board;
  }
}
