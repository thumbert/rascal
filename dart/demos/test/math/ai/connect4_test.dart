library test.math.ai.connect4;

import 'package:tuple/tuple.dart';
import 'package:more/iterable.dart';
import 'package:dama/basic/count.dart';
import 'package:test/test.dart';
import 'package:demos/math/ai/connect4/connect4.dart';
import 'package:demos/math/ai/connect4/strategy.dart';

/// Add a bunch a chips at once.
Board addChips(Board board, List<int> columnIds, Player player1, Player player2) {
  var players = [player1, player2];
  for (var e in indexed(columnIds)) {
    var player = players[e.index % 2];
    board.addChip(e.value, player);
  }
  return board;
}


tests() {

//  var board = game.board;
//  board.addChip(3, player1);
//  board.addChip(4, player2);
//  board.addChip(3, player1);
//  print(board);

  test('is winning 4-vertical', (){
    var player1 = Player(Chip('red', 'R'), RandomStrategy(), name: 'A');
    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'B');
    var game = Connect4Game(player1, player2);
    addChips(game.board, [3, 0, 3, 1, 3, 4, 3], player1, player2);
//    print(game.board);
//    print(player1.coordinates);
    expect(player1.coordinates.contains(Tuple2(0,3)), true);
    expect(player1.coordinates.length, 4);
    expect(player2.coordinates.length, 3);
    expect(game.board.isWinner(player1), true);
  });

  test('is winning 4-horizontal', (){
    var player1 = Player(Chip('red', 'R'), RandomStrategy(), name: 'A');
    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'B');
    var game = Connect4Game(player1, player2);
    addChips(game.board, [0, 1, 0, 2, 1, 3, 2, 4], player1, player2);
    expect(player1.coordinates.contains(Tuple2(0,0)), true);
    expect(player1.coordinates.length, 4);
    expect(player2.coordinates.length, 4);
    expect(game.board.isWinner(player2), true);
  });

  test('is winning slope +1', (){
    var player1 = Player(Chip('red', 'R'), RandomStrategy(), name: 'A');
    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'B');
    var game = Connect4Game(player1, player2);
    addChips(game.board, [0, 1, 1, 2, 5, 2, 2, 3, 6, 3, 5, 3, 3], player1, player2);
//    print(game.board);
//    print(player1.coordinates);
    expect(game.board.isWinner(player1), true);
  });

  test('play game', (){
    var player1 = Player(Chip('red', 'R'), RandomStrategy(), name: 'A');
    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'B');
    var game = Connect4Game(player1, player2);
    var outcome = game.play();
    print(game.board);
    print(outcome);
  });
}


compareStrategies() {
  var n = 1000;
  var outcomes = [];
  for (var i=0; i<n; i++) {
    var player1 = Player(Chip('red', 'R'), RandomStrategy(), name: 'A');
    var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'B');
    var game = Connect4Game(player1, player2);
    outcomes.add(game.play());
  }
  var res = count(outcomes);
  res.forEach((k,v) => print('$k: $v'));
}


main() {
  //tests();

  compareStrategies();
}