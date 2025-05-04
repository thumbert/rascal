import 'dart:io';

import 'package:collection/collection.dart' as collection;

class Anagram {
  Anagram({required this.inputWords, required this.solutionShape}) {
    var letters = <String, int>{};
    for (var word in inputWords) {
      for (var letter in word.split('')) {
        letters[letter] = (letters[letter] ?? 0) + 1;
      }
    }
    this.letters = letters;
    assert(letters.values.fold(0, (a, b) => a + b) ==
        solutionShape.fold(0, (a, b) => a + b));
  }

  List<String> inputWords;
  // How many words and what length should each word be?
  List<int> solutionShape;
  late final Map<String, int> letters;

  // Possible candidate words
  late final Map<int, List<String>> filteredWords;

  /// Generate a list of words that can be formed from the letters in the
  /// input words.
  List<String> generate(int threshold) {
    // Create a list of all the words that match the shape
    var allWords = readWordListFrequency(threshold);
    var filtered = filterWords(allWords.keys.toList(),
        wordLengths: solutionShape, letterFrequencies: letters);
    // Remove the input words from the list
    filtered.removeWhere((e) => inputWords.contains(e));
    // Sort the valid words by frequency
    filtered.sort((a, b) {
      var aFreq = allWords[a] ?? 0;
      var bFreq = allWords[b] ?? 0;
      return bFreq.compareTo(aFreq);
    });
    filteredWords = collection.groupBy(filtered, (e) => e.length);

    var index = 0;
    var partialSolutions =
        (filteredWords[solutionShape[0]] ?? []).map((e) => [e]).toList();
    var solutions = getNextValidWords(index + 1, partialSolutions);

    return solutions.map((e) => e.join(' ')).toList();
  }

  /// Index is the index of the word in the solution
  List<List<String>> getNextValidWords(
      int index, List<List<String>> partialSolutions) {
    if (index == solutionShape.length) {
      return partialSolutions.where((e) => checkSolution(e)).toList();
    }

    /// Get the new list of words with the correct length
    var newWords = filteredWords[solutionShape[index]] ?? [];
    if (newWords.isEmpty) {
      return [];
    }

    /// Do all the filtering you can to trim the new list further.
    var propagatingSolutions = <List<String>>[];
    for (var newWord in newWords) {
      for (var partialSolution in partialSolutions) {
        if (checkLetterConsistency([...partialSolution, newWord])) {
          propagatingSolutions.add([...partialSolution, newWord]);
        }
      }
    }
    print(
        'Found ${propagatingSolutions.length} partial solutions for depth: $index');
    // print(propagatingSolutions.join('\n'));
    return getNextValidWords(index + 1, propagatingSolutions);
  }

  bool checkSolution(List<String> words) {
    // Check that the words match the shape
    if (words.length != solutionShape.length) {
      return false;
    }
    for (var i = 0; i < words.length; i++) {
      if (words[i].length != solutionShape[i]) {
        return false;
      }
    }
    // Check that the letters match
    var letters = <String, int>{};
    for (var word in words) {
      for (var letter in word.split('')) {
        letters[letter] = (letters[letter] ?? 0) + 1;
      }
    }
    return const collection.MapEquality().equals(letters, this.letters);
  }

  /// Check that the letters of the [candidateWords] are consistent with the
  /// input words of the anagram.
  ///
  bool checkLetterConsistency(List<String> candidateWords) {
    var letters = <String, int>{};
    for (var word in candidateWords) {
      for (var letter in word.split('')) {
        letters[letter] = (letters[letter] ?? 0) + 1;
      }
    }
    for (var entry in letters.entries) {
      if (this.letters[entry.key] == null) {
        return false;
      }
      if (entry.value > (this.letters[entry.key] ?? 0)) {
        return false;
      }
    }
    return true;
  }

  /// Filter a word list according to several criteria
  /// For example, to filter a list of words to only those that have 2 or 4
  /// letters long, use:
  /// `filterWords(words, wordLengths: [2, 4])`
  ///
  List<String> filterWords(List<String> words,
      {List<int>? wordLengths,
      List<String>? validLetters,
      Map<String, int>? letterFrequencies}) {
    final filtered = [...words];
    // Filter by word length
    if (wordLengths != null) {
      filtered.removeWhere((word) => !wordLengths.contains(word.length));
    }
    // Filter by letters
    if (letterFrequencies != null) {
      validLetters = letterFrequencies.keys.toList();
    }
    if (validLetters != null) {
      filtered.removeWhere((word) {
        for (var letter in word.split('')) {
          if (!validLetters!.contains(letter)) {
            return true;
          }
        }
        return false;
      });
    }
    // Filter by letter frequencies
    if (letterFrequencies != null) {
      filtered.removeWhere((word) {
        final frequencies = <String, int>{};
        for (var letter in word.split('')) {
          frequencies[letter] = (frequencies[letter] ?? 0) + 1;
        }
        for (var entry in frequencies.entries) {
          if (entry.value > letterFrequencies[entry.key]!) {
            return true;
          }
        }
        return false;
      });
    }
    return filtered;
  }

  Map<String, int> readWordListFrequency(int threshold) {
    final file = File('/home/adrian/Downloads/Archive/Words/unigram_freq.csv');
    final lines = file.readAsLinesSync();
    final words = <String, int>{};
    for (var line in lines.skip(1)) {
      final xs = line.trim().split(',');
      final count = int.parse(xs[1]);
      if (count > threshold) {
        words[xs[0]] = int.parse(xs[1]);
      }
    }
    return words;
  }
}
