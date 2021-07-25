// library test.pkg_petitparser.arithmetic_parser.arithmetic_parser;
//
// import 'package:petitparser/petitparser.dart';
//
// /// An example of arithmetic parser
// /// http://www2.lawrence.edu/fast/GREGGJ/CMSC270/parser/parser.html
// /// See https://craftinginterpreters.com/parsing-expressions.html
//
// class ArithmeticGrammar extends GrammarParser {
//   ArithmeticGrammar() : super(const ArithmeticGrammarDefinition());
// }
//
// class ArithmeticGrammarDefinition extends GrammarDefinition {
//   const ArithmeticGrammarDefinition();
//   @override
//   Parser start() => ref(statement).end();
//
//   Parser token(Object source, [String name]) {
//     if (source is String) {
//       return source.toParser(message: 'Expected ${name ?? source}').trim();
//     } else if (source is Parser) {
//       ArgumentError.checkNotNull(name, 'name');
//       return source.flatten('Expected $name').trim();
//     } else {
//       throw ArgumentError('Unknow token type: $source.');
//     }
//   }
//
//
//   Parser statement() => ref(assignment) | ref(calculation);
//   Parser assignment() => variable() & char('=') & sum();
//   Parser calculation() => sum();
//   Parser variable() => letter() & (letter() | digit()).star();
//
//   Parser number() =>
//       pattern('+-').optional() &
//       char('0').or(digit().plus()) &
//       char('.').seq(digit().plus()).optional() &
//       pattern('eE')
//           .seq(pattern('-+').optional())
//           .seq(digit().plus())
//           .optional();
//
//   Parser lrTerm() => ref(number).trim();
//   Parser sum() => product() & (char('*') | char('/')) & factor()
//   Parser product() => factor();
//   Parser factor() => power() | term();
//   Parser power() => term() & char('^') & factor();
//   Parser term() => ref(group) | ref(number);
//   Parser group() => char('(') & ref(sum) & char(')');
//
//
// //Parser binary() => ref(lrTerm) & ref(operator) & ref(lrTerm);
// //  Parser operator() => char('+') | char('-') | char('*') | char('/');
// }
//
// class ArithmeticParser extends GrammarParser {
//   ArithmeticParser() : super(const ArithmeticParserDefinition());
// }
//
// class ArithmeticParserDefinition extends ArithmeticGrammarDefinition {
//   const ArithmeticParserDefinition();
//
//   @override
//   Parser number() {
//     return super.number().map((each) {
//       var value = _flatten(each);
//       final floating = double.parse(value);
//       final integral = floating.toInt();
//       if (floating == integral && value.indexOf('.') == -1) {
//         return integral;
//       } else {
//         return floating;
//       }
//     });
//   }
//
//   Parser operator() {
// //    print('in operator');
//     return super.operator().map((each) => each);
//   }
//
//   Parser binary() {
// //    print('in binary');
//     return super.binary().map((each) {
//       if (each[1] == '+') {
//         return each[0] + each[2];
//       }
//       print(each);
//     });
//   }
//
//   Parser lrTerm() {
//     return super.lrTerm().map((each) {
//       if (each is num) {
//         return each;
//       } else {
//         print(each);
//         return -999;
//       }
//     });
//   }
//
//
//   Parser group() {
//     return super.group().map((each) {
//       if (each[1] is num) return each[1];
//       else {
//         return _flatten(each).toString();
//       }
//     });
//   }
// }
//
// String _flatten(List xs) {
//   var out = '';
//   if (xs.isEmpty) return out;
//   for (var x in xs) {
//     if (x == null) continue;
//     if (x is String)
//       out += x;
//     else {
//       out += _flatten(x);
//     }
//   }
//   return out;
// }
