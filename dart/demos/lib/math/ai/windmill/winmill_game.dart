library math.ai.windmill_windmill_game;

import 'package:collection/collection.dart';
import 'package:trotter/trotter.dart';

enum Player { one, two }

enum GameOutcome { winnerPlayer1, winnerPlayer2, tie }

class WindmillGame {
  WindmillGame({this.lookAhead = 4});

  /// How many steps ahead to consider
  final int lookAhead;

  /// Board only keeps if the spot has been taken or not
  /// The indexing is as follows:
  /// <p>0, 1, 2 - are the right horizontal points along the X axis counting
  /// from the inside square to the outside square
  /// <p>3, 4, 5 - are the diagonal points in quadrant 1, counting from inside out
  /// <p>6, 7, 9 - are the vertical points along the Y axis, counting from inside out
  /// <p>9, 10, 11 - are the diagonal points in quadrant 2, counting from inside out,
  /// etc,
  ///
  final List<bool> board = List.generate(24, (index) => false, growable: false);

  /// the list of moves (for both players)
  final moves = <int>[];

  GameOutcome play() {
    while (moves.length < 24) {
      var possibleMoves = _allMoves..removeAll(moves);
      var scores = <Map<String,dynamic>>[];
      for (var move in possibleMoves) {
        if (isGameOver([...moves, move])) {
          /// You're done
          moves.add(move);
          return getLastPlayer() == Player.one
              ? GameOutcome.winnerPlayer1
              : GameOutcome.winnerPlayer2;
        } else {
          /// calculate a score for the move, going forward a number of steps
          num score = 0.73;  /// TODO: fix me!
          scores.add({'move': move, 'score': score});
        }
      }
      /// select the move with the highest score, continue
      /// TODO: implement the minimax algorithm
      scores.sortBy<num>((e) => -e['score']);
      moves.add(scores.first['move'] as int);
    }

    return GameOutcome.tie;
  }

  Player getLastPlayer() => moves.length % 2 == 0 ? Player.two : Player.one;

  Player getNextPlayer() => moves.length % 2 == 0 ? Player.one : Player.two;

  num getScore(int move, {required int level, required num score}) {
    /// Garbage so far!

    if (level == lookAhead) {
      return score;
    }
    var possibleMoves = _allMoves..removeAll(moves);
    for (var move in possibleMoves) {
      if (isGameOver([...moves, move])) {
        return -1; // next move loses
      } else {
        moves.add(move);
        return getScore(move, level: level + 1, score: score);
      }
    }

    return 0;
  }

  Set<int> getPossibleMoves() {
    return _allMoves..removeAll(moves);
  }

  /// Check if the last move is the game winning move
  bool isGameOver(List<int> moves) {
    if (moves.length < 5) return false;
    var playerIndex = (moves.length - 1) % 2;
    var playerMoves =
        moves.whereIndexed((index, e) => index % 2 == playerIndex).toList();
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

  /// The arguments p0, p1, p2 need to be ordered, and >=0, <=23.
  bool isWinningPosition(int p0, int p1, int p2) {
    var wp = _winningPositions.firstWhere(
        (e) => e[0] == p0 && e[1] == p1 && e[2] == p2,
        orElse: () => <int>[]);
    if (wp.isNotEmpty) return true;
    return false;
  }

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

// final _winningPositions = <Tuple3<int, int, int>>{
//   Tuple3(0, 1, 2),
//   Tuple3(0, 3, 21),
//   Tuple3(1, 4, 22),
//   Tuple3(2, 5, 23),
//   Tuple3(3, 4, 5),
// };

// if (p0 < 9) {
//   if (p0 == 0) {
//     if (p1 == 1 && p2 == 2)
//       return true;
//     else if (p1 == 3 && p2 == 21)
//       return true;
//     else
//       return false;
//     //
//   } else if (p0 == 1) {
//     if (p1 == 4 && p2 == 22)
//       return true;
//     else
//       return false;
//     //
//   } else if (p0 == 2) {
//     if (p1 == 5 && p2 == 23)
//       return true;
//     else
//       return false;
//
//     /// more branches
//   }
// } else {
//   ///
//   if (p0 == 9) {
//     if (p1 == 10 && p2 == 11) return true;
//   }
// }
