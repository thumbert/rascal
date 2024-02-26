
import 'package:demos/math/ai/windmill/winmill_game2.dart';
import 'package:test/test.dart';

void tests() {
  test('Print board', () {
    var state = NonTerminalState(
      [1, 0, 3, 18, 4, 9, 10, 8, 13, 17, 23, 19],
     [15, 2, 21, 5, 6, 12, 11, 7, 16, 14, 20, 22]);
    expect(state.board(), """
O-----------X-----------O
|  X--------O--------X  |
|  |  X-----O-----X  |  |
|  |  |           |  |  |
|  |  |           |  |  |
O  X  O           X  X  O
|  |  |           |  |  |
|  |  |           |  |  |
|  |  O-----X-----O  |  |
|  O--------X--------O  |
X-----------O-----------X
""");
  });
  

  test('Has last player won?', () {
    var state = NonTerminalState([1, 22], [19, 0]);
    var newState = state.result(4);
    expect(newState is TerminalState, true);
  });
  test('Check winning move', () {
    var state = NonTerminalState([1, 7, 16, 20, 23], [19, 22, 18, 21]);
    var newState = state.result(16);
    expect(newState is TerminalState, true);
  });
  test('Check tie', () {
    var state = NonTerminalState(
      [1, 0, 3, 18, 4, 9, 10, 8, 13, 17, 23, 19],
     [15, 2, 21, 5, 6, 12, 11, 7, 16, 14, 20]);
    expect(state.actions(), {22});
    var newState = state.result(22);
    expect(newState is TerminalState, true);
    expect((newState as TerminalState).utility(Player.one), 0.5);
    expect(newState.utility(Player.two), 0.5);
  });

  test('Check Player.two wins with last move', () {
    var state = NonTerminalState(
      [1, 0, 3, 18, 4, 9, 10, 8, 15, 17, 23, 19],
     [22, 2, 21, 5, 6, 12, 11, 7, 16, 14, 20]);
    expect(state.actions(), {13});
    var newState = state.result(13);
    expect(newState is TerminalState, true);  // Player.two wins with [12, 13, 14]
    print(newState);
    expect((newState as TerminalState).utility(Player.one), -1.0);
    expect(newState.utility(Player.two), 1.0);
  });

}

// speedTest() {
//   // generate 10,000 random positions
//   var rand = Random();
//   var positions = <List<int>>[];
//   final sw = Stopwatch()..start();
//   while (positions.length < 10000) {
//     var i1 = rand.nextInt(24);
//     var i2 = rand.nextInt(24);
//     var i3 = rand.nextInt(24);
//     if ({i1, i2, i3}.length == 3) {
//       var xs = [i1, i2, i3];
//       xs.sort();
//       positions.add(xs);
//     }
//   }
//   sw.stop();
//   print(sw.elapsedMilliseconds);
//   sw.reset();
//   final game = WindmillGame(<int>[]);
//   sw.start();
//   var count = 0;
//   for (var ps in positions) {
//     if (game.isWinningPosition(ps[0], ps[1], ps[2])) {
//       count += 1;
//     }
//   }
//   sw.stop();
//   print(sw.elapsedMilliseconds);
//   /// takes 5ms to check 10,000 positions!  Pretty good. 
//   print(count);
// }

void play() {
  // TODO: make sure minmax strategy checks if it can win 
  // with next move.  If it does, take it!

  var p1 = PlayerOne(RandomStrategy());
  // var p2 = PlayerTwo(RandomStrategy());
  var p2 = PlayerTwo(MinMaxStrategy());
  var initialState = NonTerminalState(<Move>[], <Move>[]);

  var game = Game(p1, p2, initialState);
  final end = game.play();
  print(end);
  print('utility player1: ${end.utility(Player.one)}');
  print('utility player2: ${end.utility(Player.two)}');
}


void main() {
  // tests();
  // speedTest();
  play();

}







  // test('Tie', () {
  //   var game = WindmillGame.fromMoves(
  //     [1, 0, 3, 18, 4, 9, 10, 8, 13, 17, 23, 19],
  //     [15, 2, 21, 5, 6, 12, 11, 7, 16, 14, 20, 22],
  //   );
  //   expect(game.gameStatus(), GameStatus.over);
  //   expect(game.hasLastPlayerWon(), false); // it's a tie!
  // });

  // test('End game -2 stones', () {
  //   var game = WindmillGame.fromMoves(
  //     [1, 0, 3, 18, 4, 9, 10, 8, 13, 17, 20],
  //     [15, 2, 21, 5, 6, 12, 11, 7, 16, 14, 22],
  //   );
  //   var strategy = MiniMax(game: game, maxDepth: 4);
  //   expect(strategy.getNextMove(), 19); // Player one wins with either 19, or 23
  // });

  // test('End game -4 stones', () {
  //   var game = WindmillGame.fromMoves(
  //     [1, 0, 3, 18, 4, 9, 10, 8, 13, 17],
  //     [15, 2, 21, 5, 6, 12, 11, 7, 16, 14],
  //   );
  //   var strategy = MiniMax(game: game, maxDepth: 6);
  //   expect(strategy.getNextMove(), 22); // Player 1 wins with 22!
  // });

  // test('End game -5 stones', () {
  //   var game = WindmillGame.fromMoves(
  //     [1, 0, 3, 18, 4, 9, 10, 8, 13, 17],
  //     [
  //       15,
  //       2,
  //       21,
  //       5,
  //       6,
  //       12,
  //       11,
  //       7,
  //       16,
  //     ],
  //   );
  //   var strategy = MiniMax(game: game, maxDepth: 6);
  //   expect(strategy.getNextMove(), 23); // Player 2 wins with 23!
  // });

  // test('End game -6 stones', () {
  //   var game = WindmillGame.fromMoves(
  //     [23, 0, 3, 18, 4, 9, 10, 8, 13],
  //     [15, 2, 21, 5, 6, 12, 11, 7, 16],
  //   );
  //   var strategy = MiniMax(game: game, maxDepth: 6);
  //   expect(strategy.getNextMove(), 17); // Player 1 blocks Player 2 from winning
  // });

  // test('End game -7 stones', () {
  //   var game = WindmillGame.fromMoves(
  //     [14, 0, 3, 18, 4, 9, 10, 8, 13],
  //     [15, 1, 21, 5, 6, 12, 11, 7],
  //   );
  //   var strategy = MiniMax(game: game, maxDepth: 10);
  //   expect(strategy.getNextMove(), 17); // ?? not unique, so pick something!
  //   /// TODO: continue here ...
  // }, solo: true);

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
