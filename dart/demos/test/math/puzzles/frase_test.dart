
import 'package:demos/math/puzzles/frase.dart';
import 'package:test/test.dart';

void tests() {
  test('Frase #760', () {
    final frase = Frase(inputWords: ['meet', 'fit', 'riot', 'mom'], shape: [4, 4, 2, 4]);
    expect(frase.letters, {
      'M': 3,
      'E': 2,
      'T': 3,
      'O': 2,
      'I': 2,
      'R': 1,
      'F': 1
    });

    // expect(frase.getFrase(), 'Hello, World!');
  });
}

void main() {
  tests();
}