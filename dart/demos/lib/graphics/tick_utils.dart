library graphics.tick_utils;


enum TickOrientation { outside, inside }

class TickDirection {
  static const int up = 3;
  static const int down = 1;
  static const int left = 2;
  static const int right = 4;
}

enum TickCoverType {
  overcover,
  undercover
}
