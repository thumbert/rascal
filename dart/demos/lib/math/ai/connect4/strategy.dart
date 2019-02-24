
import 'dart:math' show Random;
import 'connect4.dart';


/// A strategy is associated with a player.
abstract class Strategy {
  String name;
  /// the location of the next chip
  int nextMove(Connect4Game game);
}

class RandomStrategy implements Strategy {
  String name;
  Random random;
  RandomStrategy() {
    name = 'Random strategy';
    random = Random();
  }

  // if the column is filled, pick another column
  int nextMove(Connect4Game game) {
    bool isOk;
    int columnIndex;
    do {
      columnIndex = random.nextInt(game.nColumns);
      isOk = true; //!game.addChip(columnIndex, game.playerToMove);
    } while (!isOk);

    return columnIndex;
  }
}

//class Foresight1Strategy implements Strategy {
//  String name;
//  Random random;
//
//  Foresight1Strategy() {
//    name = 'Foresight 1 strategy';
//    random = Random();
//  }
//
//  /// Check if you have 3 in a row, then add the 4th
//  /// (if possible).  Also, check if the opponent has
//  /// 3 in a row so you can block him.
//  /// If the column is filled, pick another column.
//  int nextMove(Connect4Game game) {
//    // check that one move wins the match for player
//    for (int i=0; i<game.board.nColumns; i++) {
//      print(i);
//      var columns = <Column>[];
//      for (var column in game.board.columns) {
//        columns.add(column.clone());
//      }
//      var newBoard = Board()..columns = columns;
//      var res = newBoard.addChip(i, game.playerToMove);
//      print(newBoard);
//      if (res && newBoard.isWinner(game.playerToMove)) {
//        /// found a winning move
//        return i;
//      }
//    }
//    var otherPlayer = game.otherPlayer(game.playerToMove);
//    // check that the other player doesn't have a winning move
//    for (int i=0; i<game.board.nColumns; i++) {
//      var newBoard = Board()..columns = List.of(game.board.columns);
//      var res = newBoard.addChip(i, otherPlayer);
//      if (res && newBoard.isWinner(otherPlayer)) {
//        /// found a move to stop the other player from winning
//        return i;
//      }
//    }
//
//    // no winning move, so choose randomly
//    bool isOk;
//    int columnIndex;
//    do {
//      columnIndex = random.nextInt(game.board.nColumns);
//      isOk = !game.board.columns[columnIndex].isFilled;
//    } while (!isOk);
//
//    return columnIndex;
//  }
//}
