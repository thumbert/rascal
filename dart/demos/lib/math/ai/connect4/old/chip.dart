
class Chip {
  final String printChar;
  const Chip(this.printChar);
  @override
  String toString() => 'char: $printChar';

  @override
  bool operator ==(dynamic other) {
    if (other is! Chip) return false;
    Chip chip = other;
    return printChar == chip.printChar;
  }

  @override
  int get hashCode => printChar.hashCode;
}
