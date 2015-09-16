library test.outages_shortterm;

import 'package:test/test.dart';
import 'package:demos/elec/outages_short_term.dart';

test_outages_shortTerm() {
  Archiver arch = new Archiver();
  arch.oneDayDownload('20150914');

  arch.oneDayRead('20150914');
}


main() {
  test_outages_shortTerm();
}