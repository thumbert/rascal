library cell;


abstract class CellBase<T> {
  int row;
  int col;
  T contents;
}



class TextCell implements CellBase<String> {
  int row;
  int col;
  String contents;

  TextCell(this.row, this.col, {this.contents = ''});

}

class NumericCell implements CellBase<num> {
  int row;
  int col;
  num contents;

  NumericCell(this.row, this.col, {this.contents = null});
}