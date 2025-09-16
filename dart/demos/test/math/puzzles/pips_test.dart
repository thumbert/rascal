import 'package:demos/math/puzzles/pips.dart';
import 'package:test/test.dart';

void tests() {
  test('Puzzle 0', () {
    final links = [
      ('a', 'b'),
      ('b', 'c'),
      ('c', 'd'),
      ('c', 'e'),
      ('e', 'f'),
      ('e', 'g'),
      ('c', 'h'),
    ];
    final constraints = <Constraint>[
      ConstraintEqualValue(['a'], 5),
      ConstraintEqualValue(['g'], 5),
      ConstraintEqual(['b', 'c', 'h']),
      ConstraintEqual(['e', 'f']),
    ];
    final dominoes = [Domino(0, 5), Domino(4, 4), Domino(0, 2), Domino(3, 5)];

    final puzzle = Puzzle(
      links: links,
      dominoes: dominoes,
      constraints: constraints,
    );
    // expect(puzzle.checkSolution(['events']), true);
    // var solutions = puzzle.generate(1000);
    // print(solutions);
    // expect(solutions.contains('events'), true);
  });
}

void main() {
  tests();
}
