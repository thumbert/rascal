library client;

import 'dart:html';

InputElement startInput;  // start date input element
InputElement endInput;    // end date input element
DivElement errorMessage;  // how errors get communicated

UListElement bcList;
DateTime start, end;


main() {

  startInput = querySelector('#start-input');
  endInput   = querySelector('#end-input');
  errorMessage = querySelector('#footer');
  bcList = querySelector('#bc-checkbox');

  startInput.onChange.listen(startOnChange);
  endInput.onChange.listen(endOnChange);

  //http://stackoverflow.com/questions/13746105/how-to-listen-to-key-press-repetitively-in-dart-for-games
  //window.onKeyPress();
  // See the KeyEvent class in dart:html

}


void startOnChange(Event e) {
  start = DateTime.parse( startInput.value.substring(0,10) ).toUtc();
  print(start);

  if (end != null && start.isAfter(end)) {
    errorMessage.text = 'ERROR:  Cannot have start date after end date!';
    startInput.value = '';
    return;
  }

  if (errorMessage.text != '') errorMessage.text = '';   // all OK here
}

void endOnChange(Event e) {
  end = DateTime.parse( endInput.value.substring(0,10) ).toUtc();
  print(end);

  if (start != null && end.isBefore(start)) {
    errorMessage.text = 'ERROR:  Cannot have end date before start date!';
    endInput.value = '';
    return;
  }

  if (errorMessage.text != '') errorMessage.text = '';  // all OK here
}

