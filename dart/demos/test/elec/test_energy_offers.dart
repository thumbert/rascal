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
  await arch.oneDayJsonRead(yyyymmdd);

}

test_filterBy() async {
  EnergyOffers eo = new EnergyOffers();

  List res = await eo.filterBy(beginDate: '2014-01-01T00:00:00.000-05:00',
    maskedParticipantId: 108258);

  res.forEach((e) => print(e));
}

test_getStack() async {
  EnergyOffers eo = new EnergyOffers();

  var res = await eo.getStack('2014-01-01T00:00:00.000-05:00');

  //print(res);
  res['result'].forEach((e) => print(e));
}



main() {
  //new Archiver().setup();

  //test_ingestor_download();

  //test_ingestor_read();

  //test_filterBy();

  test_getStack();

}