


import 'package:demos/math/ai/windmill/winmill_game.dart';
import 'package:test/test.dart';

void tests() {
  var game = WindmillGame();
  test('Is winning position', () {
    expect(game.isWinningPosition(2, 3, 5), false);
    expect(game.isWinningPosition(9, 12, 15), true);
    expect(game.isWinningPosition(17, 20, 23), true);
  });
  test('Check winning move', (){
    expect(game.isGameOver([1, 19, 22, 16, 4]), true); // Player 1: [1, 4, 22]
    expect(game.isGameOver([1, 19, 7, 22, 16, 18, 20, 21, 23, 16]), true);  // Player 2: [16, 19, 22]
  });
  test('Play', () {
    game.moves.add(1);
    expect(game.getPossibleMoves().length, 23);
    game.moves.add(19);
    expect(game.getPossibleMoves().length, 22);
    expect(game.getLastPlayer(), Player.two);
    expect(game.getNextPlayer(), Player.one);



    // game.getScore(move, level: level, score: score)

  });
}

void main() {
  tests();
}