
import 'chip.dart';
import 'strategy.dart';

class Player {
  final String name;
  final Chip chip;
  final Strategy strategy;

  Player(this.chip, this.strategy, {this.name});

  @override
  String toString() {
    return 'Player: $name, chip: {${chip.toString()}}';
  }
}

