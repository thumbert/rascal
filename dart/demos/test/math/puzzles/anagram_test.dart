import 'package:demos/math/puzzles/anagram.dart';
import 'package:test/test.dart';

void tests() {
  // test('Basic tests', () {
  //   final puzzle = Anagram(['grow', 'trunk'], );

  // });

  test('Solve steven', () {
    final puzzle = Anagram(inputWords: ['steven'], solutionShape: [6]);
    expect(puzzle.checkSolution(['events']), true);
    var solutions = puzzle.generate(1000);
    print(solutions);
    expect(solutions.contains('events'), true);
  });

  test('Solve adrian', () {
    final puzzle = Anagram(inputWords: ['adrian'], solutionShape: [6]);
    var solutions = puzzle.generate(1000);
    expect(solutions.contains('radian'), true);
  });

  test('Solve grow trunk', () {
    final puzzle =
        Anagram(inputWords: ['grow', 'trunk'], solutionShape: [5, 4]);
    var solutions = puzzle.generate(10000);
    print(solutions);
    expect(solutions.contains('grunt work'), true);
  });

  test('Solve meet fit riot mom', () {
    final puzzle = Anagram(
        inputWords: ['meet', 'fit', 'riot', 'mom'],
        solutionShape: [4, 4, 2, 4]);
    var solutions = puzzle.generate(50000);
    expect(solutions.contains('emit time to from'), true);
    print(solutions);
  });

  test('Solve personal ad', () {
    final puzzle = Anagram(
        inputWords: ['raula', 'will', 'you', 'marry', 'me'],
        solutionShape: [1, 6, 4, 4, 4]);
    // var solutions = puzzle.generate(8000000);
    // print(solutions.join('\n'));
    // expect(solutions.contains('emit time to from'), true);
    // // 'i wall your male murray'  1,4,4,4,6
    // 'u really warm your mail'  1,4,4,4,6
    // 'u rally warm your email'  1,5,5,4,4
    // 'my rural email law your'  2,3,4,5,5
    // 'aim well your rural may'  3,3,4,4,5
    expect(puzzle.checkSolution(['u', 'really', 'warm', 'your', 'mail']), true);
    // expect(puzzle.checkSolution(['u', 'rally', 'warm', 'your', 'email']), true);

  });


}

void main() {
  tests();
}
