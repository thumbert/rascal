import 'dart:io';
import 'dart:math' show Random;
import 'package:demos/math/ai/connect4/move.dart';

import 'connect4.dart';

/// A strategy is associated with a player.
abstract class Strategy {
  late String name;

  /// the location of the next chip
  int nextMove(Connect4Game game);
}

// class MinmaxStrategy implements Strategy {
//   String name;
//   Random random;
//   int depth;
//
//   int _maxScore;
//
//   /// An implementation of the MinMax algorithm to level [depth].
//   MinmaxStrategy(this.depth) {
//     name = 'Minimax ${depth} strategy';
//     random = Random();
//     _maxScore = 10000;
//   }
//
//   int nextMove(Connect4Game game) {
//     return minmax(game)['column'];
//   }
//
//   Map<String, int> minmax(Connect4Game game) {
//     var bestMove = <String, int>{'utility': -50};
//     var _frontier = game.frontier().toList();
//     for (int i in _frontier) {
//       print('add chip in colum $i for player ${game.playerToMove}');
//       game.addChip(i);
//       var moveUtility = _minVal(game, 0);
//       if (moveUtility > bestMove['utility']) {
//         bestMove['utility'] = moveUtility;
//         bestMove['column'] = i;
//       }
//       game.moves.removeLast();
//     }
//     return bestMove;
//   }
//
//   int _minVal(Connect4Game game, int currentDepth) {
//     if (game.isOver())
//       return _score(game, currentDepth);
//     var _frontier = game.frontier().toList();
//     var _utility = _maxScore;
//     if (currentDepth > depth) return _utility;
//
//     for (int i in _frontier) {
//       print('add chip in colum $i for player ${game.playerToMove}');
//       game.addChip(i);
//       var moveUtility = _maxVal(game, currentDepth + 1);
//       if (moveUtility < _utility) _utility = moveUtility;
//       game.moves.removeLast();
//     }
//     return _utility;
//   }
//
//   int _maxVal(Connect4Game game, int currentDepth) {
//     if (game.isOver())
//       return _score(game, currentDepth);
//     var _frontier = game.frontier().toList();
//     var _utility = -_maxScore;
//     if (currentDepth > depth) return _utility;
//
//     for (int i in _frontier) {
//       print('add chip in colum $i for player ${game.playerToMove}');
//       game.addChip(i);
//       var moveUtility = _minVal(game, currentDepth + 1);
//       if (moveUtility > _utility) _utility = moveUtility;
//       game.moves.removeLast();
//     }
//     return _utility;
//   }
//
//   int _score(Connect4Game game, int currentDepth) {
//     var lastPlayer = game.lastPlayer();
//     if (game.isWinner(lastPlayer))
//       return _maxScore - currentDepth;
//     else if (game.isWinner(game.otherPlayer(lastPlayer)))
//       return currentDepth - _maxScore;
//     else
//       return 0;
//   }
// }

class InputStrategy implements Strategy {
  @override
  String name = 'InputStrategy';

  @override
  int nextMove(Connect4Game game) {
    print(game.board);
    var frontier = game.board.indexOfUnfilledColumns();
    print('\nOn which column you drop your chip? One of: ${frontier.join(', ')}');
    var aux = stdin.readLineSync();
    var column = int.tryParse(aux!);
    if (column == null) {
      print('Wrong input!  Play nice next time, jerk!');
      exit(0);
    }
    var move = Move(game.board.nextChip, column);
    if (!move.isValid(game.board)) {
      print('Wrong input!  Play nice next time, jerk!');
      exit(0);
    }
    return column;
  }

}

class RandomStrategy implements Strategy {
  late String name;
  late Random random;
  RandomStrategy() {
    name = 'Random strategy';
    random = Random();
  }
  int nextMove(Connect4Game game) {
    var _frontier = game.board.indexOfUnfilledColumns();
    var i = random.nextInt(_frontier.length);
    return _frontier[i];
  }
}

class Foresight1Strategy implements Strategy {
  late String name;
  late Random random;

  Foresight1Strategy() {
    name = 'Foresight 1 strategy';
    random = Random();
  }

  /// Sequentially add a chip on each available column and check if it's a
  /// winning move.  If it is, terminate.  If no winning move is found, pick
  /// randomly from the list of available columns.
  int nextMove(Connect4Game game) {
    // check that one move wins the match for player
    var frontier = game.board.indexOfUnfilledColumns();
    for (int j in frontier) {
      var move = Move(game.board.nextChip, j);
      if (move.isWinning(game.board)) {
        return j;
      }
    }
    // no winning move found, so choose randomly from the frontier
    return frontier[random.nextInt(frontier.length)];
  }
}

class Foresight2Strategy implements Strategy {
  late String name;
  late Random random;

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
    // check that one move wins the match for player (Foresight1)
    var frontier = game.board.indexOfUnfilledColumns();
    for (int j in frontier) {
      var move = Move(game.board.nextChip, j);
      if (move.isWinning(game.board)) {
        return j;
      }
    }
    /// pick a move here for this player, so you can check if the other player
    /// has a winning move
    var c0 = frontier[random.nextInt(frontier.length)];  // should do better
    var board0 = game.board.copy();
    board0.add(c0);
    var frontier0 = board0.indexOfUnfilledColumns();
    for (int j in frontier0) {
      var move = Move(board0.nextChip, j);
      if (move.isWinning(board0)) {
        return j;
      }
    }
    // no winning move found for time t+1, so it's OK to go with the random pick
    return c0;
  }
}

