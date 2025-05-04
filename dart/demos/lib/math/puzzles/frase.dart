/// This is a solver for the Frase puzzle from forbes.com
/// Given a set of letters, the goal is to find a phrase that can be formed
/// using those letters.  You are given the shape of the phrase, but not
/// the letters.
///
/// For example, given the letters:
///   {'M': 3, 'E': 2, 'T': 3, 'O': 2, 'I': 2, 'R': 1, 'F': 1}
/// Construct a phrase with words of length: [4, 4, 2, 4] which uses
/// all the letters exactly once.
///
///
class Frase {
  Frase({required this.inputWords, required this.shape}) {
    var letters = <String, int>{};
    for (var word in inputWords) {
      for (var letter in word.split('')) {
        letters[letter] = (letters[letter] ?? 0) + 1;
      }
    }
    this.letters = letters;
    assert(letters.values.fold(0, (a, b) => a + b) == shape.fold(0, (a, b) => a + b));
  }

  final List<String> inputWords;
  final List<int> shape;
  late final Map<String, int> letters;

  List<String> solve() {
    var solution = <String>[];

    return solution;
  }
}
