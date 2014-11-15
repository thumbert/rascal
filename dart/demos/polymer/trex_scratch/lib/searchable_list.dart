library trex_scratch.searchable_list;

import 'package:polymer/polymer.dart';
import 'dart:html';

@CustomTag('searchable-list')
class SearchableList extends PolymerElement {
  @observable bool applyAuthorStyles = true;
  @observable String searchParam;                 // what's in the search box
  @published List<String> data = [];              // this is the entire large list, how does it get populated?
  final List<String> results = toObservable([]);  // what matches
    
  
  SearchableList.created() : super.created();

  attached() {
    super.attached();
    results.addAll(data);
    onPropertyChange(this, #searchParam, search);
  }

  search() {
    results.clear();
    String lower = searchParam.toLowerCase();
    results.addAll(data.where((String d) => d.startsWith(lower)).take(10));
  }
  
  dateSelection(Event e) {
    print("Selection is" + searchParam);  // i don't get here ..
  }
  
}
