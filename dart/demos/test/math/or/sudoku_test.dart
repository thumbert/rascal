// library test.math.or.sudoku;



// import 'package:demos/math/or/sudoku.dart';

// /// trivial board, just applying constraints will solve it
// String boardEasy1() {
//   String input = """
//   003020600
//   900305001
//   001806400
//   008102900
//   700000008
//   006708200
//   002609500
//   800203009
//   005010300
//   """;

//   return input;
// }

// String boardEasy2() {
//   String input = """
//   692500000
//   000000000
//   040700008
//   000000000
//   476000500
//   300040100
//   000009020
//   200006034
//   010080090
//   """;

//   return input;
// }



// /// medium hard
// String boardMedium1() {
//   String input = """
//   060104050
//   008305600
//   200000001
//   800407006
//   006000300
//   700901004
//   500000002
//   007206900
//   040508070
//   """;

//   return input;
// }

// /// not easy
// String board4() {
//   String input = """
//   006007300
//   018009050
//   500000064
//   920080000
//   000763000
//   000090075
//   630000008
//   090300520
//   002400600
//   """;

//   return input;
// }

// /// From http://www.247sudoku.com/sudokuExpert.php
// String boardExpert1() {
//   String input = """
//   480050000
//   000004900
//   090000007
//   200600000
//   000090506
//   070000004
//   620007040
//   004100308
//   000305000
//   """;

//   return input;
// }


// /// From Corinna.  Fails.
// /// (0,5):[4,8] and (1,5):[4,8].  I eliminate 4 from (0,5)
// /// but it does not eliminate the 8 from (1,5) when I enforce the constraints!
// String boardFiendiesh1() {
//   String input = """
//   000500070
//   706000090
//   480039000
//   500027000
//   001040300
//   000180005
//   000370014
//   040000607
//   010002000
//   """;

//   return input;
// }


// /// hard, really hard.  From Norvig.
// String boardFiendiesh2() {
//   String input = """
//   850002400
//   720000009
//   004000000
//   000107002
//   305000900
//   040000000
//   000080070
//   017000000
//   000036040
//   """;

//   return input;
// }

// String c2() {
//   String input = """
//   850002400
//   """;

//   return input;
// }


// main() {

//   Board b = new Board.fromString(boardFiendiesh1());
//   print(b.toString());
//   print('Number of single cells: ${b.numberOfSingleCells()}');

//   //b.cells.forEach((k,v) => print('$k: $v'));

//   ///b.peers.forEach((k,v) => print('$k: $v'));

//   ///print(b.peers[new Coord(0,0)]);

//   print('Enforcing constraints');
//   b.enforceConstraintsAll();


//   print('Is the board solved? ${b.isSolved()}');
//   print(b.toString());
//   ///b.cells.forEach((k,v) => print('$k: $v'));


//   b.solve();
//   print('Is the board solved? ${b.isSolved()}');
//   print(b.toString());


// }