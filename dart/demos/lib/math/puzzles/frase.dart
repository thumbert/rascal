import 'dart:io';

import 'package:collection/collection.dart' as collection;
import 'package:trotter/trotter.dart';
import 'package:more/more.dart';

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
  Frase({required this.inputWords, required this.solutionShape}) {
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

  final List<String> inputWords;
  final List<int> solutionShape;
  late final Map<String, int> letters;

  // the puzzle solution (can be multiple)

  List<List<String>> solve() {
    // Create a list of all the words that match the shape
    var allWords = readWordListFrequency();
    var filtered = filterWords(allWords.keys.toList(),
        wordLengths: solutionShape, letterFrequencies: letters);
    filtered.removeWhere((e) => inputWords.contains(e));
    // Sort the valid words by frequency
    filtered.sort((a, b) {
      var aFreq = allWords[a] ?? 0;
      var bFreq = allWords[b] ?? 0;
      return bFreq.compareTo(aFreq);
    });

    var solutions = <List<String>>[];
    // Construct all possible solutions by generating sets of words with correct
    // word lengths.
    // var wordLengthCount = collection
    //     .groupBy(solutionShape, (e) => e)
    //     .map((k, v) => MapEntry(k, v.length));
    // var allCombinations = wordLengthCount.map((k, v) => MapEntry(
    //     k, Combinations(v, filtered.where((e) => e.length == k).toList())));

    // var xs = allCombinations.values.map((e) => e()).toList();
    // for (var e in xs[0]) {
    //   for (var f in xs[1]) {
    //     var proposed = [...e, ...f];
    //     // print(proposed);
    //     // need to make sure that the proposed words are in the shape needed!
    //     if (checkSolution(proposed)) {
    //       print('Found a solution: $proposed');
    //       solutions.add(proposed);
    //     }
    //   }
    // }

    // for (var x in xs) {
    //   var proposed = <String>[];
    //   for (var choice in x) {
    //     proposed.addAll(choice);
    //   }
    //   print(proposed);
    //   if (checkSolution(proposed)) {
    //     print('Found a solution: $proposed');
    //     solutions.add(proposed);
    //   }
    // }

    // brute force
    var combinations = Combinations(solutionShape.length, filtered);
    print('Checking ${combinations.length} possible combinations ...');
    for (final proposed in combinations()) {
      // print(proposed);
      if (checkSolution(proposed)) {
        print('Found a solution: $proposed');
        solutions.add(proposed);
        // break;
      }
    }

    return solutions;
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

  List<String> readWordList() {
    // final file =
    //     File('/home/adrian/Downloads/Archive/Words/wordlist_10000.txt');
    final file = File('/home/adrian/Downloads/Archive/Words/words_alpha.txt');
    final lines = file.readAsLinesSync();
    final words = <String>[];
    for (var line in lines) {
      final word = line.trim();
      words.add(word);
    }
    return words;
  }

  Map<String, int> readWordListFrequency() {
    final file = File('/home/adrian/Downloads/Archive/Words/unigram_freq.csv');
    final lines = file.readAsLinesSync();
    final words = <String, int>{};
    for (var line in lines.skip(1)) {
      final xs = line.trim().split(',');
      words[xs[0]] = int.parse(xs[1]);
    }
    return words;
  }
}
