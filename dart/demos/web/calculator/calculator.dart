// import 'dart:html';
// import 'package:timezone/browser.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:date/date.dart';

// enum CellType {numeric, text}

// class CalculatorOptions {
//   Map<int,ColumnOptions> columns;
// }

// class ColumnOptions {
//   String type;
//   int width;
//   int height;
//   String alignment;
//   bool readOnly;
//   List source;
//   ColumnOptions({this.type = 'text', this.width = 50,
//     this.alignment = 'center'}) {
//     source = [];
//   }
// }


// class Calculator {
//   Element wrapper;
//   tz.Location location;
//   Month startMonth;
//   int numberOfMonths;
//   Month endMonth;
//   List<Map<String,dynamic>> rowData;

//   CalculatorOptions options;

//   TableElement _table;
//   Element _thead;
//   Element _tbody;
//   DivElement _textArea;

//   List<Element> _tableHeaders;
//   List<String> _columnNames;
//   List<List<Element>> _records;


//   /// A toy electricity calculator.
//   Calculator(this.wrapper, {this.options}) {
//     setDefaultData();

//     _makeTable();
//     _addShortcuts();
//   }

//   void setDefaultData() {
//     location = tz.getLocation('US/Eastern');
//     startMonth = Month.current().next;
//     numberOfMonths = 12;
//     endMonth = startMonth.add(numberOfMonths);

//     _columnNames = ['MW', 'ISO', 'Delivery Point', 'Bucket', 'DA/RT',
//       'Component', 'Price'];
//     rowData = [
//       Map.fromIterables(_columnNames, ['50', 'ISONE', 'Hub', '5x16', 'DA', 'LMP', null]),
//       Map.fromIterables(_columnNames, ['-50', 'ISONE', 'Maine', '5x16', 'DA', 'LMP', null]),
//     ];
//   }

//   _makeTable() {
//     wrapper.classes.add('dws-content');

//     _textArea = DivElement()
//       ..className = 'dws-textarea'
//       ..id = 'dws-textarea';


//     _tableHeaders = List<Element>(_columnNames.length);
//     _table = TableElement();
//     _table.classes.add('dws');
//     _table.createTHead();

//     var headerRow = _table.tHead.insertRow(0);
//     for (int i = 0; i < _columnNames.length; i++) {
//       _tableHeaders[i] = (Element.th()
//         ..text = _columnNames[i]);
//       headerRow.nodes.add(_tableHeaders[i]);
//     }

//     var tBody = _table.createTBody();
//     for (int r = 0; r < rowData.length; r++) {
//       var tRow = tBody.insertRow(r);
//       for (int j = 0; j < _columnNames.length - 1; j++) {
//         var name = _columnNames[j];
//         var value = rowData[r][name].toString();
//         tRow..insertCell(j).text = value;
//       }
//     }

//     wrapper.append(_table);
//   }

//   /// Return the html td element
//   Element createCell(int i, int j, dynamic value) {
//     var td = document.createElement('td')
//       ..setAttribute('data-x', i.toString())
//       ..setAttribute('data-y', j.toString());

//     var colAlign = options.columns[i].alignment ?? 'center';
//     td.style.textAlign = colAlign;

//     return td;
//   }

//   /// Return the html tr row element
//   Element createRow() {
//     // TODO: line 731
//   }


//   _addShortcuts() {
//     window.onKeyUp.listen((e){
//       if (e.altKey && e.keyCode == 82) {
//         print('here');
//         window.alert('Alt + R shortcut: create a new row');
//       } else if (e.keyCode == 65) {
//         print('pressed a!');
//       } else if (e.keyCode == 9) {
//         print('pressed Tab');
//       }
//     });
//   }

// }


// main() async {
//   await initializeTimeZone();
//   var wrapper = querySelector('#wrapper-calculator')
//     ..setAttribute('style', 'margin-left: 15px');

//   print(wrapper);
//   Calculator(wrapper);


//   print('done');
// }