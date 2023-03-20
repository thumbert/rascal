library math.ai.windmill_windmill_game;

import 'dart:math';

import 'package:collection/collection.dart';
import 'package:trotter/trotter.dart';

enum Player { one, two }

enum GameOutcome { winnerPlayer1, winnerPlayer2, tie }

abstract class GameStatus {
  static final live = _GameLive();
  static final over = _GameOver();
}

class _GameLive extends GameStatus {
  int? getNextMove(Strategy strategy) {
    return strategy.getNextMove();
  }
}

class _GameOver extends GameStatus {
  /// Calculate the utility of the last move (from the point of view of the
  /// first player.)
  /// This function should be called ONLY when the game is over!
  /// Return [1, 0, -1] depending if Player.one won, tied, or lost
  /// Give higher utility to the move that makes you win in fewer moves
  num utility(WindmillGame game) {
    var expr = game.lastPlayer == Player.one
        ? 1 / game.moves.length
        : -1 / game.moves.length;
    if (game.moves.length != 24) {
      // last player has won while there are still empty spots on the board
      return expr;
    } else {
      // it could also be a tie if all spots have been filled
      return game.hasLastPlayerWon() ? expr : 0;
    }
  }
}

abstract class Strategy {
  late Game game;
  int? getNextMove();
}

class MiniMax extends Strategy {
  MiniMax({required this.game, required this.maxDepth});

  final WindmillGame game;
  final int maxDepth;

  int? getNextMove() {
    if (game.gameStatus() == GameStatus.over) {
      print('GAME OVER, ${game.lastPlayer} won!');
      return null;
    } else {
      return _minimax();
    }
  }

  void addMove(int move) {
    if (game.gameStatus() == GameStatus.live) {
      game.moves.add(move);
    }
  }

  MiniMax copyWith({List<int>? moves}) {
    return MiniMax(game: WindmillGame(moves ?? <int>[]), maxDepth: maxDepth);
  }

  /// Calculate the minimax decision.  Return the best move for Player.one
  /// Using the alpha-beta pruning as explained in Norvig,
  /// Artificial Intelligence, ed.3, page 172
  int _minimax() {
    var actions = game.actions().toList();
    // actions = [23];
    var scores = <num>[];
    for (var i = 0; i < actions.length; i++) {
      var newMoves = [...game.moves, actions[i]];
      scores.add(_minValue(WindmillGame(newMoves), -1000, 1000, depth: 0));
    }

    // print(game.lastPlayer);
    num value;
    if (game.lastPlayer == Player.one) {
      value = scores.min;
    } else {
      value = scores.max;
    }
    /// Pick the node that has matches the value.  Sometimes, there are
    /// several nodes with the same value (the algo doesn't know what to do.)
    /// Then, pick a node on a diagonal.
    var indexes = scores
        .whereIndexed((index, e) => e == value)
        .mapIndexed((index, e) => index)
        .toList();
    if (indexes.length == 1) return actions[indexes.first];
    else {
      /// pick a random node one from a diagonal
      var diag = indexes.where((e) => WindmillGame.isDiagonalNode(e)).toList();
      if (diag.isNotEmpty) {
        diag.shuffle();
        return diag.first;
      } else {
        return actions[indexes.first];
      }
    }
  }

  num _minValue(WindmillGame game, num alpha, num beta, {required int depth}) {
    if (game.gameStatus() == GameStatus.over) {
      return GameStatus.over.utility(game);
    }
    if (depth == maxDepth) return -1000;
    num value = 1000;
    depth = depth + 1;
    for (var action in game.actions()) {
      var newMoves = [...game.moves, action];
      value = min(
          value, _maxValue(WindmillGame(newMoves), alpha, beta, depth: depth));
      // print(newMoves);
      // print('Value: $value');
      if (value <= alpha) return value;
      beta = min(beta, value);
    }
    return value;
  }

  num _maxValue(WindmillGame game, num alpha, num beta, {required int depth}) {
    if (game.gameStatus() == GameStatus.over) {
      return GameStatus.over.utility(game);
    }
    if (depth == maxDepth) return 1000;
    num value = -1000;
    depth = depth + 1;
    for (var action in game.actions()) {
      var newMoves = [...game.moves, action];
      value = max(
          value, _minValue(WindmillGame(newMoves), alpha, beta, depth: depth));
      // print(value);
      if (value >= beta) return value;
      alpha = max(alpha, value);
    }
    return value;
  }
}

abstract class Game {
  late List<int> moves;

  /// Return the possible moves
  Set<int> actions();

  /// Return the current game status
  GameStatus gameStatus();

  bool hasLastPlayerWon();

  Player getLastPlayer();
  Player getNextPlayer();
}

class WindmillGame extends Game {
  /// The indexing of the moves list is as follows:
  /// <p>0, 1, 2 - are the right horizontal points along the X axis counting
  /// from the inside square to the outside square
  /// <p>3, 4, 5 - are the diagonal points in quadrant 1, counting from inside out
  /// <p>6, 7, 9 - are the vertical points along the Y axis, counting from inside out
  /// <p>9, 10, 11 - are the diagonal points in quadrant 2, counting from inside out,
  /// etc,
  ///
  /// the list of moves (for both players)
  WindmillGame(List<int> moves) {
    this.moves = moves;
  }

  /// Construct a game from individual moves.
  static WindmillGame fromMoves(List<int> player1, List<int> player2) {
    var diff = player1.length - player2.length;
    if (diff != 0 && diff != 1) {
      throw ArgumentError('Incorrect inputs!');
    }
    if (player1.length != player1.toSet().length) {
      throw ArgumentError('Moves for Player 1 has duplicates.');
    }
    if (player2.length != player2.toSet().length) {
      throw ArgumentError('Moves for Player 2 has duplicates.');
    }
    if ([...player1, ...player2].length != {...player1, ...player2}.length) {
      throw ArgumentError(
          'Some moves appear both among Player 1 & Player 2 moves!');
    }

    var moves = <int>[];
    var game = WindmillGame(moves);
    for (var i = 0; i < player2.length; i++) {
      moves.add(player1[i]);
      game = WindmillGame(moves);
      if (game.hasLastPlayerWon()) {
        throw ArgumentError('Game is over with moves: $moves');
      }
      moves.add(player2[i]);
      game = WindmillGame(moves);
      if (game.hasLastPlayerWon()) {
        throw ArgumentError('Game is over with moves: $moves');
      }
    }
    if (diff == 1) {
      moves.add(player1.last);
      game = WindmillGame(moves);
      if (game.hasLastPlayerWon()) {
        throw ArgumentError('Game is over with moves: $moves');
      }
    }
    return game;
  }

  Player getLastPlayer() => moves.length % 2 == 0 ? Player.two : Player.one;

  Player getNextPlayer() => moves.length % 2 == 0 ? Player.one : Player.two;

  /// Return the set of possible moves for the next player
  Set<int> actions() {
    return _allMoves..removeAll(moves);
  }

  /// Return game status
  GameStatus gameStatus() {
    if (moves.length < 5) return GameStatus.live;
    if (moves.length == 24) return GameStatus.over;
    return hasLastPlayerWon() ? GameStatus.over : GameStatus.live;
  }

  bool hasLastPlayerWon() {
    var playerIndex = (moves.length - 1) % 2;
    var playerMoves =
        moves.whereIndexed((index, e) => index % 2 == playerIndex).toList();
    if (playerMoves.length < 3) return false;
    var combinations =
        Combinations(2, playerMoves.sublist(0, playerMoves.length - 1));
    for (var combination in combinations()) {
      var ms = combination..add(moves.last);
      ms.sort();
      if (isWinningPosition(ms[0], ms[1], ms[2])) {
        return true;
      }
    }
    return false;
  }

  Player get lastPlayer => moves.length % 2 == 0 ? Player.two : Player.one;

  Player get nextPlayer => moves.length % 2 == 0 ? Player.one : Player.two;

  /// The arguments p0, p1, p2 need to be ordered, and >=0, <=23.
  bool isWinningPosition(int p0, int p1, int p2) {
    var wp = _winningPositions.firstWhere(
        (e) => e[0] == p0 && e[1] == p1 && e[2] == p2,
        orElse: () => <int>[]);
    if (wp.isNotEmpty) return true;
    return false;
  }

  /// Check if a node is on the diagonal
  static bool isDiagonalNode(int i) => _diagonals.contains(i);

  static final _diagonals = const {3, 4, 5, 9, 10, 11, 15, 16, 17, 21, 22, 23};

  final _winningPositions = const [
    [0, 1, 2],
    [0, 3, 21],
    [1, 4, 22],
    [2, 5, 23],
    [3, 4, 5],
    [3, 6, 9],
    [4, 7, 10],
    [5, 8, 11],
    [6, 7, 8],
    [9, 10, 11],
    [9, 12, 15],
    [10, 13, 16],
    [11, 14, 17],
    [12, 13, 14],
    [15, 16, 17],
    [15, 18, 21],
    [16, 19, 22],
    [17, 20, 23],
    [18, 19, 20],
    [21, 22, 23],
  ];

  final _allMoves = List.generate(24, (i) => i).toSet();
}

