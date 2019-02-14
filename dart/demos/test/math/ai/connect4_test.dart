library test.math.ai.connect4;

import 'package:more/iterable.dart';
import 'package:test/test.dart';
import 'package:demos/math/ai/connect4/connect4.dart';
import 'package:demos/math/ai/connect4/strategy.dart';

/// Add a bunch a chips at once.
Board addChips(Board board, List<int> columnIds, Player player1, Player player2) {
  var players = cycle([player1,player2], columnIds.length);
  for (var e in indexed(players)) {
    board.addChip(columnIds[e.index], e.value);
  }
  return board;
}


tests() {
  var player1 = Player(Chip('red', 'R'), RandomStrategy(), name: 'A');
  var player2 = Player(Chip('yellow', 'Y'), RandomStrategy(), name: 'B');

  var game = Connect4Game(player1, player2);
  var board = game.board;
//  board.addChip(3, player1);
//  board.addChip(4, player2);
//  board.addChip(3, player1);
//  print(board);

  test('is winning 4-vertical', (){
    var game = Connect4Game(player1, player2);
    var board = game.board;
    board = addChips(board, [3, 0, 3, 1, 3, 4, 3], player1, player2);
    print(board);

  });


}


main() {
  tests();
}