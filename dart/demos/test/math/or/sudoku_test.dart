library test.math.or.sudoku;


import 'package:demos/math/or/sudoku.dart';

String board1() {
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

main() {

  Board b = new Board.fromString(board1());

  b.cells.forEach((k,v) => print('$k: $v'));
  print('Enforcing constraints');

  print(b.isSolved());
}