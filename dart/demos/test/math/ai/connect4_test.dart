library test.math.ai.connect4;

import 'package:tuple/tuple.dart';
import 'package:more/iterable.dart';
import 'package:dama/basic/count.dart';
import 'package:test/test.dart';
import 'package:demos/math/ai/connect4/connect4.dart';
import 'package:demos/math/ai/connect4/strategy.dart';

/// Add a bunch a chips at once.
Connect4Game addChips(Connect4Game game, List<int> columnIds) {
  var players = [game.player1, game.player2];
  for (var e in indexed(columnIds)) {
    var player = players[e.index % 2];
    game.moves.add(Tuple3(game.nextRow(e.value), e.value, player));
  }
  return game;
}


tests() {

  test('is winning 4-vertical', (){
    var player1 = Player(Chip('red', 'R'), RandomStrategy(), name: 'Adrian');
    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'Lara');
    var game = Connect4Game(player1, player2);
    addChips(game, [3, 0, 3, 1, 3, 4, 3]);
    expect(game.moves.contains(Tuple3(0, 3, player1)), true);
    expect(game.moves.length, 7);
    expect(game.coordinates(player2).length, 3);
    expect(game.isWinner(player1), true);
  });

  test('is winning 4-horizontal', (){
    var player1 = Player(Chip('red', 'R'), RandomStrategy(), name: 'Adrian');
    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'Lara');
    var game = Connect4Game(player1, player2);
    addChips(game, [1, 0, 2, 0, 3, 0, 4]);
    expect(game.moves.contains(Tuple3(0, 1, player1)), true);
    expect(game.moves.length, 7);
    expect(game.coordinates(player2).length, 3);
    expect(game.isWinner(player1), true);
  });

  test('is winning slope +1', (){
    var player1 = Player(Chip('red', 'R'), RandomStrategy(), name: 'A');
    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'B');
    var game = Connect4Game(player1, player2);
    addChips(game, [0, 1, 1, 2, 5, 2, 2, 3, 6, 3, 5, 3, 3]);
    expect(game.isWinner(player1), true);
  });

  test('is winning slope -1', (){
    var player1 = Player(Chip('red', 'R'), RandomStrategy(), name: 'A');
    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'B');
    var game = Connect4Game(player1, player2);
    addChips(game, [5, 4, 4, 3, 3, 2, 3, 2, 2, 0, 2]);
    expect(game.isWinner(player1), true);
  });


  test('play random/random game', (){
    var player1 = Player(Chip('red', 'R'), RandomStrategy(), name: 'A');
    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'B');
    var game = Connect4Game(player1, player2);
    var outcome = game.play();
    print(game.showBoard());
    print(outcome);
  });




//  test('play foresight1/random game', (){
//    var player1 = Player(Chip('red', 'R'), Foresight1Strategy(), name: 'A');
//    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'B');
//    var game = Connect4Game(player1, player2);
//    var outcome = game.play();
//    print(game.board);
//    print(outcome);
//  });


}


//compareStrategies() {
//  var n = 1000;
//  var outcomes = [];
//  for (var i=0; i<n; i++) {
//    //var player1 = Player(Chip('red', 'R'), RandomStrategy(), name: 'A');
//    var player1 = Player(Chip('red', 'R'), Foresight1Strategy(), name: 'A');
//    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'B');
//    var game = Connect4Game(player1, player2);
//    outcomes.add(game.play());
//  }
//  var res = count(outcomes);
//  res.forEach((k,v) => print('$k: $v'));
//}


main() {
  tests();

  //compareStrategies();
}