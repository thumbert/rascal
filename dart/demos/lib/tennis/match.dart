library tennis.match;

import 'dart:math' show Random;

/// A player id, to identify during the match.  Player 1 and player 2.
enum Id { p1, p2 }

Id otherPlayer(Id one) {
  if (one == Id.p1) return Id.p2;
  else return Id.p1;
}

enum MatchFormat { twoSetsAndSuperTb, bestOfThree, bestOfFive, }

enum SetWinningRule { winByTwoGames, tiebreakTo7 }

enum GameWinningRule { normal, noAdScoring }

enum ServerOrReturner { server, returner }

class Match {
  MatchFormat matchFormat;
  SetWinningRule setWinningRule;
  int _setsPlayer1 = 0;
  int _setsPlayer2 = 0;

  Player player1, player2;
  Id playerServingFirst;
  Tiebreak tb;

  Match(this.playerServingFirst, this.matchFormat, this.setWinningRule) {
    if (matchFormat == MatchFormat.twoSetsAndSuperTb) {
      tb = new Tiebreak(playerServingFirst, upTo: 10);
    }
  }

  void playPoint() {}

  /// Check if the match is finished.
  bool isFinished() {
    if (matchFormat == MatchFormat.twoSetsAndSuperTb) {
      if (setsPlayer1 == 2 || setsPlayer2 == 2 || tb.isFinished()) return true;
    } else {
      throw 'Match format $matchFormat not implemented yet';
    }
    return false;
  }

  /// number of sets won by player 1
  int get setsPlayer1 => _setsPlayer1;

  /// number of sets won by player 2
  int get setsPlayer2 => _setsPlayer2;
}

class TSet {
  SetWinningRule setWinningRule;
  List<Game> games = [];
  int _gamesPlayer1 = 0;
  int _gamesPlayer2 = 0;
  Tiebreak tb;
  bool inTiebreaker = false;
  Id playerServingFirst;
  Game currentGame;

  /// A tennis set
  TSet(this.playerServingFirst, this.setWinningRule) {
    currentGame = new Game(playerServingFirst);
  }


  /// number of games won by player 1
  int get gamesPlayer1 => _gamesPlayer1;

  /// number of games won by player 2
  int get gamesPlayer2 => _gamesPlayer2;

//  /// If you want to move ahead, because of a scoring mistake.
//  void moveTo(int g1, int g2) {
//
//  }

  /// Return the current server
  Id server() {
    if (inTiebreaker) {
      return tb.server();
    } else return currentGame.playerServing;
  }

  /// Play the set one point at a time.  Throws if a point is
  /// played after the set is finished.
  void play(Point point) {
    if (isFinished()) throw 'Set is finished.';

    print(prettyScore());
    if (currentGame.isFinished()) {
      games.add(currentGame);
      if (currentGame.winner == Id.p1) {
        _gamesPlayer1 += 1;
      } else {
        _gamesPlayer2 += 1;
      }
      if (setWinningRule == SetWinningRule.tiebreakTo7 && gamesPlayer1 == 6
        && gamesPlayer2 == 6) {
        inTiebreaker = true;
        tb = new Tiebreak(otherPlayer(currentGame.playerServing), upTo: 7);
        currentGame = null;
      } else {
        currentGame = new Game(otherPlayer(currentGame.playerServing));
      }
    }
    if (inTiebreaker) {
      tb.play(point);
    } else {
      currentGame.play(point);
    }
  }

  /// Check if the set is finished.
  bool isFinished() {
    bool res = false;
    bool upBy2 = (gamesPlayer1 - gamesPlayer2).abs() >= 2;

    if ((gamesPlayer1 == 6 || gamesPlayer2 == 6) && upBy2) return true;

    if (setWinningRule == SetWinningRule.tiebreakTo7 && inTiebreaker) {
      if (tb.isFinished()) return true;
    } else {
      if (upBy2) return true;
    }
    return res;
  }

  String prettyScore() {
    String res;
    if (isFinished()) {
      res = '$gamesPlayer1:$gamesPlayer2';
    } else {
      res = '$gamesPlayer1:$gamesPlayer2 ${currentGame.orderedScore()}';
    }
    return res;
  }

}

class Game {
  List<Point> points = [];
  int _pointsPlayer1 = 0;
  int _pointsPlayer2 = 0;

  /// the score from the point of view of the server
  /// value = 1 if server wins, -1 if returner wins.
  List<int> score = [];

  /// number of winners and errors from the point of view of the server
  int w = 0, e = 0;
  Id playerServing;

  static List<String> values = ['0', '15', '30', '40', 'AD'];

  Game(this.playerServing) {}

  /// Return the Id of the player who won the game.  Will throw
  /// if the game has not finished yet.
  Id get winner {
    Id res;
    if (isFinished()) {
      if (pointsPlayer1 > pointsPlayer2) return Id.p1;
      else return Id.p2;
    } else throw 'Game has not finished yet';
    return res;
  }

  /// How many points have been won by player 1
  int get pointsPlayer1 => _pointsPlayer1;

  /// How many points have been won by player 2
  int get pointsPlayer2 => _pointsPlayer2;

  void play(Point point) {
    if (isFinished()) throw 'Game has finished';
    points.add(point);
    if (point.hasServerWon) {
      if (playerServing == Id.p1) _pointsPlayer1 += 1;
      else _pointsPlayer2 += 1;
      w += 1;
      score.add(1);
    } else {
      if (playerServing == Id.p1) _pointsPlayer2 += 1;
      else _pointsPlayer1 += 1;
      e += 1;
      score.add(-1);
    }
  }

  /// Score from the point of view of the server.
  String prettyScore() {
    String res;
    if (isFinished())
      return w > e ? '1:0' : '0:1';

    if (score.length <= 6) {
      res = '${Game.values[w]}:${Game.values[e]}';
    } else {
      if (score.length % 2 == 0) {
        res = '40:40';
      } else {
        if (w > e) res = 'AD:-';
        if (w < e) res = '-:AD';
      }
    }
    return res;
  }

  /// Score for the electronic scoreboard.
  String orderedScore() {
    String res;
    if (score.length <= 6) {
      res = '${Game.values[pointsPlayer1]}:${Game.values[pointsPlayer2]}';
    } else {
      if (score.length % 2 == 0) {
        res = '40:40';
      } else {
        if (w > e) res = 'AD:-';
        if (w < e) res = '-:AD';
      }
    }

    return res;
  }

  /// Show if the game is finished or not.
  bool isFinished() {
    bool res = false;
    if (score.length >= 4) {
      /// more than 4 points or more have been played, so it could be over
      if (score.length < 7) {
        if (w == 4 || e == 4) return true;
      } else if (score.length % 2 == 0 && (w - e).abs() == 2) {
        return true;
      }
    }
    return res;
  }
}

class Tiebreak {
  num upTo;
  int _pointsPlayer1 = 0;
  int _pointsPlayer2 = 0;
  Id playerServingFirst;
  List<Point> points = [];

  /// Play a tiebreaker
  Tiebreak(this.playerServingFirst, {this.upTo: 7}) {}

  int get pointsPlayer1 => _pointsPlayer1;
  int get pointsPlayer2 => _pointsPlayer2;

  /// Returns who serves the next point
  Id server() {
    int sum = pointsPlayer1 + pointsPlayer2;
    if (sum == 0) return playerServingFirst;
    var g = sum % 4 + 2;
    if (g == 3 || g == 4) return otherPlayer(playerServingFirst);
    else return playerServingFirst;
  }

  bool isFinished() {
    if (pointsPlayer1 == upTo &&
        (pointsPlayer1 - pointsPlayer2) >= 2) return true;
    if (pointsPlayer2 == upTo &&
        (pointsPlayer2 - pointsPlayer1) >= 2) return true;
    return false;
  }

  void play(Point point) {
    if (isFinished()) throw 'Game has finished';
    points.add(point);
    if (point.hasServerWon) {
      if (server() == Id.p1) _pointsPlayer1 += 1;
      else _pointsPlayer2 += 1;
    } else {
      if (server() == Id.p1) _pointsPlayer2 += 1;
      else _pointsPlayer1 += 1;
    }
  }

  /// the score is always from the server's point of view!
  String prettyScore() {
    if (server() == Id.p1) return '$pointsPlayer1:$pointsPlayer2';
    else return '$pointsPlayer2:$pointsPlayer1';
  }
}

class Point {
  bool hasServerWon;
  int serverShotId;
  int returnerShotId;

  Point(this.hasServerWon, {this.serverShotId, this.returnerShotId}) {
    if (hasServerWon) {
      if (category['score'] ==
          -1) throw 'Server could not have won with ${category[serverShotId]}';
    } else {
      if (category['score'] ==
          1) throw 'Returner could not have won the point with ${category[returnerShotId]}';
    }
  }
}

Map<int, Map> category = {
  1: {'comment': 'double fault', 'score': -1},
  2: {'comment': 'service return error', 'score': 1},
  3: {'comment': 'unforced error groundstroke'},
  4: {'comment': 'volley error'},
  5: {'comment': 'service ace', 'score': 1},
  6: {'comment': 'groundstroke winner'},
  7: {'comment': 'lob winner'},
  8: {'comment': 'volley/overhead winner'}
};

class Player {
  String name;
  int id;

  Player(this.name);
}

Game simulateGame(Id server, {int seed: 1}) {
  Random r = new Random(seed);
  Game game = new Game(server);
  while (!game.isFinished()) {
    game.play(new Point(r.nextBool()));
  }
  return game;
}

TSet simulateSet(Id server, {int seed: 1}) {
  Random r = new Random(seed);
  TSet set = new TSet(Id.p1, SetWinningRule.tiebreakTo7);
  while(!set.isFinished()) {
    set.play(new Point(r.nextBool()));
  }
  return set;
}
