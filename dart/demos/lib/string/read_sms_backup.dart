import 'dart:convert';
import 'dart:io' show File, Process;
import 'package:intl/intl.dart';
import 'package:xml/xml.dart';


// https://www.synctech.com.au/sms-backup-restore/view-backup/
// https://www.synctech.com.au/sms-backup-restore/fields-in-xml-backup-files/
class Message {
  Message(this.time, this.author, this.content);

  DateTime time;
  String author; // type = 1 is other, = 2 is me
  String content;
  List<File> attachments = [];

  static String dir = '/home/adrian/Downloads/texts';
  static final fmt = new DateFormat('dMMM, HH:mm');

  /// There are two types of messages, sms and mms.
  static Message fromXml(XmlNode xml) {
    if (xml is XmlElement && xml.name.local == 'mms') {
      return _parseMms(xml);
    } else if (xml is XmlElement && xml.name.local == 'sms') {
      return _parseSms(xml);
    } else {
      throw 'Unknown message type';
    }
  }

  static Message _parseMms(XmlNode xml) {
    List<XmlAttribute> attrs = xml.attributes;
    late String author;
    late DateTime time;
    late String content;
    List<File> attachments = [];

    for (XmlAttribute a in attrs) {
      if (a.name.toString() == 'date')
        time = new DateTime.fromMicrosecondsSinceEpoch(
          1000 * int.parse(a.value),
        );
      if (a.name.toString() == 'contact_name') {
        author = a.value.split(' ').first;
      }
    }

    var parts = xml.getElement('parts');
    if (parts != null) {
      for (XmlNode part in parts.children) {
        if (part is! XmlElement) {
          continue;
        }
        final ct = part.getAttribute('ct')!;
        print('MMS part with content type: $ct');
        // check part type
        if (ct == 'text/plain') {
          for (XmlAttribute a in part.attributes) {
            if (a.name.toString() == 'text') {
              content = a.value.replaceAll('&#10;', '\n');
            }
          }
        } else if (ct == 'image/png') {
          // get the part sequence
          var seq = int.parse(part.getAttribute('seq')!);
          // save the content to a png file, with the timestamp of the message
          for (XmlAttribute a in part.attributes) {
            if (a.name.toString() == 'data') {
              String base64 = a.value;
              List<int> bytes = base64Decode(base64);
              final filename =
                  '/home/adrian/Downloads/texts/assets/mms_${time.millisecondsSinceEpoch.toString()}_$seq.png';
              final file = File(filename);
              file.writeAsBytesSync(bytes);
              attachments.add(file);
              content = '[Image saved to $filename]'; // append to content
            }
          }
        } else if (ct == 'image/jpeg') {
          // get the part sequence
          var seq = int.parse(part.getAttribute('seq')!);
          // save the content to a jpeg file, with the timestamp of the message
          for (XmlAttribute a in part.attributes) {
            if (a.name.toString() == 'data') {
              String base64 = a.value;
              List<int> bytes = base64Decode(base64);
              final filename =
                  'mms_${time.millisecondsSinceEpoch.toString()}_$seq.jpeg';
              final file = File(filename);
              file.writeAsBytesSync(bytes);
              attachments.add(file);
              content = '[Image saved to $filename]'; // append to content
            }
          }
        } else if (ct == 'application/smil') {
          // ignore smil parts
        } else if (ct == 'image/heic') {
          final filename = part.getAttribute('name')!;
          for (XmlAttribute a in part.attributes) {
            if (a.name.toString() == 'data') {
              String base64 = a.value;
              List<int> bytes = base64Decode(base64);
              final file = File(filename);
              file.writeAsBytesSync(bytes);
              attachments.add(file);
              content = '[Image saved to $filename]'; // append to content
              // convert to webp which can be used by typst
              // magick IMG_6771.heic -quality 85 IMG_6771.webp
              Process.runSync('magick', [
                filename,
                '-quality',
                '85',
                filename.replaceAll('.heic', '.webp'),
              ], runInShell: true);
              Process.runSync('rm', [filename], runInShell: true);
            }
          }
        } else {
          // Need to deal with heic images here.  Install imagemagick with heic support
          // https://dev.to/harizinside/installing-imagemagick-from-source-with-heic-support-2p8
          throw 'Unknown mms part type';
        }
      }
    }

    return Message(time, author, content)..attachments = attachments;
  }

  static Message _parseSms(XmlNode xml) {
    List<XmlAttribute> attrs = xml.attributes;
    late String author;
    late DateTime time;
    late String content;

    for (XmlAttribute a in attrs) {
      if (a.name.toString() == 'date')
        time = new DateTime.fromMicrosecondsSinceEpoch(
          1000 * int.parse(a.value),
        );
      if (a.name.toString() == 'body') content = a.value;
      if (a.name.toString() == 'type') {
        if (a.value == '1') author = 'Eylia';
        if (a.value == '2') author = 'Adrian';
      }
    }

    return Message(time, author, content);
  }

  // _root() {
  //   if (author.startsWith('C')) _color = 'magenta';
  //   if (author.startsWith('A')) _color = 'blue';
  // }

  /// Convert this message to a Latex chunk
  // String toLatex() {
  //   String date = '{\\footnotesize {\\it ${fmt.format(time)}}}';
  //   String res = '\\item[\\color{$_color} {\\bf $author}] $content $date';
  //   return res;
  // }

  String toString() =>
      '{"time": $time, "author": $author, "content": $content}';
}

// /// Make the document.  Write the output to document.tex
// void makeLatex(List<Message> x) {
//   StringBuffer doc = new StringBuffer()..write('''
// \\documentclass[11pt,twocolumn]{revtex4-1}
// \\usepackage[usenames]{color}

// \\renewcommand{\\baselinestretch}{0.5}
// \\setlength{\\oddsidemargin}{-0.75in}
// \\setlength{\\evensidemargin}{-0.75in}
// \\setlength{\\textwidth}{7.75in}


// \\begin{document}
// \\title{A textual history}
// \\maketitle
// ''');

// doc.writeln('\\begin{itemize}');
//   x.forEach((msg) {
//     doc.writeln(msg.toLatex());
//   });

//   doc.writeln('\\end{itemize}');
//   doc.writeln("\\end{document}");

//   new File('document.tex').writeAsStringSync(doc.toString());
// }


// /// Read the xml file and return a list of messages
// List<Message> readFile() {
//   File file = new File('sms.xml');
//   String aux = file.readAsStringSync();
//   // need to replace all $ with \$
//   aux = aux.replaceAll('\$', '\\\$');

//   XmlDocument doc = parse(aux);
//   List<XmlElement> x = doc.children[6].children;  // messages

//   List<Message> res = [];
//   x.forEach((msg) {
//      res.add(new Message.fromXml(msg));
//      });

//   return res;
// }

// /// Create the Pdf document
// makePdf() {
//   List<Message> msg = readFile();
//   makeLatex(msg);

//   Process.runSync('pdflatex', ['document.tex']);

//   // cleanup

// }
