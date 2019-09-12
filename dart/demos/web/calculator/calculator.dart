import 'dart:html';
import 'package:timezone/timezone.dart' as tz;
import 'package:date/date.dart';

class Calculator {
  Element wrapper;
  tz.Location location;
  Month startMonth;
  int numberOfMonths;
  Month endMonth;
  List<Map<String,dynamic>> rowData;

  Map<String,dynamic> options;

  TableElement _table;
  List<Element> _tableHeaders;
  List<String> _columnNames;

  /// A toy electricity calculator.
  Calculator(this.wrapper, {this.options}) {
    options ??= <String,dynamic>{};
    setDefaultData();

    _makeTable();
  }

  void setDefaultData() {
    location = tz.getLocation('US/Eastern');
    startMonth = Month.current().next;
    numberOfMonths = 12;
    endMonth = startMonth.add(numberOfMonths);

    _columnNames = ['MW', 'ISO', 'Delivery Point', 'Bucket', 'DA/RT',
      'Component', 'Price'];
    rowData = [
      Map.fromIterables(_columnNames, ['50', 'ISONE', 'Hub', '5x16', 'DA', 'LMP', null]),
      Map.fromIterables(_columnNames, ['-50', 'ISONE', 'Maine', '5x16', 'DA', 'LMP', null]),
    ];
  }

  _makeTable() {
    _tableHeaders = List<Element>(_columnNames.length);
    _table = TableElement();
    _table.createTHead();

    TableRowElement headerRow = _table.tHead.insertRow(0);
    for (int i = 0; i < _columnNames.length; i++) {
      _tableHeaders[i] = (Element.th()..text = _columnNames[i]);
      //_tableHeaders[i].text = _columnNames[i];
      headerRow.nodes.add(_tableHeaders[i]);
    }

    var tBody = _table.createTBody();
    for (int r=0; r<rowData.length; r++) {
      var tRow = tBody.insertRow(r);
      for (int j = 0; j < _columnNames.length - 1; j++) {
        var name = _columnNames[j];
        var value = rowData[r][name].toString();
        tRow..insertCell(j).text = value;
      }
    }

//    if (wrapper != null) {
//      /// if you already have a table, remove it before you add it back to the dom
//      if (wrapper.children.length > 0) wrapper.children = [];
//    }
    wrapper.append(_table);

    wrapper.onKeyUp.listen((e){
      if (e.ctrlKey && e.which == 82) {
        window.alert('Ctrl + R shortcut: create a new row');
      }
    });
  }
  
}


main() {
  var wrapper = querySelector('#wrapper-calculator')
    ..setAttribute('style', 'margin-left: 15px');

  Calculator(wrapper);

}