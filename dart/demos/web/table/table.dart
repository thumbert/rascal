
import 'dart:html';

class Table {
  Element tableWrapper;
  TableElement element;
  List<Map> data;
  Map layout;

  Table(this.tableWrapper, this.data, this.layout) {
    element = new TableElement();
    var tr = element.addRow();
    var cell = tr.addCell();
    cell.nodeValue = 'test';
  }

}


main() {
  List<Map> data = [
    {'airport': 'BOS', 'tmin': 22, 'tmax': 45},
    {'airport': 'BWI', 'tmin': 27, 'tmax': 49},
    {'airport': 'LGA', 'tmin': 25, 'tmax': 47},
  ];

  Map layout = {};


  var table = new Table(querySelector('table-wrapper'), data, layout);


}