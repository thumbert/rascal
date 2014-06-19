library test_pentagrams;

import 'package:unittest/unittest.dart';
import 'package:demos/math/combinatorics/pentagrams.dart';

main() {
  
  test("create a 5-gram from data", (){
    Ngram g = new Ngram([1,0,1,0,1,1], 2, 3);
    expect(g.order, 4);
    expect(g.nrow, 2);
    expect(g.ncol, 3);
    //g.views.forEach((e)=>print(e+"\n\n"));
    expect(g.view, "  X\nXXX");    
  });
 
  test("create a 5-gram from string", (){
    Ngram g = new Ngram.fromString("XXXX\n   X");
    expect(g.order, 5);
    expect(g.nrow, 2);
    expect(g.ncol, 4);
  });
    
  test("equality of Ngrams", () {
    Ngram g1 = new Ngram([1,0,1,0,1,0,1,1], 2, 4);
    Ngram g2 = new Ngram([1,1,1,1,1,0,0,0], 4, 2);
    expect(g1==g2, true);
  });
  
  test("check neighbors", () {
    Ngram g = new Ngram([1,0,1,0,1,1], 2, 3);
    expect(g.availableNeighbors(), 
        [[1, 0], [-1, 0], [0, -1], [1, 1], [-1, 1], [-1, 2], [0, 3], [2, 2], [1, 3]]);
    
  });
  
  test("extend Ngrams", () {
    Ngram g = new Ngram([0,1,0,1,1,1], 2, 3);
    //g.extend().forEach((g) => print(g.toString() + "\n"));    
  });
  
  test("generate order 3", () {
    generate(3);
    results[3].forEach((g) => print(g.toString() + "\n"));
  });

  solo_test("generate order 4", () {
    generate(4);
    results[4].forEach((g) => print(g.toString() + "\n"));
  });

  
  test("matrix setting", (){
    Matrix m = new Matrix(new List.filled(6, 0), 3, 2);
    m[[1,0]] = 2;
    m[[2,1]] = 4;
    expect(m.toString(), "0 0\n2 0\n0 4");
  });
  
  test("matrix reshaping", () {
    Matrix m = new Matrix([1,1,1,1,0,0,0,1], 4, 2);
    expect(m.transpose(), new Matrix([1,0,1,0,1,0,1,1], 2, 4));
    //print(m.rotate270());
    expect(m.reflect_diagonal(), new Matrix([1,0,0,0,1,1,1,1], 4, 2));
    expect(m.transpose_minor_diagonal(), new Matrix([1,1,0,1,0,1,0,1], 2, 4));
    expect(m.reflect_x(), new Matrix([0,0,0,1,1,1,1,1], 4, 2));
    expect(m.reflect_y(), new Matrix([1,1,1,1,1,0,0,0], 4, 2));
    expect(m.rotate90(),  new Matrix([1,1,1,0,1,0,1,0], 2, 4));
    expect(m.rotate270(), new Matrix([0,1,0,1,0,1,1,1], 2, 4));
  });
  
  test("matrix from coordinates", () {
    Matrix m = new Matrix.fromCoordinates([[1,1], [3,2]]);
    expect(m.data, [0,0,0,0,0,1,0,0,0,0,0,1]);
  });
  
  
}