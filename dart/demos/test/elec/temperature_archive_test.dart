library test.elec.temperature_archive;

import 'dart:io';
import 'package:demos/elec/temperature_archive.dart';

/// Boston Logan International airport
insert_boston(int year) async {
  await downloadFileYear(year);
  List x = await extractData(year, 'USW00014739');
  await insertDataIntoInflux(x);
}

scratch() async {
  //int year = 1881;  // very little data, good for testing
  int year = 2013;
  await downloadFileYear(year);

  List x = await extractData(year, 'USW00014739');
  //var x = await extractData(1881, 'CA007025280');
  //x.forEach(print);

  insertDataIntoInflux(x);
}

main() async {

 await insert_boston(2016);

}