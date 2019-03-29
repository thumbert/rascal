
import 'dart:html';


class Tabs {

  Element wrapper;
  List<String> _values;
  DivElement _wrapper;
  DivElement _buttonWrapper;
  String _buttonWrapperClass;
  List<DivElement> _tabContentDivs;

  Tabs(this.wrapper, List<String> values, {String buttonWrapperClass: 'w3-bar w3-black'}) {
    this.values = values;
    _buttonWrapperClass = buttonWrapperClass;
    _wrapper = DivElement();
    wrapper.children.add(_wrapper);
  }

  set values(List<String> xs) {
    _values = List.from(xs);

    var _wId = wrapper.id;

    // create the actual tabs
    _buttonWrapper = DivElement()..className = _buttonWrapperClass;
    for (var value in _values) {
      var btn = ButtonElement()
        ..id = 'btn-$value'
        ..className = 'w3-bar-item w3-button'
        ..text = value;
      _buttonWrapper.children.add(btn);
    }
    _wrapper.children.add(_buttonWrapper);

    // create the divs that keep the tab content
    _tabContentDivs = <DivElement>[];
    for (var value in _values) {
      var tabContent = DivElement()
        ..id = 'wrapper-$value-content';
      var div = DivElement()
          ..id = value
          ..className = 'tab-content'
          ..setAttribute('style', 'display:none');
      div.children.add(tabContent);
      _tabContentDivs.add(div);
    }
    _wrapper.children.addAll(_tabContentDivs);
  }

  void open(String tabName) {
    _tabContentDivs.forEach((e) {
      if (e.id == tabName) {
        e.style.display = 'block';
      } else {
        e.style.display = 'none';
      }
    });
  }

  List<String> get values => _values;

}




main() async {

  var wrapper = querySelector('#content');

  var tabs = Tabs(wrapper, ['Tab 1', 'Tab 2', 'Tab 3']);




}
