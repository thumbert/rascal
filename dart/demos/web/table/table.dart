
import 'dart:html';
import 'package:intl/intl.dart';

class Table {
  Element tableWrapper;
  List<Map<String,dynamic>> data;
  Map options;

  TableElement table;
  List<Element> _tableHeaders;
  List<String> _columnNames;
  List<int> _sortDirection;

  /// A simple html table with sorting.
  Table(this.tableWrapper, this.data, {this.options}) {
    _columnNames = data.first.keys.toList();
    _tableHeaders = new List(_columnNames.length);
    _sortDirection = new List(_columnNames.length);
    _makeTable();
  }

  _makeTable() {
    table = new TableElement();
    table.createTHead();
    // make the table header
    TableRowElement headerRow = table.tHead.insertRow(0);
    for (int i=0; i<_columnNames.length; i++) {
      _tableHeaders[i] =  new Element.th();
      _tableHeaders[i].text = _columnNames[i];
      _tableHeaders[i].onClick.listen((e) => _sortByColumn(i));
      headerRow.nodes.add(_tableHeaders[i]);
    }
    // make the table body
    var tBody = table.createTBody();
    for (int r=0; r<data.length; r++) {
      List values = data[r].values.toList();
      var tRow = tBody.insertRow(r);
      for (int j=0; j<_columnNames.length; j++) {
        if (options.containsKey(_columnNames[j]) && (options[_columnNames[j]].containsKey('valueFormat'))) {
          var aux = options[_columnNames[j]]['valueFormat'](values[j]);
          tRow..insertCell(j).text = aux;
        } else {
          tRow..insertCell(j).text = values[j];
        }
      }
    }
    /// if you already have a table, remove it before you add it back to the dom
    if (tableWrapper.children.length > 0)
      tableWrapper.children = [];
    tableWrapper.append(table);
  }

  /// If you click on a header, sort the data.
  _sortByColumn(int i) {
    if (_sortDirection[i] == null) {
      _sortDirection[i] = 1;
    } else {
      _sortDirection[i] *= -1;
    }
    data.sort((a,b) => (_sortDirection[i]*(a[_columnNames[i]].compareTo(b[_columnNames[i]]) as num).toInt()));
    _makeTable();
  }

}

simple() {
  TableElement table = new TableElement();
  //table.style.width = '100%';

  table.createTHead();
  TableRowElement headerRow = table.tHead.insertRow(0);
  headerRow.insertCell(0).nodes.add(new Element.th()..text = 'Bucket');
  headerRow.insertCell(1).nodes.add(new Element.th()..text = 'Price');

  var tBody = table.createTBody();
  tBody.insertRow(0)
    ..insertCell(0).text = '5x16'
    ..insertCell(1).text = '36.25';
  tBody.insertRow(1)
    ..insertCell(0).text = '2x16H'
    ..insertCell(1).text = '30.05';

  var div = querySelector('#table-wrapper');
  div.append(table);
}

main() {
//  List<Map> data = [
//    {'airport': 'BOS', 'tmin': '22', 'tmax': '45'},
//    {'airport': 'BWI', 'tmin': '27', 'tmax': '49'},
//    {'airport': 'LGA', 'tmin': '25', 'tmax': '47'},
//  ];

  List<Map> data = [
    {'date': new DateTime(2018,1), 'price': 85.24},
    {'date': new DateTime(2018,2), 'price': 73.1},
    {'date': new DateTime(2018,3), 'price': 55.93},
    {'date': new DateTime(2018,4), 'price': 38.06},
  ];

  var fmt = new DateFormat('MMMyy');
  var dollar = new NumberFormat.currency(symbol: '\$');

  Map options = {
    'date': {
      'valueFormat': (DateTime dt) => fmt.format(dt)
    },
    'price': {
      'valueFormat': (num x) => dollar.format(x)
    }
  };

  new Table(querySelector('#table-wrapper'), data, options: options);

  //simple();

}
