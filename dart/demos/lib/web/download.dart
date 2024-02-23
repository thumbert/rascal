
// import 'dart:convert';
// import 'dart:async';
// import 'dart:io';
// import 'package:html/parser.dart';
// import 'package:http/http.dart' as http;

// /// example of how to read a file from the web into memory
// /// using dart:io
// Future readUrl(String url) async {
//   HttpClient client = new HttpClient();
//   var request = await client.getUrl(Uri.parse(url));
//   var response = await request.close();
//   response.transform(utf8.decoder).listen((contents){
//     print(contents);
//   });
// }


// Future<List<String>> getLinks(String url, {Pattern pattern}) async {
//   var aux = await http.get(url);
//   var body = aux.body;
//   var document = parse(body);
//   var links = <String>[];
//   for (var linkElement in document.querySelectorAll('a')) {
//     var link = linkElement.attributes['href'];
//     print(link);
//     if (link != null && link.contains(pattern) && !link.startsWith('http'))
//       links.add(link);
//   }
//   links.sort();
//   return links;
// }



// /// Read a site by passing in basic credentials
// Future readUrl2() async {
//   Map env = Platform.environment;
//   File fileout = new File('tmp/another.json');
//   String URL =
//       "https://webservices.iso-ne.com/api/v1.1/dayaheadconstraints/day/20160101";
//   HttpClient client = new HttpClient();
//   client.badCertificateCallback = (cert, host, port) => true;
//   client.addCredentials(
//       Uri.parse(URL),
//       "",
//       new HttpClientBasicCredentials(
//           env['ISO1_LOGIN'], env["ISO1_PASSWD"]));
//   client.userAgent = "Mozilla/4.0";

//   HttpClientRequest request = await client.getUrl(Uri.parse(URL));
//   request.headers.set(HttpHeaders.acceptHeader, 'application/json');
//   HttpClientResponse response = await request.close();
//   await response.pipe(fileout.openWrite());
// }
