import 'dart:html' as html;

enum RadioGroupOrientation { horizontal, vertical }

class RadioGroupInput {
  html.Element wrapper;

  List<String> labels;
  RadioGroupOrientation orientation;

  List<html.RadioButtonInputElement> _buttons;
  List<html.DivElement> _divs;

  /// A group of radio buttons.
  ///
  /// Variable [name] is the text of the accompanying label.
  ///
  /// Need to trigger an action onChange.
  RadioGroupInput(this.wrapper, this.labels,
      {orientation: RadioGroupOrientation.horizontal}) {
    var _wrapper = html.DivElement()..setAttribute('style', 'margin-top: 8px');

    var _name = wrapper.id + labels.join(); // name of the radio group
    _buttons = List(labels.length);

    if (orientation == RadioGroupOrientation.horizontal) {
      for (var i = 0; i < labels.length; i++) {
        _buttons[i] = html.RadioButtonInputElement()
          ..name = _name
          ..id = '${wrapper.id}__rg__${labels[i]}';
        if (i == 0) _buttons[0].checked = true;
        _wrapper.children.add(_buttons[i]);
        _wrapper.children.add(html.LabelElement()
          ..setAttribute('style', 'margin-left: 8px; margin-right: 8px;')
          ..text = labels[i]
          ..htmlFor = _buttons[i].id);
      }
    } else {
      _divs = List(labels.length);
      for (var i = 0; i < labels.length; i++) {
        _divs[i] = html.DivElement();
        _buttons[i] = html.RadioButtonInputElement()
          ..name = _name
          ..id = labels[i];
        if (i == 0) _buttons[0].checked = true;
        _divs[i].children.add(_buttons[i]);
        _divs[i].children.add(html.LabelElement()
          ..setAttribute('style', 'margin-left: 8px')
          ..text = labels[i]
          ..htmlFor = labels[i]);

        _wrapper.children.add(_divs[i]);
      }
    }

    wrapper.children.add(_wrapper);
  }

  String get value => labels[_buttons.indexWhere((b) => b.checked)];

  /// trigger a change
  onChange(Function x) {
    _buttons = _buttons.map((b) {
      b.onChange.listen(x);
      return b;
    }).toList();
  }
}

main() async {
  var wrapper = html.querySelector('#content');
  //var tabs = Tabs(wrapper, ['Tab 1', 'Tab 2', 'Tab 3']);

  wrapper.children.add(html.ButtonInputElement()
    ..name = 'gender'
    ..value = 'male'
    ..text = 'Male');
  wrapper.children.add(html.ButtonInputElement()
    ..name = 'gender'
    ..value = 'female'
    ..text = 'Female');


}
