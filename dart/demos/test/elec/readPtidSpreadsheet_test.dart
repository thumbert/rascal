library test.elec.read_ptid_spreadsheet;

import 'dart:io';
import 'package:demos/elec/ptid_table.dart';

main() {
  Map env = Platform.environment;
  File file = new File(env['HOME'] + '/Downloads/pnode_table_2016_10_20.xlsx');
  print(file);

  var aux = readPtidSpreadsheet(file);
  aux.forEach(print);

}