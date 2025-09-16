/// Solve the NYTimes Pips game.
///
///

class Domino {
  Domino(this.first, this.second);
  int first;
  int second;
  Domino flip() => Domino(second, first);
}

class Constraint {}

class ConstraintEqual extends Constraint {
  ConstraintEqual(this.cellIds);
  final List<String> cellIds;
}

class ConstraintEqualValue extends Constraint {
  ConstraintEqualValue(this.cellIds, this.value);
  final List<String> cellIds;
  final int value;
}

class Puzzle<K extends Constraint> {
  Puzzle({
    required this.links,
    required this.dominoes,
    required this.constraints,
  });
  final List<(String, String)> links;
  final List<Domino> dominoes;
  final List<K> constraints;
}
