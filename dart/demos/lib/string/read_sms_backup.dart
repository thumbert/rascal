library string.sms_backup;

import 'dart:io' show File;
import 'package:xml/xml.dart' as xml;

/**
 * Process the xml file.  Usually I drop the file
 */
String processFile(File file) {

  String aux = file.readAsStringSync();
  var doc = xml.parse(aux);

  StringBuffer res = new StringBuffer();



  return res.toString();
}