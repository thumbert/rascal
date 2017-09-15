
import 'dart:convert';
import 'dart:async';
import 'dart:io';

/// example of how to read a file from the web into memory
/// using dart:io
Future readUrl(String url) async {
  HttpClient client = new HttpClient();
  var request = await client.getUrl(Uri.parse(url));
  var response = await request.close();
  response.transform(UTF8.decoder).listen((contents){
    print(contents);
  });
}

/// Read a site by passing in basic credentials
Future readUrl2() async {
  Map env = Platform.environment;
  File fileout = new File('tmp/another.json');
  String URL =
      "https://webservices.iso-ne.com/api/v1.1/dayaheadconstraints/day/20160101";
  HttpClient client = new HttpClient();
  client.badCertificateCallback = (cert, host, port) => true;
  client.addCredentials(
      Uri.parse(URL),
      "",
      new HttpClientBasicCredentials(
          env['ISO1_LOGIN'], env["ISO1_PASSWD"]));
  client.userAgent = "Mozilla/4.0";

  HttpClientRequest request = await client.getUrl(Uri.parse(URL));
  request.headers.set(HttpHeaders.ACCEPT, 'application/json');
  HttpClientResponse response = await request.close();
  await response.pipe(fileout.openWrite());
}
