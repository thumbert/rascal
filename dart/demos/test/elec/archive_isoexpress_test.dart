

import 'package:date/date.dart';
import 'package:demos/elec/archive_isoexpress.dart';


archiveNcpc() async {
  var report = new NcpcRapidResponsePricingReport();
  await report.downloadDay(new Date(2017,11,1));

}


main() async {
  await archiveNcpc();


}