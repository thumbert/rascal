import 'package:demos/math/puzzles/pips.dart';
import 'package:test/test.dart';

void tests() {
  test('Puzzle 2025-09-16, easy', () {
    final links = [
      ('a', 'b'),
      ('b', 'c'),
      ('c', 'd'),
      ('d', 'e'),
      ('e', 'f'),
      ('f', 'g'),
      ('g', 'h'),
      ('h', 'i'),
      ('i', 'j'),
      ('j', 'k'),
      ('k', 'l'),
      ('l', 'a'),
    ];
    final constraints = <Constraint>[
      ConstraintEqual(['b', 'c', 'd', 'e']),
      ConstraintSumEq(['f', 'g'], 11),
      ConstraintSumEq(['h', 'i'], 4),
    ];
    final dominoes = [
      Domino(4, 2),
      Domino(6, 1),
      Domino(4, 4),
      Domino(1, 1),
      Domino(1, 5),
      Domino(2, 6),
    ];
    final trueSolution = <String, int>{
      'a': 6,
      'b': 1,
      'c': 1,
      'd': 1,
      'e': 1,
      'f': 5,
      'g': 6,
      'h': 2,
      'i': 2,
      'j': 4,
      'k': 4,
      'l': 4,
    };

    final puzzle = Puzzle(
      links: links,
      dominoes: dominoes,
      constraints: constraints,
    );
    print(puzzle.checkSolution(trueSolution));
    final foundSolution = puzzle.solveBruteForce();
    print(foundSolution);
    expect(foundSolution, trueSolution);
  });
  test('Puzzle 2025-09-20, medium', () {
    final links = [
      ('a', 'b'),
      ('b', 'c'),
      ('c', 'd'),
      //
      ('a', 'i'),
      ('c', 'e'),
      ('j', 'k'),
      //
      ('j', 'k'),
      ('h', 'i'),
      ('e', 'f'),
      ('f', 'g'),
      ('g', 'h'),
      ('h', 'k'),
      //
      ('k', 'l'),
    ];
    final constraints = <Constraint>[
      ConstraintSumEq(['a', 'i', 'h'], 4),
      ConstraintEqual(['b', 'c', 'e']),
      ConstraintSumEq(['d'], 1),
      ConstraintSumEq(['g', 'f'], 7),
      ConstraintSumEq(['j'], 1),
      ConstraintEqual(['k', 'l']),
    ];
    final dominoes = [
      Domino(3, 2),
      Domino(0, 1),
      Domino(1, 4),
      Domino(2, 1),
      Domino(1, 1),
      Domino(2, 2),
    ];
    final trueSolution = <String, int>{
      'a': 0,
      'b': 1,
      'c': 1,
      'd': 1,
      'e': 1,
      'f': 4,
      'g': 3,
      'h': 2,
      'i': 2,
      'j': 1,
      'k': 2,
      'l': 2,
    };
    final puzzle = Puzzle(
      links: links,
      dominoes: dominoes,
      constraints: constraints,
    );
    final foundSolution = puzzle.solveBruteForce();
    print(foundSolution);
    expect(foundSolution, trueSolution);
  });

  test('Puzzle 2025-09-20, hard', () {
    final links = [
      ('a', 'b'),
      ('b', 'c'),
      ('c', 'd'),
      ('d', 'e'),
      ('e', 'f'),
      //
      ('c', 'g'),
      ('d', 'h'),
      ('g', 'h'),
      //
      ('h', 'i'),
      ('i', 'j'),
      //
      ('j', 'k'),
      ('k', 'l'),
      ('l', 'm'),
      ('m', 'n'),
      ('o', 'p'),
      ('p', 'r'),
      //
      ('r', 's'),
      ('o', 't'),
      ('j', 'v'),
      ('k', 'y'),
      //
      ('t', 'u'),
      ('v', 'x'),
      ('y', 'z'),
      ('u', 'x'),
      ('x', 'z'),
      //
    ];
    final constraints = <Constraint>[
      ConstraintSumEq(['a'], 1),
      ConstraintSumEq(['c', 'g'], 12),
      ConstraintSumEq(['d', 'e'], 9),
      ConstraintNotEqual(['h', 'i']),
      ConstraintSumEq(['p', 'r'], 5),
      ConstraintSumEq(['j', 'o', 't', 'v'], 0),
      ConstraintSumEq(['u', 'x', 'z'], 3),
      ConstraintEqual(['k', 'l', 'm', 'y']),
    ];
    final dominoes = [
      Domino(0, 1),
      Domino(0, 2),
      Domino(0, 3),
      Domino(0, 5),
      Domino(1, 1),
      Domino(5, 5),
      Domino(6, 5),
      Domino(6, 3),
      Domino(1, 3),
      Domino(6, 2),
      Domino(1, 2),
      Domino(0, 6),
    ];
    // final trueSolution = <String, int>{
    //   'a': 0,
    //   'b': 1,
    //   'c': 1,
    //   'd': 1,
    //   'e': 1,
    //   'f': 4,
    //   'g': 3,
    //   'h': 2,
    //   'i': 2,
    //   'j': 1,
    //   'k': 2,
    //   'l': 2,
    // };
    final puzzle = Puzzle(
      links: links,
      dominoes: dominoes,
      constraints: constraints,
    );
    final foundSolution = puzzle.solveBruteForce();
    print(foundSolution);
    // expect(foundSolution, trueSolution);
  });

  test('Puzzle 2025-09-21, hard', () {
    final links = <(String,String)>[
      // ('a', 'b'),
      // ('b', 'c'),
      // ('c', 'd'),
      // ('d', 'e'),
      // ('e', 'f'),
      // //
      // ('c', 'g'),
      // ('d', 'h'),
      // ('g', 'h'),
      // //
      // ('h', 'i'),
      // ('i', 'j'),
      // //
      // ('j', 'k'),
      // ('k', 'l'),
      // ('l', 'm'),
      // ('m', 'n'),
      // ('o', 'p'),
      // ('p', 'r'),
      // //
      // ('r', 's'),
      // ('o', 't'),
      // ('j', 'v'),
      // ('k', 'y'),
      // //
      // ('t', 'u'),
      // ('v', 'x'),
      // ('y', 'z'),
      // ('u', 'x'),
      // ('x', 'z'),
      //
    ];
    final constraints = <Constraint>[
      ConstraintEqual(['a', 'b']),
      ConstraintSumEq(['c'], 3),
      ConstraintSumEq(['d'], 5),
      ConstraintSumEq(['e'], 1),
      ConstraintSumEq(['f', 'k', 'q'], 18),
      ConstraintSumEq(['g'], 3),
      ConstraintSumLt(['h'], 4),
      ConstraintNotEqual(['i', 'j', 'n', 'o', 'p']),
      ConstraintSumGt(['m'], 4),
      ConstraintSumEq(['l', 'r'], 10),
      ConstraintSumEq(['s'], 2),
      ConstraintSumEq(['t', 'w', 'x'], 0),
      ConstraintSumEq(['u'], 4),
      ConstraintSumEq(['v'], 1),
    ];
    final dominoes = [
      Domino(2, 1),
      Domino(6, 0),
      Domino(5, 5),
      Domino(3, 1),
      Domino(4, 4),
      Domino(6, 1),
      Domino(0, 0),
      Domino(3, 4),
      Domino(2, 5),
      Domino(3, 6),
      Domino(6, 6),
      Domino(4, 5),
    ];
    final trueSolution = <String, int>{
      'a': 4,
      'b': 4,
      'c': 3,
      'd': 5,
      'e': 1,
      'f': 6,
      'g': 3,
      'h': 1,
      'i': 4,
      'j': 2,
      'k': 6,
      'l': 5,
      'm': 6,
      'n': 5,
      'o': 6,
      'p': 3,
      'q': 6,
      'r': 5,
      's': 2,
      't': 0,
      'u': 4,
      'v': 1,
      'w': 0,
      'x': 0,
    };
    final puzzle = Puzzle(
      links: links,
      dominoes: dominoes,
      constraints: constraints,
    );
    print(puzzle.checkSolution(trueSolution));
  });
}

void main() {
  tests();
}
