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

  var moves = <Tuple3<int,int,Player>>[];  // [row, column, player];
  var frontier = Set<int>();


  Connect4Game(this.player1, this.player2, {this.nColumns: 7, this.nRows: 6}) {
    player1 ??= Player(Chip('red', 'X'), RandomStrategy(), name: 'A');
    player2 ??= Player(Chip('yellow', 'O'), RandomStrategy(), name: 'B');
    playerToMove = player1;
    frontier = List.generate(nColumns, (i) => i).toSet();
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
      if (!frontier.contains(columnIndex))
        throw IndexError(columnIndex, frontier);

      var _rowInd = nextRow(columnIndex);
      moves.add(Tuple3(_rowInd, columnIndex, playerToMove));
      // remove from frontier if it's the last row
      if (_rowInd == nRows) frontier.remove(columnIndex);

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


  /// Return the number of chips in this column (the next row index).
  int nextRow(int columnIndex) =>
      moves.where((e) => e.item2 == columnIndex).length;

  Set<Tuple2<int,int>> coordinates(Player player) {
    return moves.where((e) => e.item3 == player)
        .map((e) => Tuple2(e.item1,e.item2)).toSet();
  }

  /// Given a player, return the other player
  Player otherPlayer(Player player) => player == player1 ? player2 : player1;

  bool isWinner(Player player) {
    var coords = coordinates(player);

    if (_checkHorizontal(coords) ||
        _checkVertical(coords) ||
        _checkSlopePlus1(coords) ||
        _checkSlopeMinus1(coords)) return true;
    return false;
  }

  bool _checkHorizontal(Set<Tuple2<int,int>> coords) {
    for (var e in coords.where((e) => e.item2 < nColumns - 3)) {
      if (coords.contains(Tuple2(e.item1, e.item2 + 1)) &&
          coords.contains(Tuple2(e.item1, e.item2 + 2)) &&
          coords.contains(Tuple2(e.item1, e.item2 + 3)))
        return true;
    }
    return false;
  }

  bool _checkSlopePlus1(Set<Tuple2<int,int>> coords) {
    for (var e in coords.where((e) => e.item1 < nRows - 3)) {
      if (coords.contains(Tuple2(e.item1 + 1, e.item2 + 1)) &&
          coords.contains(Tuple2(e.item1 + 2, e.item2 + 2)) &&
          coords.contains(Tuple2(e.item1 + 3, e.item2 + 3)))
        return true;
    }
    return false;
  }

  bool _checkVertical(Set<Tuple2<int,int>> coords) {
    for (var e in coords.where((e) => e.item1 < nRows - 3)) {
      if (coords.contains(Tuple2(e.item1 + 1, e.item2)) &&
          coords.contains(Tuple2(e.item1 + 2, e.item2)) &&
          coords.contains(Tuple2(e.item1 + 3, e.item2)))
        return true;
    }
    return false;
  }

  bool _checkSlopeMinus1(Set<Tuple2<int,int>> coords) {
    for (var e in coords.where((e) => e.item1 < nRows - 3)) {
      if (coords.contains(Tuple2(e.item1 + 1, e.item2 - 1)) &&
          coords.contains(Tuple2(e.item1 + 2, e.item2 - 2)) &&
          coords.contains(Tuple2(e.item1 + 3, e.item2 - 3)))
        return true;
    }
    return false;
  }


  String showBoard() {
    var board = Map.fromIterable(moves,
        key: (e) => Tuple2(e.item1,e.item2),
        value: (e) => e.item3);
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
