library math.ai.connect4.connect4_game;

import 'dart:io';
import 'dart:math' as math;

import 'package:dama/dama.dart';
import 'package:trotter/trotter.dart';

typedef Move = int;

const allMoves = <int>{
  0,
  1,
  2,
  3,
  4,
  5,
  6,
  7,
  8,
  9,
  10,
  11,
  12,
  13,
  14,
  15,
  16,
  17,
  18,
  19,
  20,
  21,
  22,
  23
};

enum Player { one, two }

sealed class Players {
  late final Strategy strategy;
  List<Duration> timings = <Duration>[];
}

final class PlayerOne extends Players {
  PlayerOne(Strategy strategy) {
    this.strategy = strategy;
  }
  final String name = 'Player One';
}

final class PlayerTwo extends Players {
  PlayerTwo(Strategy strategy) {
    this.strategy = strategy;
  }
  final String name = 'Player Two';
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
    var sw = Stopwatch();
    while (state is NonTerminalState) {
      var nextPlayer = state.nextPlayer == Player.one ? p1 : p2;
      sw.reset();
      sw.start();
      var nextMove = nextPlayer.strategy.nextMove(state);
      sw.stop();
      nextPlayer.timings.add(sw.elapsed);
      state = state.result(nextMove);
    }
    return state as TerminalState;
  }
}

mixin Strategy {
  Move nextMove(State state);
}

class ManualStrategy extends Object with Strategy {
  ManualStrategy({List<Move>? presetMoves}) {
    this.preset = presetMoves ?? <Move>[];
  }
  late final List<Move> preset;

  @override
  Move nextMove(State state) {
    var moves = state.nextPlayer == Player.one
        ? state.movesPlayer1
        : state.movesPlayer2;
    if (moves.length < preset.length) {
      return preset[moves.length];
    }

    int number = 0;
    while (number < 1 || number > 7) {
      print('------------------------------------------');
      print('Board');
      print(state);
      print('Enter column number (1-7) and press Enter:');
      var numberT = int.tryParse(stdin.readLineSync()!);
      if (numberT != null) number = numberT;
    }
    return (number - 1) * 6 + state.height[number - 1];
  }
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
  MinMaxStrategy({required this.maxDepth});
  final int maxDepth;

  // From which player point of view to calculate the terminal utility
  late Player currentPlayer;

  num maxValue(State state, num depth) {
    depth += 1.0;
    if (state is TerminalState) return -1001 + depth;
    // if (state is TerminalState) return state.utility(currentPlayer) - depth;
    num value = -999.0;
    if (depth > maxDepth) return value; // bail out
    var aliveState = state as NonTerminalState;
    for (var move in aliveState.actions()) {
      value = math.max(value, minValue(aliveState.result(move), depth));
    }
    return value;
  }

  num minValue(State state, num depth) {
    depth += 1.0;
    if (state is TerminalState) return 1001 - depth;
    // if (state is TerminalState) return state.utility(state.lastPlayer) + depth;
    num value = 999.0;
    if (depth > maxDepth) return value; // bail out
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
    // print(state);
    // print('Moving to: ${actions[values.indexOfMax()]}');
    return actions[values.indexOfMax()];
  }
}

enum GameOutcome { winnerPlayer1, winnerPlayer2, tie }

sealed class State {
  /// The indexing of the moves list is as follows:
  /// <p>0, 1, 2, 3, 4, 5,      - the 1st column,
  /// <p>6, 7, 8, 9, 10, 11,    - the 2nd column,
  /// ...
  /// <p>36, 37, 38, 39, 40, 41 - the 7th column
  /// etc,
  ///
  State(this.movesPlayer1, this.movesPlayer2, this.height);
  final List<Move> movesPlayer1;
  final List<Move> movesPlayer2;
  final List<int> height;

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
      out[m % 6][m ~/ 6] = 'X';
    }
    for (var m in movesPlayer2) {
      out[m % 6][m ~/ 6] = 'O';
    }
    return out.map((row) => row.join()).toList().reversed.skip(1).join('\n') +
        '\n1234567\n';
  }

  @override
  String toString() {
    return board() +
        '\nmoves Player1: ${movesPlayer1.map((e) => e.toString().padLeft(2)).toList()}'
            '\nmoves Player2: ${movesPlayer2.map((e) => e.toString().padLeft(2)).toList()}';
  }

  /// Check if this next move ends the game!
  bool isWinningMove(Move m) {
    final existingMoves =
        (nextPlayer == Player.one) ? movesPlayer1 : movesPlayer2;
    if (existingMoves.length < 3) return false;
    // generate all possible 3 stone combinations of this player
    var combinations = Combinations(3, existingMoves);
    for (var combination in combinations()) {
      // add this move
      var ms = combination..add(m);
      ms.sort();
      if (_isWinningPosition(ms[0], ms[1], ms[2], ms[3])) {
        return true;
      }
    }
    return false;
  }

  /// The arguments m0, m1, m2, m3 need to be ordered, and >=0, <42.
  bool _isWinningPosition(int m0, int m1, int m2, int m3) {
    final d10 = m1 - m0;
    final d21 = m2 - m1;
    final d32 = m3 - m2;
    if (d10 == d21 && d21 == d32) {
      /// horizontal
      if (d10 == 6) return true;
      // vertical: you may have (21,22,23,24) which is not a winning position
      if (d10 == 1 && m0 % 6 < 3) return true;
      // slope+1: (3,10,17,24) is not a winning position
      if (d10 == 7 && m0 % 6 < 3) return true;
      // slope-1: (2,7,12,17) is not a winning position
      if (d10 == 5 && m0 % 6 > 2) return true;
    }
    return false;
  }

  /// A board 'literal'. For example:
  /// .......
  /// .......
  /// ..X.XO.
  /// .OXOXO.
  ///
  /// Empty rows are ignored.
  /// Pretty inefficient to parse, but convenient to look at ...
  /// Note that the moves may not be in the order they were
  /// actually entered.  Prefer to use [State.fromDigits].
  factory State.fromString(String x) {
    final rows = x
        .split('\n')
        .map((e) => e.trim())
        .toList()
        .reversed
        .map((e) => e.split(''))
        .where((e) => e.isNotEmpty)
        .toList();
    // separate the two player moves
    var moves1 = <int>[];
    var moves2 = <int>[];
    var height = List.filled(7, 0);
    // State state = NonTerminalState(<int>[], <int>[], List.filled(7, 0));
    for (var i = 0; i < rows.length; i++) {
      var row = rows[i];
      if (row.length != 7) {
        throw ArgumentError('Wrong board row: $row');
      }
      if (rows.every((e) => e == '.')) continue;
      for (var j = 0; j < 7; j++) {
        if (row[j] == 'X') {
          moves1.add(j * 6 + i);
          height[j] += 1;
        } else if (row[j] == 'O') {
          moves2.add(j * 6 + i);
          height[j] += 1;
        } else if (row[j] != '.') {
          throw ArgumentError('Wrong board row $row');
        }
      }
    }
    if (moves1.length - moves2.length > 1) {
      throw ArgumentError('Player 1 has too many moves!');
    } else if (moves2.length > moves1.length) {
      throw ArgumentError('Player 2 can\'t have move moves than Player 1!');
    }
    return NonTerminalState(moves1, moves2, height);
  }

  /// From a string of digits, e.g. '4455' is the board
  /// ...OO..
  /// ...XX..
  factory State.fromDigits(String x) {
    var xs = x.split('').map((e) => int.parse(e)).toList();
    State state = NonTerminalState(<int>[], <int>[], List.filled(7, 0));
    for (var i = 0; i < xs.length; i++) {
      var move = (xs[i] - 1) * 6 + state.height[xs[i] - 1];
      // if (i >= 13) {
      //   print(state);
      //   print('height: ${state.height}');
      //   print('\n xs[$i]=${xs[i]}, nextMove: $move, nextPlayer: ${state.nextPlayer}');
      //   print('\n');
      // }
      state = (state as NonTerminalState).result(move);
    }
    return state;
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
  TerminalState(super.movesPlayer1, super.movesPlayer2, super.height);

  num utility(Player player) {
    if (movesPlayer1.length + movesPlayer2.length == 42) {
      // It could happen that the second player has won in the last move,
      // so construct the previous non-terminal move and check
      var lastMove = movesPlayer2.last;
      var lastHeight = [...height]; // FIXME: <---
      var previous = NonTerminalState(
          movesPlayer1, movesPlayer2.sublist(0, 20), lastHeight);
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
  NonTerminalState(super.movesPlayer1, super.movesPlayer2, super.height) {
    assert(height.length == 7);
  }

  static NonTerminalState empty() {
    return NonTerminalState(<Move>[], <Move>[], List.filled(7, 0));
  }

  @override
  Set<Move> actions() {
    var out = <int>{};
    for (var i = 0; i < 7; i++) {
      if (height[i] < 6) {
        out.add(i * 6 + height[i]);
      }
    }
    return out;
  }

  /// Transition model, how you move from one State to another
  State result(Move m) {
    var newMovesPlayer1 = [...movesPlayer1];
    var newMovesPlayer2 = [...movesPlayer2];
    if (nextPlayer == Player.one) {
      newMovesPlayer1.add(m);
    } else {
      newMovesPlayer2.add(m);
    }
    var newHeight = [...height];
    newHeight[m ~/ 6] += 1;

    if (isWinningMove(m)) {
      return TerminalState(newMovesPlayer1, newMovesPlayer2, newHeight);
    } else {
      /// first, check if it's a tie
      return newMovesPlayer1.length + newMovesPlayer2.length == 42
          ? TerminalState(newMovesPlayer1, newMovesPlayer2, newHeight)
          : NonTerminalState(newMovesPlayer1, newMovesPlayer2, newHeight);
    }
  }
}

/// the empty board
final boardE = """.......
.......
.......
.......
.......
.......
"""
    .split('\n')
    .map((e) => e.split(''))
    .toList();
