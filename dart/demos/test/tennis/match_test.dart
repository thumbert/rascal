library tennis.match_test;

import 'dart:math' show Random;
import 'package:demos/tennis/match.dart';
import 'package:test/test.dart';

gameTest() {
  group('Test Game', () {
    test('game scoring', () {
      Game game = new Game(Id.p1);

      expect(game.prettyScore(), '0:0');
      game.play(new Point(true));
      expect(game.isFinished(), false);

      expect(game.prettyScore(), '15:0');
      game.play(new Point(true));
      expect(game.isFinished(), false);

      expect(game.prettyScore(), '30:0');
      game.play(new Point(false));
      expect(game.isFinished(), false);
      expect(game.prettyScore(), '30:15');

      game.play(new Point(true));
      expect(game.isFinished(), false);
      expect(game.prettyScore(), '40:15');

      game.play(new Point(false));
      expect(game.isFinished(), false);
      expect(game.prettyScore(), '40:30');

      game.play(new Point(false));
      expect(game.isFinished(), false);
      expect(game.prettyScore(), '40:40');

      game.play(new Point(false));
      expect(game.isFinished(), false);
      expect(game.prettyScore(), '-:AD');

      game.play(new Point(true));
      expect(game.isFinished(), false);
      expect(game.prettyScore(), '40:40');

      game.play(new Point(true));
      expect(game.isFinished(), false);
      expect(game.prettyScore(), 'AD:-');

      game.play(new Point(true));
      expect(game.isFinished(), true);
    });

    test('is finished', () {
      Game game = new Game(Id.p1);
      var win = [true, false, true, false, true, false, true, true];
      win.forEach((b){
        game.play(new Point(b));
      });
      expect(game.isFinished(), true);
      expect(game.pointsPlayer1, 5);
      expect(game.pointsPlayer2, 3);
    });

  });
}


tiebreakerTest() {
  group('Tiebreaker test', () {
    test('server order', () {
      Tiebreak tb = new Tiebreak(Id.p2, upTo: 7);
      var order = [
        Id.p1,
        Id.p1,
        Id.p2,
        Id.p2,
        Id.p1,
        Id.p1,
        Id.p2,
        Id.p2,
        Id.p1,
        Id.p1,
        Id.p2,
        Id.p2
      ];
      for (int i = 0; i < 10; i++) {
        tb.play(new Point(true));
        expect(tb.server(), order[i]);
      }
    });
    test('scoring', () {
      Tiebreak tb = new Tiebreak(Id.p1, upTo: 7);
      var scores = ['0:1', '1:1', '1:2', '2:2', '2:3', '3:3'];
      for (int i = 0; i < 6; i++) {
        tb.play(new Point(true));
        expect(tb.prettyScore(), scores[i]);
      }
    });
    test('is finished', () {
      Tiebreak tb = new Tiebreak(Id.p1, upTo: 7);
      var win = [true, false, false, true, true, true, true, true, true];
      win.forEach((b) {
        tb.play(new Point(b));
      });
      expect(tb.prettyScore(), '2:7');
      expect(tb.isFinished(), true);
    });
  });
}




setTest() {
  group('Set tests', (){
    test('is finished', () {
      TSet set = new TSet(Id.p1, SetWinningRule.tiebreakTo7);
      set.gamesPlayer1 = 6;
      set.gamesPlayer2 = 2;
      expect(set.isFinished(), true);
      set.gamesPlayer2 = 6;
      expect(set.isFinished(), false);
    });
    test('set serving order', () {
      TSet set = new TSet(Id.p1, SetWinningRule.tiebreakTo7);
      set.gamesPlayer1 = 1;
      set.gamesPlayer2 = 0;
      expect(set.server(), Id.p2);
      set.gamesPlayer2 = 1;
      //expect(set.server(), Id.p1);
      set.gamesPlayer1 = 4;
      //expect(set.server(), Id.p1);

    });

    test('set goes to tiebreak', () {
      TSet set = new TSet(Id.p1, SetWinningRule.tiebreakTo7);
      set.gamesPlayer1 = 6;
      set.gamesPlayer2 = 6;
      expect(set.server(), Id.p1);
      set.play(new Point(true));
    });

  });
}


main() {

  Game g = simulateGame(Id.p1, seed: 1);
  print(g.prettyScore());
  print(g.winner);
  print(g.score);

//  TSet set = simulateSet(Id.p1, 1);
//  print(set.prettyScore());

//  tiebreakerTest();
//  gameTest();
  //setTest();
}
