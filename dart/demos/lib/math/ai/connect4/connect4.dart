library math.ai.connect4;

import 'dart:math' show min, Random;
import 'package:more/iterable.dart';
import 'package:more/ordering.dart';
import 'package:tuple/tuple.dart';
import 'strategy.dart';

enum GameOutcome { winnerPlayer1, winnerPlayer2, tie }

class Connect4Game {
  Board board;
  Player player1;
  Player player2;

  Connect4Game(this.player1, this.player2) {
    board = Board();
    player1 ??= Player(Chip('red', 'X'), RandomStrategy(), name: 'A');
    player2 ??= Player(Chip('yellow', 'O'), RandomStrategy(), name: 'B');
  }

  /// Play until a winner is found or the board is filled.
  GameOutcome play() {
    int _move = 0;
    Player winner;
    for (var playerToMove in cycle([player1, player2])) {
      _move += 1;
      // check if the game is finished and ends in a tie
      if (_move > board.nColumns * board.nRows) return GameOutcome.tie;
      int columnIndex = playerToMove.strategy.nextMove(board);
      board.addChip(columnIndex, playerToMove);

      // check if you have a winner
      if (board.isWinner(playerToMove)) {
        winner = playerToMove;
        break;
      }
    }
    return winner == player1
        ? GameOutcome.winnerPlayer1
        : GameOutcome.winnerPlayer2;
  }
}

class Board {
  int nColumns;
  int nRows;
  List<Column> columns;

  Board({this.nColumns: 7, this.nRows: 6}) {
    columns = List.generate(nColumns, (i) => Column(i, maxCapacity: nRows - 1));
  }

  /// Check if the board is filled
  bool isFilled() => columns.any((e) => !isFilled());

  /// Return true if OK, false if not possible (the column is filled already)
  bool addChip(int columnIndex, Player player) {
    var column = columns[columnIndex];
    if (column.isFilled) return false;
    player.coordinates.add(Tuple2(column.chips.length, columnIndex));
    return columns[columnIndex].add(player.chip);
  }

  bool isWinner(Player player) {
    if (_checkHorizontal(player) ||
        _checkVertical(player) ||
        _checkSlopePlus1(player) ||
        _checkSlopeMinus1(player)) return true;

    return false;
  }

  bool _checkHorizontal(Player player) {
    for (var coord in player.coordinates.where((e) => e.item2 < nColumns - 3)) {
      if (player.coordinates.contains(Tuple2(coord.item1, coord.item2 + 1)) &&
          player.coordinates.contains(Tuple2(coord.item1, coord.item2 + 2)) &&
          player.coordinates.contains(Tuple2(coord.item1, coord.item2 + 3)))
        return true;
    }
    return false;
  }

  bool _checkVertical(Player player) {
    for (var coord in player.coordinates.where((e) => e.item1 < nRows - 3)) {
      if (player.coordinates.contains(Tuple2(coord.item1 + 1, coord.item2)) &&
          player.coordinates.contains(Tuple2(coord.item1 + 2, coord.item2)) &&
          player.coordinates.contains(Tuple2(coord.item1 + 3, coord.item2)))
        return true;
    }
    return false;
  }

  bool _checkSlopePlus1(Player player) {
    for (var coord in player.coordinates.where((e) => e.item1 < nRows - 3)) {
      if (player.coordinates
              .contains(Tuple2(coord.item1 + 1, coord.item2 + 1)) &&
          player.coordinates
              .contains(Tuple2(coord.item1 + 2, coord.item2 + 2)) &&
          player.coordinates.contains(Tuple2(coord.item1 + 3, coord.item2 + 3)))
        return true;
    }
    return false;
  }

  bool _checkSlopeMinus1(Player player) {
    for (var coord in player.coordinates.where((e) => e.item1 < nRows - 3)) {
      if (player.coordinates
              .contains(Tuple2(coord.item1 + 1, coord.item2 - 1)) &&
          player.coordinates
              .contains(Tuple2(coord.item1 + 2, coord.item2 - 2)) &&
          player.coordinates.contains(Tuple2(coord.item1 + 3, coord.item2 - 3)))
        return true;
    }
    return false;
  }

  @override
  String toString() {
    var sb = StringBuffer();
    sb.write('-------\n');
    for (int r = 0; r < nRows; r++) {
      for (int c = 0; c < nColumns; c++) {
        if (columns[c].chips.length > r) {
          var cell = columns[c].chips[r];
          sb.write(cell.printChar);
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
  Set<Tuple2<int, int>> coordinates; // [row,column]

  Player(this.chip, this.strategy, {this.name}) {
    coordinates = Set<Tuple2<int, int>>();
  }
  @override
  String toString() {
    return 'Player: $name, chip: {${chip.toString()}}';
  }
}

class Column {
  int index; // the column index, from 0..6
  int maxCapacity;
  List<Chip> chips;

  Column(this.index, {this.maxCapacity: 5}) {
    chips = <Chip>[];
  }

  /// return true if successful, return false if column is filled
  bool add(Chip chip) {
    if (isFilled) return false;
    chips.add(chip);
    return true;
  }

  int get nextRow => chips.length;

  bool get isFilled => nextRow > maxCapacity;
}

class Chip {
  String color;
  String printChar;
  Chip(this.color, this.printChar);
  @override
  String toString() => 'color: $color, char: $printChar';
}
