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

  /// Keep the entire game history in this list.  Everything can be calculated
  /// from the list of moves.
  /// [row, column, player];
  var moves = <Tuple3<int, int, Player>>[];

  Connect4Game(this.player1, this.player2, {this.nColumns: 7, this.nRows: 6}) {
    player1 ??= Player(Chip('red', 'X'), RandomStrategy(), name: 'A');
    player2 ??= Player(Chip('yellow', 'O'), RandomStrategy(), name: 'B');
  }

  /// Play until a winner is found or the board is filled.
  GameOutcome play() {
    for (int _move = 0; _move < nRows * nColumns; _move++) {
      int columnIndex = playerToMove.strategy.nextMove(this);
      if (nextRow(columnIndex) == 6) {
        print('player to move: $playerToMove');
        print('number of chips in column 0 is ${nextRow(0)}');
        print('number of chips in column 1 is ${nextRow(1)}');
        print('number of chips in column 2 is ${nextRow(2)}');
        print('number of chips in column 3 is ${nextRow(3)}');
        print('number of chips in column 4 is ${nextRow(4)}');
        print('number of chips in column 5 is ${nextRow(5)}');
        print('number of chips in column 6 is ${nextRow(6)}');
        print('number of chips in column $columnIndex is ${nextRow(columnIndex)}');
        print(frontier());
        print('here');
      }
      
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

  addChip(int columnIndex) {
    if (!frontier().contains(columnIndex)) {
      print(playerToMove);
      print(frontier());
      print('trying to insert on column $columnIndex');
      throw ArgumentError('Frontier doesn\'t contain $columnIndex');
    }

    var _rowInd = nextRow(columnIndex);
    moves.add(Tuple3(_rowInd, columnIndex, playerToMove));
  }

  /// Return the number of chips in this column (the next row index).
  int nextRow(int columnIndex) =>
      moves.where((e) => e.item2 == columnIndex).length;

  Set<Tuple2<int, int>> coordinates(Player player) {
    return moves
        .where((e) => e.item3 == player)
        .map((e) => Tuple2(e.item1, e.item2))
        .toSet();
  }

  /// who made the last move?
  Player lastPlayer() {
    if (moves.isEmpty) return player1;
    return moves.last.item3;
  }

  Player get playerToMove => [player1, player2][moves.length % 2];

  /// Given a player, return the other player
  Player otherPlayer(Player player) => player == player1 ? player2 : player1;

  /// Calculate the frontier which is the set of columns not filled yet.
  Set<int> frontier() {
    // find the filled columns
    var xs = count(moves.map((e) => e.item2).toList())
        .entries
        .where((e) => e.value == nRows)
        .map((e) => e.key);
//    if (xs.isNotEmpty) {
//      print(showBoard());
//      print('columns ${xs} are filled');
//    }

    return {0, 1, 2, 3, 4, 5, 6}..removeAll(xs);
  }

  bool isWinner(Player player) {
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
  String name;
  Chip chip;
  Strategy strategy;

  Player(this.chip, this.strategy, {this.name}) {}

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
