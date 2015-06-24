library elec.test_energy_offers;

import 'package:test/test.dart';
import 'package:demos/elec/energy_offers.dart';

test_ingestor_download() async {
  String yyyymmdd = '20140101';

  Archiver arch = new Archiver();
  await arch.oneDayDownload(yyyymmdd);
}

test_ingestor_read() {
  String yyyymmdd = '20140101';
  Archiver arch = new Archiver();
  arch.oneDayJsonRead(yyyymmdd);
}

test_ingest_cycle() async {
  String yyyymmdd = '20140102';

  Archiver arch = new Archiver();
  await arch.oneDayDownload(yyyymmdd);
  await arch.db.open();
  await arch.oneDayMongoInsert(yyyymmdd);
  await arch.db.close();
}

main() async {

  //test_ingestor_download();

  //test_ingestor_read();

  //test_ingest_cycle();

  await db.open();
  var dt = await lastDayInArchive();
  print(dt);
  await db.close();
}
