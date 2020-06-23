library test.file.read_file_test;

import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';

/// Read a big CSV file line by line and process it.
Future<List<List>> readBigFile(File file) async {
  var converter = CsvToListConverter();
  var input = file.openRead();

  var out = <List>[];

  /// process file line by line
  await input
      .transform(utf8.decoder)
      .transform(LineSplitter())
      .forEach((line) {
        var xs = converter.convert(line).first;
        print(xs);
        out.add(xs);
  });

  return out;
}
