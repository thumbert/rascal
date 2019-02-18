library math.ai.connect4;

import 'package:more/iterable.dart';
import 'package:tuple/tuple.dart';
import 'strategy.dart';

enum GameOutcome { winnerPlayer1, winnerPlayer2, tie }

class Connect4Game {
  int nColumns;
  int nRows;
  Player player1;
  Player player2;
  Player playerToMove;
  Map<Tuple2<int, int>, Player> board; // [row,column] coordinates

  Connect4Game(this.player1, this.player2, {this.nColumns: 7, this.nRows: 6}) {
    board = <Tuple2<int, int>, Player>{};
    player1 ??= Player(Chip('red', 'X'), RandomStrategy(), name: 'A');
    player2 ??= Player(Chip('yellow', 'O'), RandomStrategy(), name: 'B');
    playerToMove = player1;
  }

  /// Play until a winner is found or the board is filled.
  GameOutcome play() {
    int _move = 0;
    Player winner;
    for (var _playerToMove in cycle([player1, player2])) {
      _move += 1;
      playerToMove = _playerToMove;
      // if you run out of moves, the game ends in a tie
      if (_move > nColumns * nRows) return GameOutcome.tie;
      int columnIndex = _playerToMove.strategy.nextMove(this);
      addChip(columnIndex, _playerToMove);

      // check if you have a winner
      if (isWinner(_playerToMove)) {
        winner = _playerToMove;
        break;
      }
    }
    return winner == player1
        ? GameOutcome.winnerPlayer1
        : GameOutcome.winnerPlayer2;
  }

  /// Return true if OK, or false if not possible (the column is filled already)
  bool addChip(int columnIndex, Player player) {
    var rowIndex = nextRow(columnIndex);
    if (rowIndex == nRows) return false;
    board[Tuple2(rowIndex, columnIndex)] = player;
    return true;
  }

  /// Return the next row index of the column.
  int nextRow(int columnIndex) {
    for (int r = 0; r < nRows; r++) {
      if (!board.containsKey(Tuple2(r, columnIndex))) return r;
    }
    return nRows; // the column is full
  }

  /// Given a player, return the other player
  Player otherPlayer(Player player) => player == player1 ? player2 : player1;

  bool isWinner(Player player) {
    if (_checkHorizontal(player) ||
        _checkVertical(player) ||
        _checkSlopePlus1(player) ||
        _checkSlopeMinus1(player)) return true;

    return false;
  }

  bool _checkHorizontal(Player player) {
    for (var coord in board.keys.where((e) => e.item2 < nColumns - 3)) {
      if (board[Tuple2(coord.item1, coord.item2 + 1)] == player &&
          board[Tuple2(coord.item1, coord.item2 + 2)] == player &&
          board[Tuple2(coord.item1, coord.item2 + 3)] == player) return true;
    }
    return false;
  }

  bool _checkVertical(Player player) {
    for (var coord in board.keys.where((e) => e.item1 < nRows - 3)) {
      if (board[Tuple2(coord.item1 + 1, coord.item2)] == player &&
          board[Tuple2(coord.item1 + 2, coord.item2)] == player &&
          board[Tuple2(coord.item1 + 3, coord.item2)] == player)
        return true;
    }
    return false;
  }

//  bool _checkSlopePlus1(Player player) {
//    for (var coord in player.coordinates.where((e) => e.item1 < nRows - 3)) {
//      if (player.coordinates
//              .contains(Tuple2(coord.item1 + 1, coord.item2 + 1)) &&
//          player.coordinates
//              .contains(Tuple2(coord.item1 + 2, coord.item2 + 2)) &&
//          player.coordinates.contains(Tuple2(coord.item1 + 3, coord.item2 + 3)))
//        return true;
//    }
//    return false;
//  }
//
//  bool _checkSlopeMinus1(Player player) {
//    for (var coord in player.coordinates.where((e) => e.item1 < nRows - 3)) {
//      if (player.coordinates
//              .contains(Tuple2(coord.item1 + 1, coord.item2 - 1)) &&
//          player.coordinates
//              .contains(Tuple2(coord.item1 + 2, coord.item2 - 2)) &&
//          player.coordinates.contains(Tuple2(coord.item1 + 3, coord.item2 - 3)))
//        return true;
//    }
//    return false;
//  }

  String showBoard() {
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
