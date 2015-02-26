library test_webservices;

import 'dart:io';


/**
 * Get some data from the ISO.
 */

_printCertificate(cert) {
  print('${cert.issuer}');
  print('${cert.subject}');
  print('${cert.startValidity}');
  print('${cert.endValidity}');
}

oneDayDownload(String yyyymmdd) {
  File fileout = new File("nepool_da_bc_${yyyymmdd}.json");

  String URL = "https://webservices.iso-ne.com/api/v1.1/dayaheadconstraints/day/${yyyymmdd}";
  HttpClient client =new HttpClient();
  client.badCertificateCallback = (cert, host, port) {
    print('Bad certificate connecting to $host:$port:');
    _printCertificate(cert);
    print('');
    return true;
  };
  client.addCredentials(Uri.parse(URL), "", new HttpClientBasicCredentials(_user, _pwd));

  client.userAgent = "Mozilla/4.0";
  client.getUrl( Uri.parse( URL))
  .then((HttpClientRequest request) {
    request.headers.set(HttpHeaders.ACCEPT, "application/json");
    return request.close();
  })
  .then((HttpClientResponse response) =>
  response.pipe(fileout.openWrite()));

}