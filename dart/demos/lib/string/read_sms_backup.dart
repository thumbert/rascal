library string.sms_backup;

import 'dart:io' show File;
import 'package:xml/xml.dart';


class Message {
  DateTime time;
  String author;
  String content;

  Message(this.time, this.author, this.content);

  Message.fromXml(XmlNode xml) {
    List<XmlAttribute> attrs = xml.attributes;
    attrs.forEach((XmlAttribute a) {
      if (a.name.toString() == 'date') time = new DateTime.fromMicrosecondsSinceEpoch(1000*int.parse(a.value));
      if (a.name.toString() == 'body') content = a.value;
      if (a.name.toString() == 'contact_name') author = a.value;
    });
  }

  /// Convert this message to a Latex chunk
  String toLatex() {
    return '';
  }

  String toString() => '{"time": $time, "author": $author, "content": $content}';
}

/// Make the document
void makeLatex(List<Message> x) {
//\documentclass[11pt,twocolumn]{revtex4-1}
//
//\usepackage{color}
//
//\begin{document}
//\title{A textual history}
//\maketitle
//
//
//Bla bla here
//
//\begin{itemize}
//\item[\color{blue} {\bf A}] He says
//\item[\color{magenta} {\bf B}] She says
//\end{itemize}
//
//
//\end{document}


}


/**
 * Process the xml file.  Usually I drop the file
 */
String processFile(File file) {
  String aux = file.readAsStringSync();
  var doc = parse(aux);
  StringBuffer res = new StringBuffer();
  return res.toString();
}