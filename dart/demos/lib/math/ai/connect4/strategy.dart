
import 'dart:math' show Random;
import 'connect4.dart';

abstract class Strategy {
  String name;
  /// the location of the next chip
  int nextMove(Board board);
}

class RandomStrategy implements Strategy {
  String name;
  Random random;
  RandomStrategy() {
    name = 'Random strategy';
    random = Random();
  }
  int nextMove(Board board) => random.nextInt(board.nColumns);
}
