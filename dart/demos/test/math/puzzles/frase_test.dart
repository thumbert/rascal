import 'package:demos/math/puzzles/frase.dart';
import 'package:test/test.dart';

final games = [
  {
    'inputWords': ['meet', 'fit', 'riot', 'mom'],
    'solutionShape': [4, 4, 2, 4],
  },
  {
    'inputWords': ['grow', 'trunk'],
    'solutionShape': [5, 4],
    'solution': ['grunt', 'work'],
  }
];

void tests() {
  test('Basic tests', () {
    // final puzzle =
    //     Frase(inputWords: ['meet', 'fit', 'riot', 'mom'], shape: [4, 4, 2, 4]);
    // expect(puzzle.letters,
    //     {'m': 3, 'e': 2, 't': 3, 'o': 2, 'i': 2, 'r': 1, 'f': 1});

    final puzzle = Frase(inputWords: ['grow', 'trunk'], solutionShape: [5, 4]);
    expect(puzzle.letters,
        {'g': 1, 'k': 1, 'n': 1, 'r': 2, 'o': 1, 'w': 1, 't': 1, 'u': 1});

    var allWords = puzzle.readWordList();
    expect(allWords.length, 370105);

    // Filter the words to only those that are 2 or 4 letters long
    // and contain only the letters in the puzzle
    var dict = ['riot', 'me', 'acne', 'acre', 'acoustic'];
    var xs = puzzle.filterWords(dict,
        wordLengths: [2, 4],
        validLetters: ['m', 'e', 'r', 'o', 'i', 't', 'f', 't']);
    expect(xs, ['riot', 'me']);

    // Filter the words to only those that have the correct letter frequencies
    var filtered = puzzle.filterWords(allWords,
        wordLengths: puzzle.solutionShape, letterFrequencies: puzzle.letters);
    // print(filtered.join('\n'));
    expect(filtered.length, 77);

    // Check solution
    expect(puzzle.checkSolution(['grunt', 'work']), true);
    expect(puzzle.checkSolution(['grown', 'gunk']), false);
    expect(puzzle.checkSolution(['gout', 'wrong']), false);
  });

  test('Solve meet fit riot mom', () {
    final puzzle = Frase(
        inputWords: ['meet', 'fit', 'riot', 'mom'],
        solutionShape: [4, 4, 2, 4]);
    // This takes a long time to churn through, and finds a lot of silly 
    // solutions.  
    // Several ideas to speed this up:
    // - sort the list of words by frequency
    // - generate only combinations that have the right word lengths
    //    
    var solutions = puzzle.solve();
    print('Done');
    expect(solutions.length, 4);
  });

  test('Solve grunt work', () {
    final puzzle = Frase(inputWords: ['grow', 'trunk'], solutionShape: [5, 4]);
    var solutions = puzzle.solve();
    print('Done');
    expect(solutions.length, 4);
  });
}

void main() {
  tests();
}
