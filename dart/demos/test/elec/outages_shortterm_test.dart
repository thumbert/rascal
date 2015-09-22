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
  while (day < Date.today()) {
    await arch.oneDayDownload(day.toString());
    await arch.oneDayMongoInsert(day.toString());
    day = day.next;
  }
  await arch.db.close();


}


main() {
  test_outages_shortTerm();
}