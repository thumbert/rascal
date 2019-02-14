library math.ai.connect4;

import 'dart:math' show min, Random;
import 'package:more/iterable.dart';
import 'strategy.dart';

class Connect4Game {
  Board board;
  Player player1;
  Player player2;


  Connect4Game(this.player1, this.player2) {
    board = Board();
    player1 ??= Player(Chip('red', 'X'), RandomStrategy(), name: 'A');
    player2 ??= Player(Chip('yellow', 'O'), RandomStrategy(), name: 'B');
  }

  bool move(Player player) {
    player.strategy.nextMove(board);
    return isWinner(player);
  }

  bool isWinner(Player player) {
    /// look at all this player's chips and determine if he won
    ///
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

  bool addChip(int columnIndex, Player player) {
    return columns[columnIndex].add(player.chip);
  }

  @override
  String toString() {
    var sb = StringBuffer();
    sb.write('-------\n');
    for (int r=0; r<nRows; r++) {
      for (int c=0; c<nColumns; c++) {
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
  Player(this.chip, this.strategy, {this.name}) {
  }
  @override
  String toString() {
    return 'Player: $name, chip: {${chip.toString()}}';
  }
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
  String printChar;
  Chip(this.color, this.printChar);
  @override
  String toString() => 'color: $color, char: $printChar';
}