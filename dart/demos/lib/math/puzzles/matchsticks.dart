/// Scientific American Jun-2026
/// Move two sticks to make the equation true.
///  7
/// --- = 3
///  9

final sticks = {0: 6, 1: 2, 2: 5, 3: 5, 4: 4, 5: 5, 6: 6, 7: 3, 8: 7, 9: 6};

void solve() {
  for (var i = 0; i < 10; i++) {
    for (var j = 0; j < 10; j++) {
      for (var k = 0; k < 10; k++) {
        if (sticks[i]! + sticks[j]! + sticks[k]! != 14) {
          continue;
        }
        if (i / j == k) {
          print('i: $i, j: $j, k: $k');
        }
      }
    }
  }
}
