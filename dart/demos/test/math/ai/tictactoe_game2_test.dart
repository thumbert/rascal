import 'package:demos/math/ai/tictactoe/tictactoe_game2.dart';
import 'package:test/test.dart';

void tests() {
  test('State', () {
    var state = NonTerminalState([0, 4, 7], [1, 6]);
    expect(state.actions(), {2, 3, 5, 8});
  });
  test('Is winning move', () {
    var state = NonTerminalState([0, 4, 7], [1, 6]);
    expect(state.isWinningMove(8), false); // player 2
    state = state.result(2) as NonTerminalState;
    expect(state.isWinningMove(8), true); // player 1
    final end = state.result(8);
    expect(end is TerminalState, true);
  });
  test('test utility, player 1 current', () {
    var state = TerminalState([7, 5, 2, 4, 6], [1, 3, 8, 0]);
    expect(state.utility(Player.one), 1.0);
    expect(state.utility(Player.two), -1.0);
  });
  test('test utility, player 2 current', () {
    var state = TerminalState([7, 6, 2, 3], [1, 8, 4, 0]);
    expect(state.utility(Player.one), -1.0);
    expect(state.utility(Player.two), 1.0);
  });
  test('test utility for a tie', () {
    var state = TerminalState([7, 5, 2, 4, 0], [1, 3, 8, 6]);
    expect(state.utility(Player.one), 0.5);
    expect(state.utility(Player.two), 0.5);
  });
  test('minmax strategy, 5 pieces -- a tie', () {
    var p1 = PlayerOne(MinMaxStrategy());
    var p2 = PlayerTwo(MinMaxStrategy());
    var initialState = NonTerminalState(<Move>[
      0,
      4,
      7,
    ], <Move>[
      1,
      6,
    ]);

    var game = Game(p1, p2, initialState);
    final end = game.play();
    expect(end.movesPlayer1, [0, 4, 7, 2, 5]);
    expect(end.movesPlayer2, [1, 6, 8, 3]);
    expect(end.utility(Player.one), 0.5);
  });

  test('minmax strategy, 7 pieces', () {
    var p1 = PlayerOne(MinMaxStrategy());
    var p2 = PlayerTwo(MinMaxStrategy());
    var initialState = NonTerminalState(<Move>[
      7,
      6,
      2,
      3,
    ], <Move>[
      1,
      8,
      4,
    ]);

    var game = Game(p1, p2, initialState);
    final end = game.play();
    expect(end.movesPlayer1, [7, 6, 2, 3]);
    expect(end.movesPlayer2, [1, 8, 4, 0]);
  });

  test('minmax strategy, 4 pieces', () {
    var p1 = PlayerOne(MinMaxStrategy());
    var p2 = PlayerTwo(MinMaxStrategy());
    var initialState = NonTerminalState(<Move>[
      0,
      4,
    ], <Move>[
      1,
    ]);

    var game = Game(p1, p2, initialState);
    final end = game.play();
    expect(end.movesPlayer1, [0, 4, 5, 2, 7]);
    expect(end.movesPlayer2, [1, 8, 3, 6]);
    print(end);
    print('moves player1: ${end.movesPlayer1})');
    print('moves player2: ${end.movesPlayer2})');
    print('utility player1: ${end.utility(Player.one)}');
    print('utility player2: ${end.utility(Player.two)}');
  });

  test('minmax strategy, prolong the fight', () {
    var p1 = PlayerOne(MinMaxStrategy());
    var p2 = PlayerTwo(MinMaxStrategy());
    var initialState = NonTerminalState(<Move>[
      1,
      5,
      8,
    ], <Move>[
      6,
      7,
    ]);

    var game = Game(p1, p2, initialState);
    final end = game.play();
    expect(end.movesPlayer1, [1, 5, 8, 4, 3]);
    expect(end.movesPlayer2, [6, 7, 2, 0]);
  });
}

void play() {
  var p1 = PlayerOne(RandomStrategy());
  var p2 = PlayerTwo(MinMaxStrategy());
  var initialState = NonTerminalState(<Move>[], <Move>[]);

  var game = Game(p1, p2, initialState);
  final end = game.play();
  print(end);
  print('utility player1: ${end.utility(Player.one)}');
  print('utility player2: ${end.utility(Player.two)}');
}

void main() {
  tests();

  // play();
}
