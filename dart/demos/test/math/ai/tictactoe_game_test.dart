import 'package:demos/math/ai/tictactoe/tictactoe_game.dart';
import 'package:test/test.dart';

void tests() {
  test('Basic ops', () {
    var game = TicTacToeGame(<int>[0, 1, 4, 6, 7]);
    expect(game.gameStatus(), GameStatus.live);
    game = TicTacToeGame(<int>[0, 1, 4, 6, 7, 5, 8]);
    expect(game.nextPlayer, Player.two);
    expect(game.gameStatus(), GameStatus.over);
    expect(game.utility(), 0.14285714285714285);
  });
  test('Utility', () {
    expect(TicTacToeGame(<int>[0, 1, 4, 6, 7, 2, 3, 5, 8]).utility(), 0.1111111111111111);
    expect(TicTacToeGame(<int>[0, 1, 4, 6, 7, 8, 3, 5, 2]).utility(), 0);
  });
  test('Next moves', () {
    var game = TicTacToeGame(<int>[0, 1, 4, 6, 7]);
    expect(game.actions(), {2, 3, 5, 8});
  });
  test('Test minimax, 3 moves', () {
    var game = TicTacToeGame(<int>[0, 1, 4, 6, 7, 2]);
    var move = TicTacToeGame.minimax(game);
    expect(move, 8);
  });
  test('Test minimax, 2 moves', () {
    var game = TicTacToeGame(<int>[0, 1, 4, 6]);
    var move = TicTacToeGame.minimax(game);
    expect(move, 8);
  });
  test('Test maximin, 2.5 moves', () {
    var game = TicTacToeGame(<int>[0, 4, 6]);
    var move = TicTacToeGame.maximin(game);
    expect(move, 3);
  });
}

void main() {
  tests();
}
