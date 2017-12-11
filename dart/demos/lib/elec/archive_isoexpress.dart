
import 'dart:async';
import 'dart:io';
import 'package:date/date.dart';
import 'package:path/path.dart';
import 'package:elec/elec.dart';

Map env = Platform.environment;
String baseDir = env['HOME'] + '/Downloads/Archive/IsoExpress/';


abstract class IsoExpressReport {
  String reportName;
  /// get the url of this report for this date
  String getUrl(Date asOfDate);
  /// get the filename this report will be downloaded to
  File getFilename(Date asOfDate);

  /// download one day
  Future<Null> downloadDay(Date day) {
    return _downloadUrl(getUrl(day), getFilename(day));
  }

  /// Download a list of days from the website.
  Future downloadDays(List<Date> days) async {
    var aux = days.map((day) => downloadDay(day));
    return Future.wait(aux);
  }


}


class NcpcRapidResponsePricingReport extends IsoExpressReport {
  String reportName = 'NCPC Rapid Response Pricing Opportunity Cost';
  String getUrl(Date asOfDate) =>
      'https://www.iso-ne.com/transform/csv/ncpc/daily?ncpcType=rrp&start='  +
      yyyymmdd(asOfDate);
  File getFilename(Date asOfDate) => new File(baseDir +
      'NCPC/RapidResponsePricingOpportunityCost/' +
      'ncpc_rrp_' + yyyymmdd(asOfDate) + '.csv');

}



/// Download this url to a file.
Future _downloadUrl(String url, File fileout) async {
  if (fileout.existsSync()) {
    print('  file already downloaded');
    return new Future.value(print('File ${fileout.path} was already downloaded.'));
  } else {
    if (!new Directory(dirname(fileout.path)).existsSync())
      new Directory(dirname(fileout.path)).createSync(recursive: true);
    HttpClient client = new HttpClient();
    HttpClientRequest request = await client.getUrl(Uri.parse(url));
    HttpClientResponse response = await request.close();
    await response.pipe(fileout.openWrite());
  }
}


/// Format a date to the yyyymmdd format, e.g. 20170115.
String yyyymmdd(Date date) => date.toString().replaceAll('-', '');

