library trex.trex_app;

import 'package:polymer/polymer.dart';

@CustomTag('trex-app')
class DemoApp extends PolymerElement {
  @observable bool applyAuthorStyles = true;
    
  List<String> reportTimes = new List.generate(
        365 * 3,
        (i) => new DateTime(2012, 1, 1).add(new Duration(days: i)).toIso8601String());

  DemoApp.created() : super.created();
}
