library client;

import 'dart:html';

InputElement startInput;  // start date input element
InputElement endInput;    // end date input element
DivElement errorMessage;  // how errors get communicated
ButtonElement submitButton;

UListElement bcList;
DateTime start, end;


main() {

  startInput = querySelector('#start-input');
  endInput   = querySelector('#end-input');
  errorMessage = querySelector('#footer');
  submitButton = querySelector('#submit-button');
  //bcList = querySelector('#bc-checkbox');

  startInput.onChange.listen(startOnChange);
  endInput.onChange.listen(endOnChange);
  submitButton.onClick.listen(submitOnClick);

  //http://stackoverflow.com/questions/13746105/how-to-listen-to-key-press-repetitively-in-dart-for-games
  //window.onKeyPress();
  // See the KeyEvent class in dart:html
  var stream = KeyEvent.keyPressEvent.forTarget(document.body);
  // Start listening to the stream of KeyEvents.
  stream.listen((keyEvent) =>
    print('KeyPress event detected ${keyEvent.charCode}'));

}

submitOnClick(Event e) {
  if (!isValid())
    errorMessage.text = 'Problem with inputs.  Please check.';
  else
    errorMessage.text = '';


}



void startOnChange(Event e) {
  print(startInput.value);
  start = DateTime.parse( startInput.value.substring(0,10) ).toUtc();
  print(start);

  if (!_validateStart()) return;

  if (errorMessage.text != '') errorMessage.text = '';   /// all OK here
}

void endOnChange(Event e) {
  print(endInput.value);
  end = DateTime.parse( endInput.value.substring(0,10) ).toUtc();
  print(end);

  if (!_validateEnd()) return;

  if (errorMessage.text != '') errorMessage.text = '';  /// all OK here
}

bool _validateStart() {
  if (end != null && end.isBefore(start)) {
    errorMessage.text = 'ERROR:  Cannot have end date before start date!';
    endInput.value = '';
    return false;
  } else return true;
}


bool _validateEnd() {
  if (start != null && start.isAfter(end)) {
    errorMessage.text = 'ERROR:  Cannot have start date after end date!';
    startInput.value = '';
    return false;
  } else return true;
}

/// should this validation logic stay outside?  YES
bool isValid() {
  bool isOk;

  isOk = _validateStart() && _validateEnd();

  return isOk;
}
