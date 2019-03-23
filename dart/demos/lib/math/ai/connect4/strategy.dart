
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
      isOk = game.frontier().contains(columnIndex);
    } while (!isOk);

    return columnIndex;
  }
}

class Foresight1Strategy implements Strategy {
  String name;
  Random random;

  Foresight1Strategy() {
    name = 'Foresight 1 strategy';
    random = Random();
  }

  /// Check if you have 3 in a row, then add the 4th
  /// (if possible).  Also, check if the opponent has
  /// 3 in a row so you can block him.
  /// If the column is filled, pick another column.
  int nextMove(Connect4Game game) {
    // check that one move wins the match for player
    var frontier = game.frontier();
    for (int j in frontier) {
      game.addChip(j);
      //print(game.showBoard());
      if (game.isWinner(game.lastPlayer())) {
        /// found a winning move
        return j;
      } else {
        game.moves.removeLast();
      }
    }

    // no winning move found, so choose randomly from the frontier
    var _frontier = game.frontier().toList().cast<int>();
    return _frontier[random.nextInt(_frontier.length)];

  }
}
