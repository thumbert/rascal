// library collection.custom_iterator2;

// import 'dart:collection';

// class Square {
//   int n;
//   Square(int this.n);
// }


// class ChessBoard extends Object with IterableMixin<Square> {
//   List<Square> data;

//   ChessBoard(){
//     data = new List.generate(64, (n) => new Square(n));
//   }

//   Iterator<Square> get iterator => new ChessBoardIterator(this);
// }



// class ChessBoardIterator extends Iterator<Square> {
//   Square _current;
//   ChessBoard board;

//   ChessBoardIterator(ChessBoard this.board);

//   Square get current => _current;

//   bool moveNext() {
//     bool res = true;
//     int n = _current.n;
//     if (n < 64) {
//       _current = board.data[n+1];
//     } else {
//       res = false;
//     }

//     return res;
//   }

// }
