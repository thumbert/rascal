// library demo;
// // See https://www.dartlang.org/articles/js-dart-interop/
// // And specifically https://code.google.com/p/dart/source/browse/#svn%2Fbranches%2Fbleeding_edge%2Fdart%2Fsamples%2Fgauge


// import 'dart:html';
// import 'dart:js';
// import 'dart:async';
// import 'dart:convert';
// //import 'dart:io';
// //import 'dart:convert';

// class LinePlot {
//   var jsOptions;
//   var jsTable;
//   var jsChart;
  
  
//   LinePlot(Element element, List data, Map options) {
    
    
//     final vis = context["google"]["visualization"];
//     jsTable = vis.callMethod('arrayToDataTable', [new JsObject.jsify(data)]);
//     jsChart = new JsObject(vis["LineChart"], [element]);
//     jsOptions = new JsObject.jsify(options);
        
//     jsChart.callMethod('draw', [jsTable, jsOptions]);
//   }
  
  
  
//   static Future load() {
//     Completer c = new Completer();
//     context["google"].callMethod('load',
//        ['visualization', '1.0', new JsObject.jsify({
//          'packages': ['corechart'],
//          'callback': new JsFunction.withThis(c.complete)
//        })]);
//     return c.future;  
//   } 
// }

// // Bindings to html elements.
// final DivElement visualization = querySelector('#chart');

// List<Map> onDataLoaded(responseText) {
//   print("Data Loaded");
//   var jsonString = responseText;
//   print(jsonString);
//   return json.decode(jsonString);
// }


// // before you run this file, start the server from bin/server_mongo.dart 
// void main() {
//   var url = "http://127.0.0.1:4041";
//   var request = HttpRequest.getString(url).then(onDataLoaded);
  
//   print('here');
  
  
  
//   var options = {'title': 'Company Performance'};
  
//   Future.wait([request, LinePlot.load()]).then((list) {
//     print(list.first);        
//     List<List> data = [['Year', 'Sales', 'Expenses']];
//     list.first.forEach((Map e) => data.add([e["year"].round().toString(), e["sales"], e["expenses"]]));
// //    final data = [['Year', 'Sales', 'Expenses'], 
// //                  ['2004',  1000,      400],
// //                  ['2005',  1170,      460],
// //                  ['2006',  660,       1120],
// //                  ['2007',  1030,      540]];  
//     print("data done");
//     LinePlot plot = new LinePlot(visualization, data, options);  
//   });

// }
