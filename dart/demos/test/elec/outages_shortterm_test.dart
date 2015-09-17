library test.outages_shortterm;

import 'package:test/test.dart';
import 'package:demos/elec/outages_short_term.dart';
import 'package:date/date.dart';
import 'package:intl/intl.dart';

test_outages_shortTerm() async {
  Archiver arch = new Archiver();
  await arch.setup();

  Date.fmt = new DateFormat('yyyyMMdd');

  await arch.db.open();
  Date day = new Date(2014,1,2);
  while (day < new Date(2015,9,16)) {
    await arch.oneDayDownload(day.toString());
    await arch.oneDayMongoInsert(day.toString());
    day = day.add(1);
  }
  await arch.db.close();


}


main() {
  test_outages_shortTerm();
}