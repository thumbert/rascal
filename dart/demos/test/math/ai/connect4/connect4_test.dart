library test.math.ai.connect4;

import 'package:test/test.dart';
import 'package:demos/math/ai/connect4/connect4_game.dart';

tests() {
  test('Board from string', () {
    final raw = """
.......
.......
..X.XO.
.OXOXO.
""";
    final state = State.fromString(raw);
    expect(state.movesPlayer1.toSet(), {12, 13, 24, 25});
    expect(state.movesPlayer2.toSet(), {6, 18, 30, 31});
    expect(state.height, [0, 1, 2, 1, 2, 2, 0]);
  });
  test('Board from digits', () {
    final state = State.fromDigits('4455');
    expect(state.movesPlayer1.toSet(), {18, 24});
    expect(state.movesPlayer2.toSet(), {19, 25});
    expect(state.height, [0, 0, 0, 2, 2, 0, 0]);
    expect(state.actions(), {0, 6, 12, 20, 26, 30, 36});
  });
  test('Print board', () {
    final state = State.fromDigits('44455554221');
    expect(state.movesPlayer1.toSet(), {0, 6, 18, 20, 25, 27});
    expect(state.movesPlayer2.toSet(), {7, 19, 21, 24, 26});
    final out = """
.......
.......
...OX..
...XO..
.O.OX..
XX.XO..
1234567

moves Player1: [18, 20, 25, 27,  6,  0]
moves Player2: [19, 24, 26, 21,  7]""";
    expect(state.toString(), out);
    expect(state.height, [1, 2, 0, 4, 4, 0, 0]);
    expect(state.actions(), {1, 8, 12, 22, 28, 30, 36});
  });

  test('Winning move', () {
    final state = State.fromDigits('444555542216');
    expect(state.isWinningMove(12), true);
  });

  test('Wining move vertical', () {
    final state =
        NonTerminalState([12, 13, 30, 6], [0, 1, 2], [3, 1, 2, 0, 1, 0, 0]);
    expect(state.isWinningMove(3), true);
  });

  test('Not a winning move', () {
    final state = State.fromDigits('4445555422145');
    expect(state.actions(), {1, 8, 12, 23, 29, 30, 36});
    expect(state.isWinningMove(23), false);
    final newState = (state as NonTerminalState).result(23);
    expect(newState is NonTerminalState, true);
  });

  test('Check action when columns are filled', () {
    final state = State.fromDigits('444555542214545');
    expect(state.actions(), {1, 8, 12, 30, 36});
  });

  test('MiniMax, situation 1', () {
    final state =
        NonTerminalState([0, 6, 18, 12], [1, 2, 3], [4, 1, 1, 1, 0, 0, 0]);
    final p2 = PlayerTwo(MinMaxStrategy(maxDepth: 5));

    /// How did the MiniMax player lose???
// .......
// .......
// O......
// O......
// O......
// XX.X...
// 1234567

// moves Player1: [ 0,  6, 18, 12]
// moves Player2: [ 1,  2,  3]
  });
}

void play() {
  // var p1 = PlayerOne(RandomStrategy());
  // var p1 = PlayerOne(ManualStrategy(presetMoves: [30]));
  var p1 = PlayerOne(ManualStrategy());
  // var p2 = PlayerTwo(RandomStrategy());
  /// PlayerTwo needs to have an even maxDepth value!
  var p2 = PlayerTwo(MinMaxStrategy(maxDepth: 6));
  var initialState = NonTerminalState.empty();
  // var initialState =
  //     NonTerminalState([0, 6, 36, 30], [1, 2, 3], [4, 1, 0, 0, 0, 1, 1]);
  var game = Game(p1, p2, initialState);
  final end = game.play();
  print(end);
  print('utility player1: ${end.utility(Player.one)}');
  print('utility player2: ${end.utility(Player.two)}');
  print(
      'timings player1: ${p1.timings.map((e) => (e.inSeconds / 60).toStringAsFixed(1)).join(',')} minutes');
  print(
      'timings player2: ${p2.timings.map((e) => (e.inSeconds / 60).toStringAsFixed(1)).join(',')} minutes');
  print('Number of moves: ${end.movesPlayer2.length}');
}

main() {
  // tests();
  play();

  // Amazing writeup
  // http://blog.gamesolver.org/solving-connect-four/02-test-protocol/
}



// tests() {
//   test('Board from string', () {
//     var xs = [
//       'XO',
//       '',
//       'XX',
//       'OO',
//       'O',
//       'X',
//       'X',
//     ];
//     var board = Board.parse(xs);
//     expect(board[0], [Chip('X'), Chip('O')]);
//     expect(board[1], []);
//     expect(board[2], [Chip('X'), Chip('X')]);
//     expect(board[3], [Chip('O'), Chip('O')]);
//     expect(board[4], [Chip('O')]);
//     expect(board[5], [Chip('X')]);
//     expect(board[6], [Chip('X')]);
//   });

//   test('Board respects row size', () {
//     var board = Board()..addAll([0, 0, 0, 0, 0, 0, 1]);
//     var move = Move(board.nextChip, 0);
//     expect(move.isValid(board), false);
//     expect(() => board.add(0), throwsStateError);
//   });

//   test('Board from moves', () {
//     var board = Board()..addAll([0, 0, 2, 3, 2, 3, 5, 4, 6]);
//     expect(board[0], [Chip('X'), Chip('O')]);
//     expect(board[1], []);
//     expect(board[2], [Chip('X'), Chip('X')]);
//     expect(board[3], [Chip('O'), Chip('O')]);
//     expect(board[4], [Chip('O')]);
//     expect(board[5], [Chip('X')]);
//     expect(board[6], [Chip('X')]);
//   });

//   test('Board next chip', () {
//     var board = Board()..addAll([0, 0, 2, 3, 2, 3, 5, 4, 6]);
//     expect(board.nextChip, Chip('O'));
//     board.add(1);
//     expect(board[1], [Chip('O')]);
//     expect(board.nextChip, Chip('X'));
//   });

//   test('Board copy', () {
//     var board0 = Board()..addAll([0, 0, 2, 3, 2, 3, 5, 4, 6]);
//     var board = board0.copy();
//     expect(board.nextChip, Chip('O'));
//     board.add(1);
//     expect(board[1], [Chip('O')]);
//     expect(board.nextChip, Chip('X'));
//   });

//   test('index of unfilled columns', () {
//     var board = Board()..addAll([0, 0, 2, 3, 2, 3, 5, 0, 0, 0, 0]);
//     expect(board.indexOfUnfilledColumns().contains(0), false);
//     expect(board.indexOfUnfilledColumns().contains(1), true);
//   });

//   test('get chip coordinates', () {
//     var xs = [
//       'XO',
//       '',
//       'XX',
//       'OO',
//       'O',
//       'X',
//       'X',
//     ];
//     var board = Board.parse(xs);
//     var coordinatesX = board.coordinates(Chip('X'));
//     var coordinatesO = board.coordinates(Chip('O'));
//     expect(coordinatesX, {
//       Tuple2(0, 0),
//       Tuple2(0, 2),
//       Tuple2(1, 2),
//       Tuple2(0, 5),
//       Tuple2(0, 6),
//     });
//     expect(coordinatesO, {
//       Tuple2(1, 0),
//       Tuple2(0, 3),
//       Tuple2(1, 3),
//       Tuple2(0, 4),
//     });
//   });

//   test('is winning 4-vertical', () {
//     var board = Board()..addAll([3, 0, 3, 1, 3, 4]);
//     var move = Move(board.nextChip, 3);
//     expect(move.isValid(board), true);
//     expect(move.isWinning(board), true);
//     expect(board[3].length, 3);
//   });

//   test('is winning 4-horizontal', () {
//     var board = Board()..addAll([1, 0, 2, 0, 3, 0]);
//     var move = Move(board.nextChip, 4);
//     expect(move.isValid(board), true);
//     expect(move.isWinning(board), true);
//   });

//   test('is winning slope +1', () {
//     var board = Board()..addAll([0, 1, 1, 2, 5, 2, 2, 3, 6, 3, 5, 3]);
//     var move = Move(board.nextChip, 3);
//     expect(move.isWinning(board), true);
//   });

//   test('is winning slope -1', () {
//     var board = Board()..addAll([5, 4, 4, 3, 3, 2, 3, 2, 2, 0]);
//     var move = Move(board.nextChip, 2);
//     expect(move.isWinning(board), true);
//   });

//   test('next chip for RandomStrategy', () {
//     var player1 = Player(Chip('X'), RandomStrategy(), name: 'Adrian');
//     var player2 = Player(Chip('O'), RandomStrategy(), name: 'Lara');
//     var game = Connect4Game(player1, player2);
//     game.board
//         .addAll([0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 4, 6]);
//     var i = player2.strategy.nextMove(game);
//     // print(game.board);
//   });

//   test('negamax', () {
//     // var board = Board()..addAll([3, 3, 4, 4]);
//     // var board = Board.parseDigits('33344443110');
//     var board = Board.parseDigits(
//       '2252576253462244111563365343671351441',
//     );
//     print(board.negamax(board));
//   }, solo: true);
// }
