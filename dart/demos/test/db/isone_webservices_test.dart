
import 'dart:io';


download() async {
  var env = Platform.environment;
  if (!env.containsKey('ISO1_LOGIN') || !env.containsKey('ISO1_PASSWD'))
    throw 'Set your credentials as environment variables';
  var fileout = File('another.json');
  var url =
      "https://webservices.iso-ne.com/api/v1.1/hourlysysload/day/20160524/location/32";
  var client = HttpClient();
  client.badCertificateCallback = (cert, host, port) => true;
  client.addCredentials(
      Uri.parse(url),
      "",
      HttpClientBasicCredentials(env['ISO1_LOGIN'], env["ISO1_PASSWD"]));
  client.userAgent = "Mozilla/4.0";

  var request = await client.getUrl(Uri.parse(url));
  request.headers.set(HttpHeaders.acceptHeader, 'application/json');
  var response = await request.close();
  await response.pipe(fileout.openWrite());
}


main() async {
  await download();
}