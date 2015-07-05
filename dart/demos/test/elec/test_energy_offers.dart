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
  String yyyymmdd = '20150101';

  Archiver arch = new Archiver();
  await arch.oneDayDownload(yyyymmdd);
  await arch.db.open();
  await arch.oneDayMongoInsert(yyyymmdd);
  await arch.db.close();
}

test_filterBy() async {
  EnergyOffers eo = new EnergyOffers();

  List res = await eo.filterBy(beginDate: '2014-01-01T00:00:00.000-05:00',
    maskedParticipantId: 108258);

  res.forEach((e) => print(e));
}

test_getStack() async {
  EnergyOffers eo = new EnergyOffers();
  List<Map> res = await eo.getStack('2015-01-01T00:00:00.000-05:00');
  res.forEach((e) => print(e));
}

scratchpad() async {
  String beginDate = '2015-01-01T00:00:00.000-05:00';
  EnergyOffers eo = new EnergyOffers();

  //List res = await eo.filterBy(beginDate: beginDate, maskedAssetId: 87105);
  List res = await eo.ecomaxByAsset(beginDate);

  res.forEach((e) => print(e));
}

main() async {
  //new Archiver().setup();

  //test_ingestor_download();

  //test_ingestor_read();

  //test_filterBy();

  //test_ingest_cycle();

  //test_getStack();

  scratchpad();

}

//  await db.open();
//  var dt = await lastDayInArchive();
//  print(dt);
//  await db.close();
