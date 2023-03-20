library math.ai.tictactoe.tictactoe_game;

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:trotter/trotter.dart';

enum Player { one, two }

enum GameOutcome { winnerPlayer1, winnerPlayer2, tie}

abstract class GameStatus {
  static final live = _GameLive(); 
  static final over = _GameOver();
}
class _GameLive extends GameStatus {}
class _GameOver extends GameStatus {
  /// Calculate the utility of the last move (from the point of view of the
  /// first player.)
  /// This function should be called ONLY when the game is over!
  /// Return [1, 0, -1] depending if Player.one won, tied, or lost
  /// Give higher utility to the move that makes you win in fewer moves
  num utility(TicTacToeGame game) {
    var expr = game.lastPlayer == Player.one ? 1/game.moves.length : -1/game.moves.length;
    if (game.moves.length != 9) {
      // last player has won while there are still empty spots on the board
      return expr;
    } else {
      // it could also be a tie if all spots have been filled
      return game.hasLastPlayerWon() ? expr : 0;
    }
  }
}

class TicTacToeGame {
  TicTacToeGame(this.moves);

  /// A list of moves made in this game, starting with Player.one.
  /// The list is empty list if game is starting.
  /// The list can't be bigger than 9 elements. The indexing is from top left
  /// by row, e.g. [1,1] is index 0, [1,2] is index 1, ... [2,1] is index 3, etc.
  final List<int> moves;

  /// Calculate the minimax decision.  Return the best move for Player.one
  /// Using the alpha-beta pruning as explained in Norvig,
  /// Artificial Intelligence, ed.3, page 172
  static int minimax(TicTacToeGame game) {
    var actions = game.actions().toList();
    var scores = <num>[];
    for (var i = 0; i < actions.length; i++) {
      var newMoves = [...game.moves, actions[i]];
      scores.add(_minValue(TicTacToeGame(newMoves), -1000, 1000));
    }
    var maxValue = scores.max;
    var ind = scores.indexWhere((e) => e == maxValue);
    return actions[ind];
  }

  /// This is what Player.two does
  static int maximin(TicTacToeGame game) {
    var actions = game.actions().toList();
    var scores = <num>[];
    for (var i = 0; i < actions.length; i++) {
      var newMoves = [...game.moves, actions[i]];
      scores.add(_maxValue(TicTacToeGame(newMoves), -1000, 1000));
    }
    var minValue = scores.min;
    var ind = scores.indexWhere((e) => e == minValue);
    return actions[ind];
  }


  static num _minValue(TicTacToeGame game, num alpha, num beta) {
    if (game.gameStatus() == GameStatus.over) {
      return GameStatus.over.utility(game);
    }
    num value = 1000;
    for (var action in game.actions()) {
      var newMoves = [...game.moves, action];
      value = min(value, _maxValue(TicTacToeGame(newMoves), alpha, beta));
      if (value <= alpha) return value;
      beta = min(beta, value);
    }
    return value;
  }

  static num _maxValue(TicTacToeGame game, num alpha, num beta) {
    if (game.gameStatus() == GameStatus.over) {
      return GameStatus.over.utility(game);}
    num value = -1000;
    for (var action in game.actions()) {
      var newMoves = [...game.moves, action];
      value = max(value, _minValue(TicTacToeGame(newMoves), alpha, beta));
      if (value >= beta) return value;
      alpha = max(alpha, value);
    }
    return value;
  }

  /// Return the set of possible moves for the next player
  Set<int> actions() {
    return {0, 1, 2, 3, 4, 5, 6, 7, 8}.difference(moves.toSet());
  }

  num utility() {
    var expr = lastPlayer == Player.one ? 1/moves.length : -1/moves.length;
    if (moves.length != 9) {
      // last player has won while there are still empty spots on the board
      return expr;
    } else {
      // it could also be a tie if all spots have been filled
      return hasLastPlayerWon() ? expr : 0;
    }
  }

  /// Return game status
  GameStatus gameStatus() {
    if (moves.length < 5) return GameStatus.live;
    if (moves.length == 9) return GameStatus.over;
    return hasLastPlayerWon() ? GameStatus.over : GameStatus.live;
  }

  bool hasLastPlayerWon() {
    var playerIndex = (moves.length - 1) % 2;
    var playerMoves =
        moves.whereIndexed((index, e) => index % 2 == playerIndex).toList();
    // generate all combinations that include the last move by this player
    var combinations =
        Combinations(2, playerMoves.sublist(0, playerMoves.length - 1));
    for (var combination in combinations()) {
      var ms = combination..add(moves.last);
      ms.sort();
      if (_isWinningPosition(ms[0], ms[1], ms[2])) {
        return true;
      }
    }
    return false;
  }

  Player get lastPlayer => moves.length % 2 == 0 ? Player.two : Player.one;

  Player get nextPlayer => moves.length % 2 == 0 ? Player.one : Player.two;

  /// Player.one is 'X', Player.two is 'O'.
  String toString() {
    var board = [
      [' ', ' ', ' ', '|'],
      [' ', ' ', ' ', '|'],
      [' ', ' ', ' ', '|'],
    ];
    for (var i = 0; i < moves.length; i++) {
      var m = moves[i];
      var glypy = i % 2 == 0 ? 'X' : 'O';
      board[m ~/ 3][m % 3] = glypy;
    }
    return board.map((e) => e.join('')).join('\n');
  }

  /// The arguments p0, p1, p2 need to be ordered, and >=0, <=8.
  bool _isWinningPosition(int p0, int p1, int p2) {
    var wp = _allWinningPositions.firstWhere(
        (e) => e[0] == p0 && e[1] == p1 && e[2] == p2,
        orElse: () => <int>[]);
    if (wp.isNotEmpty) return true;
    return false;
  }

  final _allWinningPositions = const [
    [0, 1, 2],
    [0, 3, 6],
    [0, 4, 8],
    [1, 4, 7],
    [2, 5, 8],
    [2, 4, 6],
    [3, 4, 5],
    [6, 7, 8],
  ];
}
