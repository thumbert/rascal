
import 'dart:html';
import 'dart:math' show Random;
import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:dygraphs_dart/dygraphs_dart.dart';
import 'package:temperature_ui/dygraph/dygraph_component.dart';

@Component(
    selector: 'my-app',
    templateUrl: 'app_component.html',
    styleUrls: const ['app_component.css'],
    directives: const [
      materialDirectives,
      DygraphComponent
    ],
    providers: materialProviders)
class AppComponent implements OnInit {
  String title;

  @ViewChild('dygraph')
  DygraphComponent dygraph;

  AppComponent() {
    title = 'My special one';
  }

  void ngOnInit(){
  }

}

