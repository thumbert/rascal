
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

  // if the column is filled, pick another column
  int nextMove(Board board) {
    bool isOk;
    int columnIndex;
    do {
      columnIndex = random.nextInt(board.nColumns);
      isOk = !board.columns[columnIndex].isFilled;
    } while (!isOk);

    return columnIndex;
  }
}
