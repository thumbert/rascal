library math.ai.connect4;

import 'package:demos/math/ai/connect4/board.dart';
import 'package:demos/math/ai/connect4/move.dart';
import 'strategy.dart';
import 'player.dart';
import 'chip.dart';

enum GameOutcome { winnerPlayer1, winnerPlayer2, tie }

class Connect4Game {
  Player player1;
  Player player2;
  Board board;

  Connect4Game(this.player1, this.player2, {this.board}) {
    player1 ??= Player(Chip('X'), RandomStrategy(), name: 'A');
    player2 ??= Player(Chip('O'), RandomStrategy(), name: 'B');
    board ??= Board(chip1: player1.chip, chip2: player2.chip);
  }

  /// Play until a winner is found or the board is filled.
  GameOutcome play() {
    for (int _move = 0; _move < board.rows * board.columns; _move++) {
      var columnIndex = playerToMove.strategy.nextMove(this);
      var move = Move(playerToMove.chip, columnIndex);
      if (!move.isValid(board)) {
        print(board);
        throw StateError('Invalid move $columnIndex!');
      }
      if (move.isWinning(board)) {
        print('winning move: column $columnIndex, '
            'winner: ${playerToMove.chip.printChar}');
        board.add(columnIndex);
        if (playerToMove == player1)
          return GameOutcome.winnerPlayer2;
        else
          return GameOutcome.winnerPlayer1;
      }
      board.add(columnIndex);
    }
    /// filled the board and still no winner?  It's a tie!
    return GameOutcome.tie;
  }

  Player get playerToMove => board.chipsCount % 2 == 0 ? player1 : player2;

  // /// Given a player, return the other player
  // Player otherPlayer(Player player) => player == player1 ? player2 : player1;
}

