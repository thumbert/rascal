library trex_scratch.trex_app;

import 'package:polymer/polymer.dart';
import 'package:intl/intl.dart';

@CustomTag('trex-app')
class DemoApp extends PolymerElement {
  @observable bool applyAuthorStyles = true;
    
  static DateFormat fmt = new DateFormat("yyyy-MM-dd");
  
  String daySelected = "";
  
  List<String> reportTimes = new List.generate(
        365 * 3,
        (i) => fmt.format(new DateTime(2012, 1, 1).add(new Duration(days: i))));

  DemoApp.created() : super.created();
}
