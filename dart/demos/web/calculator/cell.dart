library cell;




abstract class Cell {
  int row;
  int col;

}

class TextCell implements Cell {
  int row;
  int col;
  TextCell(this.row, this.col);
}
