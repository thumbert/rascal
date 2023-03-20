


import 'package:demos/math/ai/windmill/winmill_game.dart';
import 'package:test/test.dart';

void tests() {
  test('Is winning position', () {
    var game = WindmillGame(<int>[]);
    expect(game.isWinningPosition(2, 3, 5), false);
    expect(game.isWinningPosition(9, 12, 15), true);
    expect(game.isWinningPosition(17, 20, 23), true);
  });
  test('Has last player won?', () {
    var game = WindmillGame([1, 19, 22, 0, 4]);
    expect(game.hasLastPlayerWon(), true);
  });
  test('Check winning move', () {
    expect(WindmillGame([1, 19, 22, 16, 4]).gameStatus(), GameStatus.over); // Player 1: [1, 4, 22]
    expect(WindmillGame([1, 19, 7, 22, 16, 18, 20, 21, 23, 16]).gameStatus(), GameStatus.over);  // Player 2: [16, 19, 22]
  });
  test('Tie', () {
    var game = WindmillGame.fromMoves(
      [1,  0,  3, 18, 4,  9, 10, 8, 13, 17, 23, 19],
      [15, 2, 21,  5, 6, 12, 11, 7, 16, 14, 20, 22],
    );
    expect(game.gameStatus(), GameStatus.over);
    expect(game.hasLastPlayerWon(), false);  // it's a tie!
  });

  test('End game -2 stones', () {
    var game = WindmillGame.fromMoves(
        [1,  0,  3, 18, 4,  9, 10, 8, 13, 17, 20],
        [15, 2, 21,  5, 6, 12, 11, 7, 16, 14, 22],
    );
    var strategy = MiniMax(game: game, maxDepth: 4);
    expect(strategy.getNextMove(), 19);  // Player one wins with either 19, or 23
  });

  test('End game -4 stones', () {
    var game = WindmillGame.fromMoves(
        [1,  0,  3, 18, 4,  9, 10, 8, 13, 17],
        [15, 2, 21,  5, 6, 12, 11, 7, 16, 14],
    );
    var strategy = MiniMax(game: game, maxDepth: 6);
    expect(strategy.getNextMove(), 22);  // Player 1 wins with 22!
  });

  test('End game -5 stones', () {
    var game = WindmillGame.fromMoves(
        [1,  0,  3, 18, 4,  9, 10, 8, 13, 17],
        [15, 2, 21,  5, 6, 12, 11, 7, 16,   ],
    );
    var strategy = MiniMax(game: game, maxDepth: 6);
    expect(strategy.getNextMove(), 23);  // Player 2 wins with 23!
  });

  test('End game -6 stones', () {
    var game = WindmillGame.fromMoves(
        [23, 0,  3, 18, 4,  9, 10, 8, 13],
        [15, 2, 21,  5, 6, 12, 11, 7, 16],
    );
    var strategy = MiniMax(game: game, maxDepth: 6);
    expect(strategy.getNextMove(), 17);  // Player 1 blocks Player 2 from winning
  });

  test('End game -7 stones', () {
    var game = WindmillGame.fromMoves(
      [14, 0,  3, 18, 4,  9, 10, 8, 13],
      [15, 1, 21,  5, 6, 12, 11, 7],
    );
    var strategy = MiniMax(game: game, maxDepth: 10);
    expect(strategy.getNextMove(), 17);  // ?? not unique, so pick something!
    /// TODO: continue here ...
  }, solo: true);




  // test('End game -7 stones', () {
  //   var game = WindmillGame.fromMoves(
  //       [1,  0,  3, 18, 4,  9, 10, 8, 13],
  //       [15, 2, 21,  5, 6, 12, 11, 7,   ],
  //   );
  //   var strategy = MiniMax(game: game, maxDepth: 6);
  //   expect(strategy.getNextMove(), 23);  // Player 2 wins with 23!
  // }, solo: true);





  //
  // test('Player one to win-in-one, depth=2', () {
  //   var strategy = MiniMax(game: WindmillGame([1, 19, 22, 16]), maxDepth: 2);
  //   expect(strategy.getNextMove(), 4);
  // });
  //
  //
  // test('Player one to win-in-one, depth=4', () {
  //   var strategy = MiniMax(game: WindmillGame([1, 19, 22, 16]), maxDepth: 4);
  //   expect(strategy.getNextMove(), 4);
  // });
  //
  // test('Player two to win-in-one, depth=2', () {
  //   var strategy = MiniMax(game: WindmillGame([1, 19, 3, 16, 7]), maxDepth: 2);
  //   expect(strategy.getNextMove(), 22);
  // });
  //
  //
  // test('Block win-in-one by player one, depth=2', () {
  //   var strategy = MiniMax(game: WindmillGame([1, 19, 22]), maxDepth: 2);
  //   expect(strategy.getNextMove(), 4);
  // });
  //
  // test('Block win-in-one by player one, depth=4', () {
  //   var strategy = MiniMax(game: WindmillGame([1, 19, 22]), maxDepth: 4);
  //   expect(strategy.getNextMove(), 4);
  // });
  //
  // test('Block win-in-one by player two, depth=2', () {
  //   var strategy = MiniMax(game: WindmillGame([1, 19, 3, 16]), maxDepth: 2);
  //   expect(strategy.getNextMove(), 22);
  // });
  //
  // test('Block win-in-one by player two, depth=4', () {
  //   var strategy = MiniMax(game: WindmillGame([1, 19, 3, 16]), maxDepth: 4);
  //   expect(strategy.getNextMove(), 22);
  // });
  //
  // test('Player two blocks win by player one', () {
  //   var strategy = MiniMax(game: WindmillGame([1, 15, 0, 2, 3]), maxDepth: 2);
  //   expect(strategy.getNextMove(), 21);
  // });



  // test('Block win-in-one by player one, maxDepth=3', () {
  //   var strategy = MiniMax(game: WindmillGame([1, 15, 0, 2, 3]), maxDepth: 3);
  //   expect(strategy.getNextMove(), 21);
  // }, solo: true);

  // test('Play game 1', () {
  //   var strategy = MiniMax(game: WindmillGame([1, 19, 22, 16]), maxDepth: 2);
  //   while (strategy.game.gameStatus() == GameStatus.live) {
  //     strategy.addMove(strategy.getNextMove()!);
  //     print(strategy.game.moves);
  //   }
  //   print('Game over.  ${strategy.game.lastPlayer} won!');
  // });
  // test('Play game 2', () {
  //   var strategy = MiniMax(game: WindmillGame([1, 15]), maxDepth: 3);
  //   while (strategy.game.gameStatus() == GameStatus.live) {
  //     strategy.addMove(strategy.getNextMove()!);
  //     print(strategy.game.moves);
  //   }
  //   print('Game over.  ${strategy.game.lastPlayer} won!');
  // });
  // test('Play game 3', () {
  //   var strategy = MiniMax(game: WindmillGame([1, 15, 0, 2, 3, 21]), maxDepth: 3);
  //   while (strategy.game.gameStatus() == GameStatus.live) {
  //     strategy.addMove(strategy.getNextMove()!);
  //     print(strategy.game.moves);
  //   }
  //   print('Game over.  ${strategy.game.lastPlayer} won!');
  // });
}

void main() {
  tests();
}


// game.moves.add(1);
// expect(game.getPossibleMoves().length, 23);
// game.moves.add(19);
// expect(game.getPossibleMoves().length, 22);
// expect(game.getLastPlayer(), Player.two);
// expect(game.getNextPlayer(), Player.one);
