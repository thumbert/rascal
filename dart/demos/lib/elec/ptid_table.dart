library elec.ptid_table;

import 'dart:io';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

class Node {
  int ptid;
  String nodeName;
  String shortName;
  Node(this.ptid, this.nodeName, this.shortName);

  Map toMap() => {'ptid': ptid, 'nodeName': nodeName, 'shortName': shortName};
}

class CommonNode implements Node {
  int ptid;
  String nodeName;
  String shortName;
  int zoneId;
  int reserveId;
  String rspArea;
  String dispatchZone;

  CommonNode(this.ptid, this.nodeName, this.shortName, this.zoneId,
      this.reserveId, this.rspArea, this.dispatchZone);

  Map toMap() => {};
  //String toString() => '';
}

final Node hub = new Node(4000, '.H.INTERNAL_HUB', 'Hub');
final Node maine = new Node(4001, '.Z.MAINE', 'ME');
final Node nh = new Node(4002, '.Z.NEWHAMPSHIRE', 'NH');
final Node vt = new Node(4003, '.Z.VERMONT', 'VT');
final Node ct = new Node(4004, '.Z.CONNECTICUT', 'CT');
final Node ri = new Node(4005, '.Z.RHODEISLAND', 'RI');
final Node sema = new Node(4006, '.Z.SEMASS', 'SEMA');
final Node wma = new Node(4007, '.Z.WCMASS', 'WCMA');
final Node nema = new Node(4008, '.Z.NEMASSBOST', 'NEMA');

//List<Node> nodes = readPtidSpreadsheet();


List<Node> readPtidSpreadsheet(File file) {

  var bytes = file.readAsBytesSync();
  var decoder = new SpreadsheetDecoder.decodeBytes(bytes);
  var table = decoder.tables['New England'];

  List<Node> res = [];
  res.addAll([hub, maine, nh, vt, ct, ri, sema, wma, nema]);

  table.rows.where((List row) => row[5] != null).forEach((List row) {
    try {
      print('Processed ${row[5]}');
      res.add(new CommonNode(row[5],row[4], row[0], row[6], row[7], row[8], row[9]));
    } catch (e) {}
  });


  return res;
}