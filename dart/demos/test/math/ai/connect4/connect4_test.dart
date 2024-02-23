library test.math.ai.connect4;

import 'package:demos/math/ai/connect4/board.dart';
import 'package:demos/math/ai/connect4/chip.dart';
import 'package:demos/math/ai/connect4/move.dart';
import 'package:demos/math/ai/connect4/player.dart';
import 'package:tuple/tuple.dart';
import 'package:test/test.dart';
import 'package:demos/math/ai/connect4/connect4.dart';
import 'package:demos/math/ai/connect4/strategy.dart';

tests() {
  test('Board from string', () {
    var xs = [
      'XO',
      '',
      'XX',
      'OO',
      'O',
      'X',
      'X',
    ];
    var board = Board.parse(xs);
    expect(board[0], [Chip('X'), Chip('O')]);
    expect(board[1], []);
    expect(board[2], [Chip('X'), Chip('X')]);
    expect(board[3], [Chip('O'), Chip('O')]);
    expect(board[4], [Chip('O')]);
    expect(board[5], [Chip('X')]);
    expect(board[6], [Chip('X')]);
  });

  test('Board respects row size', () {
    var board = Board()..addAll([0, 0, 0, 0, 0, 0, 1]);
    var move = Move(board.nextChip, 0);
    expect(move.isValid(board), false);
    expect(() => board.add(0), throwsStateError);
  });

  test('Board from moves', () {
    var board = Board()..addAll([0, 0, 2, 3, 2, 3, 5, 4, 6]);
    expect(board[0], [Chip('X'), Chip('O')]);
    expect(board[1], []);
    expect(board[2], [Chip('X'), Chip('X')]);
    expect(board[3], [Chip('O'), Chip('O')]);
    expect(board[4], [Chip('O')]);
    expect(board[5], [Chip('X')]);
    expect(board[6], [Chip('X')]);
  });

  test('Board next chip', () {
    var board = Board()..addAll([0, 0, 2, 3, 2, 3, 5, 4, 6]);
    expect(board.nextChip, Chip('O'));
    board.add(1);
    expect(board[1], [Chip('O')]);
    expect(board.nextChip, Chip('X'));
  });

  test('Board copy', () {
    var board0 = Board()..addAll([0, 0, 2, 3, 2, 3, 5, 4, 6]);
    var board = board0.copy();
    expect(board.nextChip, Chip('O'));
    board.add(1);
    expect(board[1], [Chip('O')]);
    expect(board.nextChip, Chip('X'));
  });

  test('index of unfilled columns', () {
    var board = Board()..addAll([0, 0, 2, 3, 2, 3, 5, 0, 0, 0, 0]);
    expect(board.indexOfUnfilledColumns().contains(0), false);
    expect(board.indexOfUnfilledColumns().contains(1), true);
  });

  test('get chip coordinates', () {
    var xs = [
      'XO',
      '',
      'XX',
      'OO',
      'O',
      'X',
      'X',
    ];
    var board = Board.parse(xs);
    var coordinatesX = board.coordinates(Chip('X'));
    var coordinatesO = board.coordinates(Chip('O'));
    expect(coordinatesX, {
      Tuple2(0, 0),
      Tuple2(0, 2),
      Tuple2(1, 2),
      Tuple2(0, 5),
      Tuple2(0, 6),
    });
    expect(coordinatesO, {
      Tuple2(1, 0),
      Tuple2(0, 3),
      Tuple2(1, 3),
      Tuple2(0, 4),
    });
  });

  test('is winning 4-vertical', () {
    var board = Board()..addAll([3, 0, 3, 1, 3, 4]);
    var move = Move(board.nextChip, 3);
    expect(move.isValid(board), true);
    expect(move.isWinning(board), true);
    expect(board[3].length, 3);
  });

  test('is winning 4-horizontal', () {
    var board = Board()..addAll([1, 0, 2, 0, 3, 0]);
    var move = Move(board.nextChip, 4);
    expect(move.isValid(board), true);
    expect(move.isWinning(board), true);
  });

  test('is winning slope +1', () {
    var board = Board()..addAll([0, 1, 1, 2, 5, 2, 2, 3, 6, 3, 5, 3]);
    var move = Move(board.nextChip, 3);
    expect(move.isWinning(board), true);
  });

  test('is winning slope -1', () {
    var board = Board()..addAll([5, 4, 4, 3, 3, 2, 3, 2, 2, 0]);
    var move = Move(board.nextChip, 2);
    expect(move.isWinning(board), true);
  });

  test('next chip for RandomStrategy', () {
    var player1 = Player(Chip('X'), RandomStrategy(), name: 'Adrian');
    var player2 = Player(Chip('O'), RandomStrategy(), name: 'Lara');
    var game = Connect4Game(player1, player2);
    game.board
        .addAll([0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 3, 4, 6]);
    var i = player2.strategy.nextMove(game);
    // print(game.board);
  });

  test('negamax', () {
    // var board = Board()..addAll([3, 3, 4, 4]);
    // var board = Board.parseDigits('33344443110');
    var board = Board.parseDigits(
      '2252576253462244111563365343671351441',
    );
    print(board.negamax(board));
  }, solo: true);
}

// void playRandomVsRandom() {
//   var player1 = Player(Chip('X'), RandomStrategy(), name: 'A');
//   var player2 = Player(Chip('O'), RandomStrategy(), name: 'B');
//   var game = Connect4Game(player1, player2);
//   game.play();
//   print(game.board);
// }

// playForesight1VsRandom() {
//   var n = 100;
//   var outcomes = [];
//   for (var i = 0; i < n; i++) {
//     var player1 = Player(Chip('R'), Foresight2Strategy(), name: 'A');
//     var player2 = Player(Chip('Y'), RandomStrategy(), name: 'B');
//     var game = Connect4Game(player1, player2);
//     //game.play();
//     outcomes.add(game.play());
//   }
//   var res = count(outcomes);
//   res.forEach((k, v) => print('$k: $v'));
// }

main() {
  tests();

  // Amazing writeup
  // http://blog.gamesolver.org/solving-connect-four/02-test-protocol/

  // playRandomVsRandom();

//  playForesight1VsRandom();

  // playMinmaxVsRandom();
}
