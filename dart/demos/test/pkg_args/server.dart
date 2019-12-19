import 'dart:io';

import 'package:args/args.dart';

/// An example of using the args package
///

main(List<String> args) {
  var parser = ArgParser()
    ..addOption('env', defaultsTo: 'prod', allowed: ['prod', 'test'])
    ..addFlag('help', abbr: 'h');

  var results = parser.parse(args);
  if (results['help']) {
    print("""
Start the Dart server.
Flags:
--help or -h
  Display this message.
--env=<environment>
  The environment to run.  Supported values are 'prod' and 'test'. 
  Defaults to 'prod'.
""");
  }

  String env = results['env'];
  print(env);
  exit(0);
}
