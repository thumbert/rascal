library test_datatable;

import 'package:unittest/unittest.dart';
import 'package:demos/collection/datatable.dart';

main() {
  
  group("datatable", () {
    
    test("create datatable", () {
      DataTable tbl = new DataTable();
      tbl.addColumn('string',  label: 'id');
      tbl.addColumn('number', label: 'value');
      tbl.addRow(['A', 1]);
      tbl.addRow(['B', 2]);
      
      
    });
    
  });
  
}