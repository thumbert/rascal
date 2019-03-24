library math.ai.connect4;

import 'package:more/iterable.dart';
import 'package:tuple/tuple.dart';
import 'strategy.dart';
import 'package:dama/basic/count.dart';

enum GameOutcome { winnerPlayer1, winnerPlayer2, tie }

class Connect4Game {
  int nColumns;
  int nRows;
  Player player1;
  Player player2;

  Set<int> _columns;

  /// Keep the entire game history in this list.  Everything can be calculated
  /// from the list of moves.
  /// [row, column, player];
  var moves = <Tuple3<int, int, Player>>[];

  Connect4Game(this.player1, this.player2, {this.nColumns: 7, this.nRows: 6}) {
    player1 ??= Player(Chip('red', 'X'), RandomStrategy(), name: 'A');
    player2 ??= Player(Chip('yellow', 'O'), RandomStrategy(), name: 'B');

    _columns = Set.from(List.generate(nColumns, (i) => i));
  }

  /// Play until a winner is found or the board is filled.
  GameOutcome play() {
    for (int _move = 0; _move < nRows * nColumns; _move++) {
      var columnIndex = playerToMove.strategy.nextMove(this);
      addChip(columnIndex);
      var playerWhoMoved = lastPlayer();

      // check if you have a winner
      if (isWinner(playerWhoMoved)) {
        if (playerWhoMoved == player1)
          return GameOutcome.winnerPlayer1;
        else
          return GameOutcome.winnerPlayer2;
      }
    }

    /// filled the board and no winner?  It's a tie!
    return GameOutcome.tie;
  }

  /// add a chip to the board
  addChip(int columnIndex) {
    if (!frontier().contains(columnIndex)) {
      // you should never be here
      throw ArgumentError('Frontier doesn\'t contain $columnIndex');
    }

    var _rowInd = nextRow(columnIndex);
    moves.add(Tuple3(_rowInd, columnIndex, playerToMove));
  }

  /// Return the number of chips in this column (the next row index).
  int nextRow(int columnIndex) =>
      moves.where((e) => e.item2 == columnIndex).length;

  /// Get the chip coordinates of a given player
  Set<Tuple2<int, int>> coordinates(Player player) {
    return moves
        .where((e) => e.item3 == player)
        .map((e) => Tuple2(e.item1, e.item2))
        .toSet();
  }

  /// Get the player who made the last move.
  Player lastPlayer() {
    if (moves.isEmpty) return player1;
    return moves.last.item3;
  }

  /// Get the player who has to move next.
  Player get playerToMove => [player1, player2][moves.length % 2];

  /// Given a player, return the other player
  Player otherPlayer(Player player) => player == player1 ? player2 : player1;

  /// Calculate the frontier which is the set of columns not filled yet.
  /// These are the only columns that can accept at least one chip.
  Set<int> frontier() {
    // find the filled columns
    var xs = count(moves.map((e) => e.item2).toList())
        .entries
        .where((e) => e.value == nRows)
        .map((e) => e.key);
    return _columns..removeAll(xs);
  }

  /// Check if a game is over
  bool isOver() {
    return moves.length == nRows * nColumns ||
        isWinner(player1) ||
        isWinner(player2);
  }

  /// Check if a player has won, given the current board configuration.
  bool isWinner(Player player) {
    // no need to check if you have < 7 pieces on the board
    if (moves.length < 7) return false;

    var coords = coordinates(player);
    if (_checkHorizontal(coords) ||
        _checkVertical(coords) ||
        _checkSlopePlus1(coords) ||
        _checkSlopeMinus1(coords)) return true;
    return false;
  }

  bool _checkHorizontal(Set<Tuple2<int, int>> coords) {
    for (var e in coords.where((e) => e.item2 < nColumns - 3)) {
      if (coords.contains(Tuple2(e.item1, e.item2 + 1)) &&
          coords.contains(Tuple2(e.item1, e.item2 + 2)) &&
          coords.contains(Tuple2(e.item1, e.item2 + 3))) return true;
    }
    return false;
  }

  bool _checkSlopePlus1(Set<Tuple2<int, int>> coords) {
    for (var e in coords.where((e) => e.item1 < nRows - 3)) {
      if (coords.contains(Tuple2(e.item1 + 1, e.item2 + 1)) &&
          coords.contains(Tuple2(e.item1 + 2, e.item2 + 2)) &&
          coords.contains(Tuple2(e.item1 + 3, e.item2 + 3))) return true;
    }
    return false;
  }

  bool _checkVertical(Set<Tuple2<int, int>> coords) {
    for (var e in coords.where((e) => e.item1 < nRows - 3)) {
      if (coords.contains(Tuple2(e.item1 + 1, e.item2)) &&
          coords.contains(Tuple2(e.item1 + 2, e.item2)) &&
          coords.contains(Tuple2(e.item1 + 3, e.item2))) return true;
    }
    return false;
  }

  bool _checkSlopeMinus1(Set<Tuple2<int, int>> coords) {
    for (var e in coords.where((e) => e.item1 < nRows - 3)) {
      if (coords.contains(Tuple2(e.item1 + 1, e.item2 - 1)) &&
          coords.contains(Tuple2(e.item1 + 2, e.item2 - 2)) &&
          coords.contains(Tuple2(e.item1 + 3, e.item2 - 3))) return true;
    }
    return false;
  }

  String showBoard() {
    var board = Map.fromIterable(moves,
        key: (e) => Tuple2(e.item1, e.item2), value: (e) => e.item3);
    var sb = StringBuffer();
    sb.write('-------\n');
    for (int r = 0; r < nRows; r++) {
      for (int c = 0; c < nColumns; c++) {
        if (board.containsKey(Tuple2(r, c))) {
          sb.write(board[Tuple2(r, c)].chip.printChar);
        } else {
          sb.write(' ');
        }
      }
      sb.write('\n');
    }
    return sb.toString().split('\n').reversed.join('\n');
  }
}

class Player {
  final String name;
  final Chip chip;
  final Strategy strategy;

  Player(this.chip, this.strategy, {this.name});

  @override
  String toString() {
    return 'Player: $name, chip: {${chip.toString()}}';
  }
}

class Chip {
  String color;
  String printChar;
  Chip(this.color, this.printChar);
  @override
  String toString() => 'color: $color, char: $printChar';
}
