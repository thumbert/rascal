import 'dart:math' show Random;
import 'connect4.dart';

/// A strategy is associated with a player.
abstract class Strategy {
  String name;

  /// the location of the next chip
  int nextMove(Connect4Game game);
}

class MinmaxStrategy implements Strategy {
  String name;
  Random random;
  int depth;

  int _maxScore;

  /// An implementation of the MinMax algorithm to level [depth].
  MinmaxStrategy(this.depth) {
    name = 'Minimax ${depth} strategy';
    random = Random();
    _maxScore = 10000;
  }

  int nextMove(Connect4Game game) {
    return minmax(game)['column'];
  }

  Map<String, int> minmax(Connect4Game game) {
    var bestMove = <String, int>{'utility': -50};
    var _frontier = game.frontier().toList();
    for (int i in _frontier) {
      print('add chip in colum $i for player ${game.playerToMove}');
      game.addChip(i);
      var moveUtility = _minVal(game, 0);
      if (moveUtility > bestMove['utility']) {
        bestMove['utility'] = moveUtility;
        bestMove['column'] = i;
      }
      game.moves.removeLast();
    }
    return bestMove;
  }

  int _minVal(Connect4Game game, int currentDepth) {
    if (game.isOver())
      return _score(game, currentDepth);
    var _frontier = game.frontier().toList();
    var _utility = _maxScore;
    if (currentDepth > depth) return _utility;

    for (int i in _frontier) {
      print('add chip in colum $i for player ${game.playerToMove}');
      game.addChip(i);
      var moveUtility = _maxVal(game, currentDepth + 1);
      if (moveUtility < _utility) _utility = moveUtility;
      game.moves.removeLast();
    }
    return _utility;
  }

  int _maxVal(Connect4Game game, int currentDepth) {
    if (game.isOver())
      return _score(game, currentDepth);
    var _frontier = game.frontier().toList();
    var _utility = -_maxScore;
    if (currentDepth > depth) return _utility;

    for (int i in _frontier) {
      print('add chip in colum $i for player ${game.playerToMove}');
      game.addChip(i);
      var moveUtility = _minVal(game, currentDepth + 1);
      if (moveUtility > _utility) _utility = moveUtility;
      game.moves.removeLast();
    }
    return _utility;
  }

  int _score(Connect4Game game, int currentDepth) {
    var lastPlayer = game.lastPlayer();
    if (game.isWinner(lastPlayer))
      return _maxScore - currentDepth;
    else if (game.isWinner(game.otherPlayer(lastPlayer)))
      return currentDepth - _maxScore;
    else
      return 0;
  }
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
