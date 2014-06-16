import 'dart:html';
import 'dart:async';
import 'package:polymer/polymer.dart';

@CustomTag('aad-autocomplete')
class Autocomplete extends PolymerElement {

  @observable
  String textvalue = '';
  @observable
  String message = '';
  @observable
  String yousaid = '';

  Autocomplete.created(): super.created();

  @override
  void enteredView() {
    super.enteredView();
    message = "Entered";
    yousaid = "You said: " + textvalue;
  }

  void myOnInput(Event e, var detail, Node target) {
    message = "inside";
    yousaid = "You said: " + textvalue;
  }

  void myOnFocus(Event e, var detail, Node target) {
     message = "grabbed focus";
  }

  void myOnBlur(Event e, var detail, Node target) {
     message = "lost focus";
  }





}
