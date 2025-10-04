import 'package:collection/collection.dart';
import 'package:more/more.dart';
import 'package:trotter/trotter.dart';

/// Solve the NYTimes Pips game.
/// https://www.nytimes.com/games/pips/hard
///

class Domino {
  Domino(this.first, this.second);
  int first;
  int second;
  Domino flip() => Domino(second, first);
  @override
  String toString() => '[$first|$second]';

  @override
  bool operator ==(Object other) {
    if (other is! Domino) return false;
    return first == other.first && second == other.second ||
        first == other.second && second == other.first;
  }

  @override
  int get hashCode {
    int minVal = first < second ? first : second;
    int maxVal = first > second ? first : second;
    return minVal * 10 + maxVal;
  }

  bool isDouble() => first == second;
}

Iterable<List<Domino>> permutations(List<Domino> xs) sync* {
  yield* _permutations(xs.length, xs);
}

Iterable<List<Domino>> _permutations(int level, List<Domino> elements) sync* {
  if (level == 0) {
    yield [];
  } else {
    for (var i = 0; i < elements.length; i++) {
      var el = elements[i];
      var rest = List<Domino>.from(elements)..removeAt(i);
      for (var perm in _permutations(level - 1, rest)) {
        yield [el, ...perm];
        if (!el.isDouble()) {
          yield [el.flip(), ...perm];
        }
      }
    }
  }
}

enum ConstraintState { satisfied, unsatisfied, undecidable }

abstract class Constraint {
  late List<String> cellIds;
  ConstraintState isSatisfied(Map<String, int> filledCells);
}

class ConstraintEqual extends Constraint {
  /// The values in the given cellIds must all be equal.
  ConstraintEqual(List<String> cellIds) {
    assert(cellIds.length >= 2);
    this.cellIds = cellIds;
  }

  ConstraintState isSatisfied(Map<String, int> filledCells) {
    if (cellIds.any((e) => !filledCells.containsKey(e))) {
      return ConstraintState.undecidable;
    }
    return cellIds.map((e) => filledCells[e]).toSet().length == 1
        ? ConstraintState.satisfied
        : ConstraintState.unsatisfied;
  }
}

class ConstraintNotEqual extends Constraint {
  /// The values in the given cellIds must all be different.
  ConstraintNotEqual(List<String> cellIds) {
    assert(cellIds.length >= 2);
    this.cellIds = cellIds;
  }

  ConstraintState isSatisfied(Map<String, int> filledCells) {
    if (cellIds.any((e) => !filledCells.containsKey(e))) {
      return ConstraintState.undecidable;
    }
    return cellIds.map((e) => filledCells[e]).toSet().length == cellIds.length
        ? ConstraintState.satisfied
        : ConstraintState.unsatisfied;
  }
}

class ConstraintSumEq extends Constraint {
  /// The sum of the values in the given cellIds must equal `total` value.
  ConstraintSumEq(List<String> cellIds, this.total) {
    this.cellIds = cellIds;
  }
  final int total;

  ConstraintState isSatisfied(Map<String, int> filledCells) {
    if (cellIds.any((e) => !filledCells.containsKey(e))) {
      return ConstraintState.undecidable;
    }
    return cellIds.map((e) => filledCells[e]!).reduce((a, b) => a + b) == total
        ? ConstraintState.satisfied
        : ConstraintState.unsatisfied;
  }
}

class ConstraintSumLt extends Constraint {
  /// The sum of the values in the given cellIds must be less than `total` value.
  ConstraintSumLt(List<String> cellIds, this.total) {
    this.cellIds = cellIds;
  }
  final int total;

  ConstraintState isSatisfied(Map<String, int> filledCells) {
    if (cellIds.any((e) => !filledCells.containsKey(e))) {
      return ConstraintState.undecidable;
    }
    return cellIds.map((e) => filledCells[e]!).reduce((a, b) => a + b) < total
        ? ConstraintState.satisfied
        : ConstraintState.unsatisfied;
  }
}

class ConstraintSumGt extends Constraint {
  /// The sum of the values in the given cellIds must be greater than `total` value.
  ConstraintSumGt(List<String> cellIds, this.total) {
    this.cellIds = cellIds;
  }
  final int total;

  ConstraintState isSatisfied(Map<String, int> filledCells) {
    if (cellIds.any((e) => !filledCells.containsKey(e))) {
      return ConstraintState.undecidable;
    }
    return cellIds.map((e) => filledCells[e]!).reduce((a, b) => a + b) > total
        ? ConstraintState.satisfied
        : ConstraintState.unsatisfied;
  }
}


class Puzzle<K extends Constraint> {
  /// A puzzle is defined by its links, dominoes, and constraints.
  ///
  Puzzle({
    required this.links,
    required this.dominoes,
    required this.constraints,
  }) {
    nodes = List.generate(dominoes.length * 2, (i) => String.fromCharCode(97 + i));
    assert(checkPuzzle());
  }
  final List<(String, String)> links;
  final List<Domino> dominoes;
  final List<K> constraints;

  late final List<String> nodes;

  // Solve the puzzle, returning a map of cellId to value.
  Map<String, int> solveBruteForce() {
    print('There are ${countCandidates()} candidates to check...');
    var all = permutations(dominoes);
    for (var permutation in all) {
      var values = permutation.expand((d) => [d.first, d.second]).toList();
      var candidate = Map.fromIterables(nodes, values);
      if (checkSolution(candidate)) {
        return candidate;
      }
    }

    return {};
  }

  // Solve the puzzle, returning a map of cellId to value.
  Map<String, int> solveHeuristic() {
    print('There are ${countCandidates()} candidates to check...');
    // look at the constraints and try to reduce the search space
    constraints.sortBy((c) => c.cellIds.length);
    // How to generate candidates that satisfy the constraints?
    var candidates = <Map<String, int>>[];

    var all = permutations(dominoes);
    for (var permutation in all) {
      var values = permutation.expand((d) => [d.first, d.second]).toList();
      var candidate = Map.fromIterables(nodes, values);
      if (checkSolution(candidate)) {
        return candidate;
      }
    }

    return {};
  }

  BigInt countCandidates() {
    return factorial(dominoes.length) *
        (BigInt.from(1) << dominoes.where((d) => !d.isDouble()).length);
  }

  bool checkSolution(Map<String, int> solution) {
    for (var constraint in constraints) {
      if (constraint.isSatisfied(solution) != ConstraintState.satisfied) {
        return false;
      }
    }
    return true;
  }

  /// Check if the puzzle is defined correctly.
  /// In particular, check that the pairs of adjacent nodes are valid dominoes.
  /// For example, if you must have a domino between two nodes, the two labels
  /// need to be adjacent.  So, it matters how you label the puzzle nodes.
  bool checkPuzzle() {
    if (nodes.length != dominoes.length * 2) {
      print(
        'Number of nodes ${nodes.length} does not match number of dominoes ${dominoes.length}.',
      );
      return false;
    }
    for (var chunk in nodes.chunked(2)) {
      var (a, b) = (chunk[0], chunk[1]);
      if (nodes.indexOf(b) - nodes.indexOf(a) != 1) {
        print(
          'Nodes ($a, $b) should be adjacent because they represent a domino.',
        );
        return false;
      }
    }

    // // check that the links are ordered (not really necessary, but easier to read)
    // for (var link in links) {
    //   var (a, b) = link;
    //   if (a.compareTo(b) > 0) {
    //     print('Link $link is not ordered.');
    //     return false;
    //   }
    // }

    return true;
  }
}
