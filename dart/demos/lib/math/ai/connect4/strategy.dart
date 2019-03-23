
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

  int nextMove(Connect4Game game) {
    var _frontier = game.frontier().toList();
    var i = random.nextInt(_frontier.length);
    return _frontier[i];
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
  /// (if possible).
  /// If the column is filled, pick another column.
  int nextMove(Connect4Game game) {
    // check that one move wins the match for player
    var frontier = game.frontier();
    for (int j in frontier) {
      game.addChip(j);
      if (game.isWinner(game.lastPlayer())) {
        /// found a winning move
        game.moves.removeLast();
        return j;
      }
      game.moves.removeLast();
    }

    // no winning move found, so choose randomly from the frontier
    var _frontier = game.frontier().toList();
    return _frontier[random.nextInt(_frontier.length)];
  }
}


class Foresight2Strategy implements Strategy {
  String name;
  Random random;

  /// Able to see if the opponent has 3 in a row and block him.
  Foresight2Strategy() {
    name = 'Foresight 2 strategy';
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
      if (game.isWinner(game.lastPlayer())) {
        /// found a winning move
        game.moves.removeLast();
        return j;
      } else if (game.isWinner(game.otherPlayer(game.lastPlayer()))) {
        /// need to block a winning move by the opponent
        game.moves.removeLast();
        return j;
      }
      game.moves.removeLast();
    }

    // no winning move found, so choose randomly from the frontier
    var _frontier = game.frontier().toList();
    return _frontier[random.nextInt(_frontier.length)];
  }
}
