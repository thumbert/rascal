import 'dart:io';

import 'package:demos/math/ai/connect4/chip.dart';
import 'package:demos/math/ai/connect4/connect4.dart';
import 'package:demos/math/ai/connect4/player.dart';
import 'package:demos/math/ai/connect4/strategy.dart';

void main() {
  print("Welcome to a Connect4 game");
  print("\nWhat is your name?");
  var name = stdin.readLineSync();
  if (name.length == 0) {
    print('OK, I\'ll call you Puny the Donkey!');
    name = 'Puny the Donkey';
  } else {
    print('Hi $name!');
  }
  print(
      '\nChoose the computer level: [0] (random), 1 (aware), 2 (foresight), 3 (devilish)');
  print('From your name, you should choose level 0.  Ha-ha-ha');
  var levelInp = stdin.readLineSync();
  int level;
  if (levelInp == '') {
    level = 0;
  } else {
    level = int.tryParse(levelInp);
  }
  if (level == null) {
    print('Wrong input!  Play nice next time, jerk!');
    exit(0);
  }
  if (level == 0) {
    print('OK, chicken, let\'s go!');
  } else if (level == 1) {
    print('OK, you might have a chance.');
  } else if (level == 2) {
    print('Keep your eyes peeled or you will lose!');
  } else if (level > 3) {
    print('No chance.  Cower before my might!');
  }

  var roBottyStrategy = <int,Strategy>{
    0: RandomStrategy(),
    1: Foresight1Strategy(),
    2: Foresight2Strategy(),
  };

  Player player1, player2;
  print('\nDo you want to place the first chip? [Y]/N');
  var yesNo = stdin.readLineSync();
  if (yesNo == '' || yesNo.toLowerCase() == 'y') {
    player1 = Player(Chip('X'), InputStrategy(), name: name);
    player2 = Player(Chip('O'), roBottyStrategy[level], name: 'Ro Botty');
    print('$name playing with chips: ${player1.chip.printChar}');
    print('Ro Botty playing with chips: ${player2.chip.printChar}');
    print('$name to start');
  } else if (yesNo.toLowerCase() == 'n') {
    player1 = Player(Chip('X'), roBottyStrategy[level], name: 'Ro Botty');
    player2 = Player(Chip('O'), InputStrategy(), name: name);
    print('$name playing with chips: ${player2.chip.printChar}');
    print('Ro Botty playing with chips: ${player1.chip.printChar}');
    print('Ro Botty to start');
  } else {
    print('Wrong input!  Play nice next time, jerk!');
    exit(0);
  }

  var game = Connect4Game(player1, player2);
  var out = game.play();
  print(game.board);
  print('\nGame Over!');

  if (out == GameOutcome.tie) {
    print('Twas a long drawn battle.  Good play, mate!.  Bye');
  } else if ((out == GameOutcome.winnerPlayer1 && player1.name == 'Ro Botty') ||
      (out == GameOutcome.winnerPlayer2 && player2.name == 'Ro Botty')
  ) {
    print('********************************************');
    print('       Ro Botty WINS, $name LOSES!');
    print('********************************************');
    print('Go back and study the game.  Face me again when ready!');
  } else {
    var msg = 'Perhaps you got lucky.';
    if (level < 3) msg += '\nReady to try playing me on my next level?';
    print(msg);
  }

  exit(0);
}
