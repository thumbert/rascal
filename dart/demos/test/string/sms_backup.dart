library test.sms_backup;

import 'dart:io';
import 'package:demos/string/read_sms_backup.dart';

main() {
  print(Directory.current);
  File file = new File('tmp/sms-20160412220202.xml');
  String res = processFile(file);

  print(res);
}