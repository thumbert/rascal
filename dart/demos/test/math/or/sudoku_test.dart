library test.math.or.sudoku;

import 'package:tuple/tuple.dart';


import 'package:demos/math/or/sudoku.dart';

/// trivial board, just applying constraints will solve it
String boardEasy1() {
  String input = """
  003020600
  900305001
  001806400
  008102900
  700000008
  006708200
  002609500
  800203009
  005010300
  """;

  return input;
}

String boardEasy2() {
  String input = """
  692500000
  000000000
  040700008
  000000000
  476000500
  300040100
  000009020
  200006034
  010080090
  """;

  return input;
}



/// hard, really hard
board2() {
  String input = """
  400000805
  030000000
  000700000
  020000060
  000080400
  000010000
  000603070
  500200000
  104000000
  """;

  return input;
}

/// medium hard
board3() {
  String input = """
  060104050
  008305600
  200000001
  800407006
  006000300
  700901004
  500000002
  007206900
  040508070
  """;

  return input;
}

/// not easy
String board4() {
  String input = """
  006007300
  018009050
  500000064
  920080000
  000763000
  000090075
  630000008
  090300520
  002400600
  """;

  return input;
}


main() {

  Board b = new Board.fromString(boardEasy2());
  print(b.toString());
  print('Number of single cells: ${b.numberOfSingleCells()}');

  //b.cells.forEach((k,v) => print('$k: $v'));

  ///b.peers.forEach((k,v) => print('$k: $v'));

  ///print(b.peers[new Coord(0,0)]);

  print('Enforcing constraints');
  b.enforceConstraintsAll();


  print('Is the board solved? ${b.isSolved()}');
  print(b.toString());
  b.cells.forEach((k,v) => print('$k: $v'));


  b.solve();
  print('Is the board solved? ${b.isSolved()}');



}