library read_gzip;

import 'dart:io';
import 'package:archive/archive.dart';

demo_read_gzip() {
    File file = new File("~/Downloads/WW_DAHBENERGY_ISO_20130531.CSV.gz");  
    List<int> data = new GZipDecoder().decodeBytes(file.readAsBytesSync());
    String aux = new String.fromCharCodes(data);
    print(aux);
}