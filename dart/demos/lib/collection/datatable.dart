library datatable;
import 'dart:collection';


/*
 * A DataTable class similar to the Google js one:
 * https://developers.google.com/chart/interactive/docs/reference#DataTable
 */

/*
 * https://developers.google.com/chart/interactive/docs/reference#cell_object
 */
class Cell {
  int rowIndex;
  int colIndex;
  var v;         // value
  String f;      // formatted value
  Map p;         // custom values applied to the cell.  
  
  Cell(v, {String f, Map p}) {
    this.v = v;
    this.f = f;
    this.p = p;
  }
  Cell.fromMap(Map v) {
    
  }
  
  // disclose the cell location in the table 
  void attach(int rowIndex, int colIndex) {
    this.rowIndex = rowIndex;
    this.colIndex = colIndex;
  }
  
}

class ColumnInfo {
  static final COLUMN_TYPES = ['string', 'number', 'date', 'datetime', 'timeofday'];

  String type;
  String label;
  String id;
  String role;       // https://developers.google.com/chart/interactive/docs/roles 
  String pattern;    // how to format the column
  
  ColumnInfo(String type, {String label: "", String id: "", String role, String pattern}) {    
    assert(COLUMN_TYPES.contains(type));
    this.type = type;
    this.label = label;
    this.id = id;
    this.role = role;
    this.pattern = pattern;
  }  
}

class Row extends ListBase {
  List<Cell> _cells;
  int get length => _cells.length;
  void set length(int i) {_cells.length = i;}
  operator [](int i) => _cells[i];
  operator []=(int i, v) => _cells[i] = v;
  
  Row(List<Cell> this._cells);
}



class DataTable {
  List<ColumnInfo> _columnsInfo;
  List<Row> _rows = [];  // each row is a list of cells
  
  DataTable({data}) {
    
  }
  DataTable.fromJson(String obj) {
    
  }
  
  addColumn(String type, {String label: "", String id: "", String role, String pattern}) {
    ColumnInfo cInfo = new ColumnInfo(type, label: label, id: id, role: role, pattern: pattern);
    _columnsInfo.add(cInfo);
  }
  
  /*
   * Add a row of data to the table.  Data needs to have same dimensions as the 
   * number of columns.  
   * tbl.addRow(['A', 1, 3.14]) 
   * tbl.addRow(['A', 1, {'v': 3.14159, 'f': '3.14'}]) should also work. 
   */
  addRow(List rowData) {
    assert(rowData.length == _columnsInfo.length);
    int ir = _rows.length + 1;   // index of this row

    // make the row 
    Row row = new Iterable.generate(rowData.length, (int ic) {
      var entry = rowData[ic];
      var v;
      var f;
      if (entry is Map) {
        v = entry['v']; 
        f = entry.containsKey('f') ? entry['f'] : null;
      } else {
        v = entry;
      }
      
      return new Cell(v, f:f)..attach(ir, ic);
    });
    _rows.add(row);
    
  }
  addRows() {
    
  }
  
  
  
  String toJson() {
    String res = "";
    
    return res;
  }
  
  
}

