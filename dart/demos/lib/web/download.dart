
import 'dart:convert';
import 'dart:async';
import 'dart:io';

/// example of how to read a file from the web into memory
/// using dart:io
///
Future readUrl(String url) async {
  HttpClient client = new HttpClient();
  var request = await client.getUrl(Uri.parse(url));
  var response = await request.close();
  response.transform(UTF8.decoder).listen((contents){
    print(contents);
  });

}