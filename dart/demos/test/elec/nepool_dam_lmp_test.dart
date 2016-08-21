library elec.nepool_dam_lmp_test;

import 'package:test/test.dart';
import 'package:date/date.dart';
import 'package:demos/elec/nepool_da_lmp.dart';
import 'package:intl/intl.dart';


setup() async {
  DamArchive arch = new DamArchive();
  await arch.setup();

  await arch.updateDb(new Date(2015,1,1), new Date(2015,8,31));
}

/// download one month of data
download_files() async {
  DamArchive  archive = new DamArchive();
  var range = new TimeIterable(new Date(2015,1,1), new Date(2015,1,31)).toList();
  Date current = range.first;
  while (current <= range.last) {
    await archive.oneDayDownload( current );
    current = current.next;
  }
}


test_nepool_dam() async {
  DamArchive arch = new DamArchive();

  await arch.db.open();
  Date end = await arch.lastDayInserted();
  print('Last day inserted is: $end');
  await arch.removeDataForDay(end);
  print('Last day inserted is: ${await arch.lastDayInserted()}');
  await arch.db.close();
}


main() async {
  ///await test_nepool_dam();

  test('download prices', download_files);

}