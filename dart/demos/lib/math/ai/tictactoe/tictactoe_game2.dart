/// What's different that tictactoe_game.dart?
/// Code is better organized!  Finally, players can have strategies!
/// 
/// 
/// See a nice explanation here
/// https://www.neverstopbuilding.com/blog/minimax
///

library math.ai.tictactoe.tictactoe_game;

import 'dart:math' as math;

import 'package:dama/dama.dart';
import 'package:trotter/trotter.dart';

typedef Move = int;

const allMoves = <int>{0, 1, 2, 3, 4, 5, 6, 7, 8};

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
    var aliveState = state as NonTerminalState;
    for (var move in aliveState.actions()) {
      value = math.max(value, minValue(aliveState.result(move), depth));
    }
    return value;
  }

  num minValue(State state, num depth) {
    depth += 1.0;
    if (state is TerminalState) {
      return state.utility(state.lastPlayer) + depth;
    }
    num value = 999.0;
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
    });
    return actions[values.indexOfMax()];
  }
}

enum GameOutcome { winnerPlayer1, winnerPlayer2, tie }

sealed class State {
  State(this.movesPlayer1, this.movesPlayer2);
  // The indexing is from top left by row.  That is, using matrix notation for
  // the cells:
  //  - element [1,1] has index 0,
  //  - element [1,2] has index 1,
  //  - element [1,3] has index 2,
  //  - element [2,1] has index 3,
  // etc.
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
    var board = [
      [' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' '],
      [' ', ' ', ' ', ' '],
    ];
    for (var m in movesPlayer1) {
      board[m ~/ 3][m % 3] = 'X';
    }
    for (var m in movesPlayer2) {
      board[m ~/ 3][m % 3] = 'O';
    }
    return board.map((e) => e.join('')).join('\n');
  }

  String toString() {
    return board() +
        '\nmoves Player1: ${movesPlayer1}'
            '\nmoves Player2: ${movesPlayer2}';
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
    [0, 3, 6],
    [0, 4, 8],
    [1, 4, 7],
    [2, 5, 8],
    [2, 4, 6],
    [3, 4, 5],
    [6, 7, 8],
  ];
}

class TerminalState extends State {
  TerminalState(super.movesPlayer1, super.movesPlayer2);

  num utility(Player player) {
    if (movesPlayer1.length + movesPlayer2.length == 9) {
      // It could happen that the first player has won in the last move,
      // so construct the previous non-terminal move and check
      var lastMove = movesPlayer1.last;
      var previous = NonTerminalState(movesPlayer1.sublist(0, 4), movesPlayer2);
      if (previous.isWinningMove(lastMove)) {
        return player == Player.one ? 1.0 : -1.0;
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
      return newMovesPlayer1.length + newMovesPlayer2.length == 9
          ? TerminalState(newMovesPlayer1, newMovesPlayer2)
          : NonTerminalState(newMovesPlayer1, newMovesPlayer2);
    }
  }
}






