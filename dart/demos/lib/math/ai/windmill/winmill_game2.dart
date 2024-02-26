library math.ai.windmill_windmill_game;

import 'dart:math' as math;

import 'package:dama/dama.dart';
import 'package:trotter/trotter.dart';

typedef Move = int;

const allMoves = <int>{0, 1, 2, 3, 4, 5, 6, 7, 8, 
  9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23};

enum Player { one, two }

sealed class Players {}

final class PlayerOne extends Players {
  PlayerOne(this.strategy);
  final String name = 'Player One';
  final Strategy strategy;
}

final class PlayerTwo extends Players {
  PlayerTwo(this.strategy);
  final String name = 'Player Two';
  final Strategy strategy;
}

sealed class TwoPlayerGame {
  TwoPlayerGame(this.p1, this.p2);
  final PlayerOne p1;
  final PlayerTwo p2;
}

class Game extends TwoPlayerGame {
  Game(
    PlayerOne p1,
    PlayerTwo p2,
    this.initialState,
  ) : super(p1, p2);

  final State initialState;

  /// play it to the end
  TerminalState play() {
    if (initialState is TerminalState) {
      throw StateError('Game is already finished!');
    }
    var state = initialState;
    while (state is NonTerminalState) {
      var nextMove = (state.nextPlayer == Player.one)
          ? p1.strategy.nextMove(state)
          : p2.strategy.nextMove(state);
      state = state.result(nextMove);
    }
    return state as TerminalState;
  }
}

mixin Strategy {
  Move nextMove(State state);
}

/// A random player, my kind of guy!
class RandomStrategy extends Object with Strategy {
  static final rand = math.Random();
  @override
  Move nextMove(State state) {
    var actions = state.actions().toList();
    return actions[rand.nextInt(actions.length)];
  }
}

/// Sophisticated, over-thinker, not fun to be around!
/// Uses a depth argument > 0 to prolong the inevitable defeat (pretend that 
/// you don't see the writing on the wall.) 
class MinMaxStrategy extends Object with Strategy {
  static final rand = math.Random();

  // From which player point of view to calculate the terminal utility
  late Player currentPlayer;

  num maxValue(State state, num depth) {
    depth += 1.0;
    if (state is TerminalState) return state.utility(currentPlayer) + depth;
    num value = -999.0;
    if (depth > 4) return value;  // bail out
    var aliveState = state as NonTerminalState;
    for (var move in aliveState.actions()) {
      value = math.max(value, minValue(aliveState.result(move), depth));
    }
    return value;
  }

  num minValue(State state, num depth) {
    depth += 1.0;
    if (state is TerminalState) return state.utility(state.lastPlayer) + depth;
    num value = 999.0;
    if (depth > 4) return value;  // bail out
    var aliveState = state as NonTerminalState;
    for (var move in aliveState.actions()) {
      value = math.min(value, maxValue(aliveState.result(move), depth));
    }
    return value;
  }

  @override
  Move nextMove(State state) {
    currentPlayer = state.nextPlayer;
    var actions = state.actions().toList();
    num depth = 0.0;
    var values = actions.map((move) {
      var newState = (state as NonTerminalState).result(move);
      return minValue(newState, depth);
    }).toList();
    print(state);
    print('Moving to: ${actions[values.indexOfMax()]}');
    return actions[values.indexOfMax()];
  }
}

enum GameOutcome { winnerPlayer1, winnerPlayer2, tie }

sealed class State {
  /// The indexing of the moves list is as follows:
  /// <p>0, 1, 2 - are the right horizontal points along the X axis counting
  /// from the inside square to the outside square
  /// <p>3, 4, 5 - are the diagonal points in quadrant 1, counting from inside out
  /// <p>6, 7, 9 - are the vertical points along the Y axis, counting from inside out
  /// <p>9, 10, 11 - are the diagonal points in quadrant 2, counting from inside out,
  /// etc,
  ///
  State(this.movesPlayer1, this.movesPlayer2);
  final List<Move> movesPlayer1;
  final List<Move> movesPlayer2;

  /// Remaining legal moves from this state
  Set<Move> actions();

  Player get lastPlayer =>
      (movesPlayer1.length > movesPlayer2.length) ? Player.one : Player.two;

  Player get nextPlayer =>
      (movesPlayer1.length == movesPlayer2.length) ? Player.one : Player.two;

  /// Player.one is 'X', Player.two is 'O'.
  String board() {
    var out = [...boardE];
    for (var m in movesPlayer1) {
      out[bc[m]!.$1][bc[m]!.$2] = 'X';
    }
    for (var m in movesPlayer2) {
      out[bc[m]!.$1][bc[m]!.$2] = 'O';
    }
    return out.map((row) => row.join()).join('\n');
  }

  String toString() {
    return board() +
        '\nmoves Player1: ${movesPlayer1.map((e) => e.toString().padLeft(2)).toList()}'
            '\nmoves Player2: ${movesPlayer2.map((e) => e.toString().padLeft(2)).toList()}';
  }

  /// The arguments p0, p1, p2 need to be ordered, and >=0, <=8.
  bool _isWinningPosition(int p0, int p1, int p2) {
    var wp = allWinningPositions.firstWhere(
        (e) => e[0] == p0 && e[1] == p1 && e[2] == p2,
        orElse: () => <int>[]);
    if (wp.isNotEmpty) return true;
    return false;
  }

  /// Check if this next move ends the game!
  bool isWinningMove(Move m) {
    final existingMoves =
        (nextPlayer == Player.one) ? movesPlayer1 : movesPlayer2;
    if (existingMoves.length < 2) return false;
    // generate all combinations that include the last move by this player
    var combinations = Combinations(2, existingMoves);
    for (var combination in combinations()) {
      var ms = combination..add(m);
      ms.sort();
      if (_isWinningPosition(ms[0], ms[1], ms[2])) {
        return true;
      }
    }
    return false;
  }

  final allWinningPositions = const [
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
}

class TerminalState extends State {
  TerminalState(super.movesPlayer1, super.movesPlayer2);

  num utility(Player player) {
    if (movesPlayer1.length + movesPlayer2.length == 24) {
      // It could happen that the second player has won in the last move,
      // so construct the previous non-terminal move and check
      var lastMove = movesPlayer2.last;
      var previous = NonTerminalState(movesPlayer1, movesPlayer2.sublist(0, 10));
      if (previous.isWinningMove(lastMove)) {
        return player == Player.two ? 1.0 : -1.0;
      } else {
        // All positions are filled and nobody won.  It's a tie!
        return 0.5;
      }
    } else {
      if (movesPlayer1.length > movesPlayer2.length) {
        return player == Player.one ? 1.0 : -1.0;
      } else {
        return player == Player.one ? -1.0 : 1.0;
      }
    }
  }

  @override
  Set<Move> actions() => <Move>{};
}

class NonTerminalState extends State {
  NonTerminalState(super.movesPlayer1, super.movesPlayer2);

  @override
  Set<Move> actions() =>
      allMoves.difference({...movesPlayer1, ...movesPlayer2});

  /// Transition model, how you move from one State to another
  State result(Move m) {
    var newMovesPlayer1 = [...movesPlayer1];
    var newMovesPlayer2 = [...movesPlayer2];
    if (nextPlayer == Player.one) {
      newMovesPlayer1.add(m);
    } else {
      newMovesPlayer2.add(m);
    }

    if (isWinningMove(m)) {
      return TerminalState(newMovesPlayer1, newMovesPlayer2);
    } else {
      /// first, check if it's a tie
      /// TODO: don't understand this part ...
      return newMovesPlayer1.length + newMovesPlayer2.length == 24
          ? TerminalState(newMovesPlayer1, newMovesPlayer2)
          : NonTerminalState(newMovesPlayer1, newMovesPlayer2);
    }
  }
}

/// the empty board
final boardE = """
.-----------.-----------.
|  .--------.--------.  |
|  |  .-----.-----.  |  |
|  |  |           |  |  |
|  |  |           |  |  |
.  .  .           .  .  .
|  |  |           |  |  |
|  |  |           |  |  |
|  |  .-----.-----.  |  |
|  .--------.--------.  |
.-----------.-----------.
""".split('\n').map((e) => e.split('')).toList();

/// Map a move to board coordinates.
final bc = <Move,(int row, int col)>{
  0: (5,18),
  1: (5,21),
  2: (5,24),
  //
  3: (2,18),
  4: (1,21),
  5: (0,24),
  //
  6: (2,12),
  7: (1,12),
  8: (0,12),
  //
  9: (2,6),
  10: (1,3),
  11: (0,0),
  //
  12: (5,6),
  13: (5,3),
  14: (5,0),
  //
  15: (8,6),
  16: (9,3),
  17: (10,0),
  //
  18: (8,12),
  19: (9,12),
  20: (10,12),
  //
  21: (8,18),
  22: (9,21),
  23: (10,24),
};

