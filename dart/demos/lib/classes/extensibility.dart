library extensibility;

// https://en.wikipedia.org/wiki/Expression_problem
// https://www.cs.utexas.edu/~wcook/Drafts/2012/ecoop2012.pdf

abstract class Exp {
  int eval();
}

// the algebra interface
abstract class IntfAlg<Exp> {
  Exp lit(int x);
  Exp add(Exp e1, Exp e2);
}

class Lit implements Exp {
  int value;
  Lit(int this.value);
  int eval() => value;
}

class Add implements Exp {
  Exp l, r;
  Add(Exp this.l, Exp this.r);
  int eval() => l.eval() + r.eval();
}

class IntfFactory<Exp> implements IntfAlg<Exp> {
  Exp lit(int x) => new Lit(x);
  Exp add(Exp e1, Exp e2) => new Add(e1, e2);
}

abstract class Printable {
  String print();
}
class IntPrintable implements Printable {
  int x;
  IntPrintable(int this.x);
  String print() => x.toString();
}
class AddPrintable implements Printable {
  Printable l, r;
  AddPrintable(Printable this.l, Printable this.r);
  String print() => l.print() + ' + ' + r.print();
}

// the print interface
class IntfPrint implements IntfAlg<Printable> {
  Printable lit(int x) => new IntPrintable(x);
  Printable add(Printable e1, Printable e2) => new AddPrintable(e1, e2);
}


exp(IntfAlg alg) => alg.add(alg.lit(3), alg.lit(4));

main() {
  IntfFactory base = new IntfFactory();
  IntfPrint printExp = new IntfPrint();

  int x = exp(base).eval();
  print(x);
  print(exp(printExp).print());

}

