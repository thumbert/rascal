library test.pkg_petitparser.arithmetic_parser.arithmetic_parser_test;


import 'dart:math';

import 'package:petitparser/petitparser.dart';
import 'package:test/test.dart';
import 'arithmetic_parser.dart';


void tests() {
  group('Arithmetic parser:', () {
    var parser = ArithmeticParser();
    test('parse 1 + 2', () {
      var res = parser.parse('1+2');
      expect(res.value, 3);
    });
    test('parse 1 + 2 + 3', () {
      var res = parser.parse('(1+2)+3');
      expect(res.value, 6);
    });
    test('parse simple grouping', () {
      expect(parser.parse('(1)').value, 1);
      expect(parser.parse('(1 + 2)').value, 3);
    });
    test('parse number primitive', () {
      expect(parser.parse('3').value, 3);
      expect(parser.parse('3.14').value, 3.14);
      expect(parser.parse('-3.14').value, -3.14);
      expect(parser.parse('+3.14').value, 3.14);
      expect(parser.parse('3.14E0').value, 3.14);
    });

  });
}

void tests2() {
  final builder = ExpressionBuilder();

  builder.group()
    ..primitive(digit()
        .plus()
        .seq(char('.').seq(digit().plus()).optional())
        .flatten()
        .trim()
        .map((a) => num.tryParse(a)));



  builder.group()
    ..prefix(char('-').trim(), (op, a) => -a);

  // power is right-associative
  builder.group()
    ..right(char('^').trim(), (a, op, b) => pow(a, b));

  // multiplication and addition is left-associative
  builder.group()
    ..left(char('*').trim(), (a, op, b) => a * b)
    ..left(char('/').trim(), (a, op, b) => a / b);
  builder.group()
    ..left(char('+').trim(), (a, op, b) => a + b)
    ..left(char('-').trim(), (a, op, b) => a - b);

  final parser = builder.build();

  test('parse -8', () => expect(parser.parse('-8').value, -8));
  test('parse 1 + 2 * 3', () => expect(parser.parse('1 + 2 * 3').value, 7));
  test('parse 1 * 2 + 3', () => expect(parser.parse('1 * 2 + 3').value, 5));
  test('parse 8/4/2', () => expect(parser.parse('8/4/2').value, 1));
  test('parse 2^2^3', () => expect(parser.parse('2^2^3').value, 256));
}

void main() {
  tests();

//  tests2();
}
