library math.ai.connect4;

import 'dart:math' show min, Random;
import 'package:more/iterable.dart';

class Connect4Game {
  Board board;
  Player player1;
  Player player2;


  Connect4Game(this.player1, this.player2) {
    board = Board();
    player1 ??= Player('red', RandomStrategy(), name: 'A');
    player2 ??= Player('yellow', RandomStrategy(), name: 'B');
  }

  bool move(Player player) {
    player.strategy.nextMove(board);
    return isWinner(player);
  }

  bool isWinner(Player player) {
    /// look at all his chips and determine if he won
  }

  /// Play until a winner is found or the board is filled.
  Player play() {
    Player winner;
    for (var playerToMove in cycle([player1,player2])) {
      playerToMove.strategy.nextMove(board);
      if (isWinner(playerToMove)) {
        winner = playerToMove;
        break;
      }
    }
    return winner;
  }



}

class Board {
  int nColumns;
  int nRows;
  List<Column> columns;

  Board({this.nColumns: 7, this.nRows: 6}) {
    columns = List.generate(nColumns, (i) => Column(i, maxCapacity: nRows-1));
  }

  /// Check if the board is filled
  bool isFilled() => columns.any((e) => !isFilled());

}

class Player {
  String name;
  String chipColor;
  Strategy strategy;
  Player(this.chipColor, this.strategy, {this.name}) {
  }
}

abstract class Strategy {
  String name;
  /// the location of the next chip
  int nextMove(Board board);
}

class RandomStrategy implements Strategy {
  String name;
  Random random;
  RandomStrategy() {
    name = 'Random strategy';
    random = Random();
  }
  int nextMove(Board board) => random.nextInt(board.nColumns);
}


class Column {
  int index;     // the column index, from 0..6
  int maxCapacity;
  List<Chip> chips;

  Column(this.index, {this.maxCapacity: 5}) {
    chips = <Chip>[];
  }

  /// return true if successful, throw if not possible to add anymore
  bool add(Chip chip) {
    if (isFilled) throw RangeError('Column $index is allready filled');
    chips.add(chip);
    return true;
  }

  int get nextRow => chips.length;

  bool get isFilled => nextRow > maxCapacity;
}

class Chip {
  String color;
  Chip(this.color);
}