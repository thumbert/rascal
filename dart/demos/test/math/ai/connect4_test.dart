library test.math.ai.connect4;

import 'package:tuple/tuple.dart';
import 'package:more/iterable.dart';
import 'package:dama/basic/count.dart';
import 'package:test/test.dart';
import 'package:demos/math/ai/connect4/connect4.dart';
import 'package:demos/math/ai/connect4/strategy.dart';

/// Add a bunch a chips at once.
Connect4Game addChips(Connect4Game game, List<int> columnIds) {
  for (var i in columnIds) {
    game.addChip(i);
  }
  return game;
}


tests() {

  test('player to move', () {
    var player1 = Player(Chip('red', 'R'), RandomStrategy(), name: 'Adrian');
    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'Lara');
    var game = Connect4Game(player1, player2);
    expect(game.playerToMove, player1);
    game.addChip(0);
    expect(game.playerToMove, player2);
    game.addChip(1);
    expect(game.playerToMove, player1);
  });

  test('next row', () {
    var player1 = Player(Chip('red', 'R'), RandomStrategy(), name: 'Adrian');
    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'Lara');
    var game = Connect4Game(player1, player2);
    expect(game.nextRow(0), 0);
    addChips(game, [0,0,0]);
    expect(game.nextRow(0), 3);
    expect(game.nextRow(1), 0);
  });

  test('next row almost filled', () {
    var player1 = Player(Chip('red', 'R'), RandomStrategy(), name: 'Adrian');
    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'Lara');
    var game = Connect4Game(player1, player2);
    expect(game.nextRow(0), 0);
    addChips(game, [0,0,0]);
    expect(game.nextRow(0), 3);
    expect(game.nextRow(1), 0);
    addChips(game, [1,1,1,0,0]);
    expect(game.nextRow(0), 5);
    addChips(game, [0]);
    expect(game.nextRow(0), 6);  // column 0 is now filled
    expect(game.frontier().contains(0), false);
  });

  test('next chip for RandomStrategy', (){
    var player1 = Player(Chip('red', 'R'), RandomStrategy(), name: 'Adrian');
    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'Lara');
    var game = Connect4Game(player1, player2);
    addChips(game, [0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2,3, 4, 6]);
    var i = player2.strategy.nextMove(game);
    expect(game.frontier().contains(i), true);
    expect(game.nextRow(0), 6);
    expect(game.nextRow(1), 6);
    expect(game.nextRow(2), 4);
    expect(game.nextRow(3), 1);
    expect(game.nextRow(4), 1);
    expect(game.nextRow(5), 0);
    expect(game.nextRow(6), 1);
  });


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


  test('test frontier', (){
    var player1 = Player(Chip('red', 'R'), RandomStrategy(), name: 'A');
    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'B');
    var game = Connect4Game(player1, player2);
    addChips(game, [1,1,1,1,1]);
    expect(game.frontier().contains(1), true);
    addChips(game, [1]);
    expect(game.frontier().contains(1), false);
  });

  test('play foresight1/random game', (){
    var player1 = Player(Chip('red', 'R'), Foresight1Strategy(), name: 'A');
    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'B');
    var game = Connect4Game(player1, player2);
    addChips(game, [2,1,3,2,5,3]);
    //print(game.showBoard());
    expect(game.playerToMove.name, 'A');
    expect(game.playerToMove.strategy.nextMove(game), 4);
//    var outcome = game.play();
//    print(outcome);
  });
}

playMinmaxVsRandom() {
  var player1 = Player(Chip('red', 'R'), MinmaxStrategy(4), name: 'A');
  var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'B');
  var game = Connect4Game(player1, player2);
  game.play();
}


playForesight1VsRandom() {
  var n = 100;
  var outcomes = [];
  for (var i=0; i<n; i++) {
    var player1 = Player(Chip('red', 'R'), Foresight2Strategy(), name: 'A');
    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'B');
    var game = Connect4Game(player1, player2);
    //game.play();
    outcomes.add(game.play());
  }
  var res = count(outcomes);
  res.forEach((k,v) => print('$k: $v'));
}


main() {
//  tests();

//  playForesight1VsRandom();

  playMinmaxVsRandom();
}