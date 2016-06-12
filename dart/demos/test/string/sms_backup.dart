library test.sms_backup;

import 'dart:io';
import 'package:xml/xml.dart';
import 'package:demos/string/read_sms_backup.dart';


List<String> data = [
  """<sms protocol="0" address="+12222222222" date="1464453545899" type="1" subject="null" body="I have just enough shade to do a little more but I'm afraid to do damage." toa="null" sc_toa="null" service_center="6502531234" read="1" status="-1" locked="0" date_sent="1464453545000" readable_date="May 28, 2016 12:39:05 PM" contact_name="C" />"""
];



List<Message> readFile(File filename) {
  File file = new File('~/Downloads/sms-20160609063913.xml');
  String aux = file.readAsStringSync();
  XmlDocument doc = parse(aux);

  List<Message> res = [];



  return res;
}



/// Create the Latex file
void writeLatex() {

}


main() {

//  XmlDocument res = parse(data.first);
//  var x = res.firstChild;
//  Message msg = new Message.fromXml(x);
//  print(msg);



  //print(res);
}