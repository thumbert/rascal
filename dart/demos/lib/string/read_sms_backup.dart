library string.sms_backup;

import 'dart:io' show File, Process;
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';

class Message {
  DateTime time;
  String author;   // type = 1 is other, = 2 is me
  String content;
  String _color;

  static final fmt = new DateFormat('dMMM, HH:mm');

  Message(this.time, this.author, this.content);

  Message.fromXml(XmlNode xml) {
    List<XmlAttribute> attrs = xml.attributes;
    attrs.forEach((XmlAttribute a) {
      if (a.name.toString() == 'date')
        time =
            new DateTime.fromMicrosecondsSinceEpoch(1000 * int.parse(a.value));
      if (a.name.toString() == 'body') content = a.value;
      if (a.name.toString() == 'type') {
        if (a.value == '1') author = 'C';
        if (a.value == '2') author = 'A';
      }
    });
    _root();
  }

  _root() {
    if (author.startsWith('C')) _color = 'magenta';
    if (author.startsWith('A')) _color = 'blue';
  }

  /// Convert this message to a Latex chunk
  String toLatex() {
    String date = '{\\footnotesize {\\it ${fmt.format(time)}}}';
    String res = '\\item[\\color{$_color} {\\bf $author}] $content $date';
    return res;
  }

  String toString() =>
      '{"time": $time, "author": $author, "content": $content}';
}

/// Make the document.  Write the output to document.tex
void makeLatex(List<Message> x) {
  StringBuffer doc = new StringBuffer()..write('''
\\documentclass[11pt,twocolumn]{revtex4-1}
\\usepackage[usenames]{color}

\\renewcommand{\\baselinestretch}{0.5}
\\setlength{\\oddsidemargin}{-0.75in}
\\setlength{\\evensidemargin}{-0.75in}
\\setlength{\\textwidth}{7.75in}


\\begin{document}
\\title{A textual history}
\\maketitle
''');

doc.writeln('\\begin{itemize}');
  x.forEach((msg) {
    doc.writeln(msg.toLatex());
  });

  doc.writeln('\\end{itemize}');
  doc.writeln("\\end{document}");

  new File('document.tex').writeAsStringSync(doc.toString());
}


/// Read the xml file and return a list of messages
List<Message> readFile() {
  File file = new File('sms.xml');
  String aux = file.readAsStringSync();
  // need to replace all $ with \$
  aux = aux.replaceAll('\$', '\\\$');

  XmlDocument doc = parse(aux);
  List<XmlElement> x = doc.children[6].children;  // messages

  List<Message> res = [];
  x.forEach((msg) {
     if (msg is XmlElement) {
       res.add(new Message.fromXml(msg));
     }
  });

  return res;
}

/// Create the Pdf document
makePdf() {
  List<Message> msg = readFile();
  makeLatex(msg);

  Process.runSync('pdflatex', ['document.tex']);

  // cleanup

}
