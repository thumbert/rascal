library pentagrams;


/* Calculate the unique number of n-grams and "show" them. 
 * An n-gram is a shape constructed by taking n identical squares 
 * and joining them on sides.  For example, the pentagrams 
 * are the pieces used in Kantamino. 
 * 
 * Written by AAD on 5/26/2014 
 */


/*
 * Represent an Ngram as a List of (N-1) directed links/connections/joins.
 *
 * Each link is a List with 3 elements
 * [index_block_from, index_block_to, side_of_block_from_connected]
 * Sides are labelled as follows: bottom = 1, left = 2, top = 3, right =4.
 * By convention the blocks are indexed row-wise from top left corner of the
 * Ngram.
 *
 * For example the 3-gram ABC has two links represented as
 * [[1, 2, 4], [2, 3, 4]]
 * which specify that the side 4 of block 1 is joined with block 2 and that
 * side 4 of block 2 is joined with block 3.
 *
 * The pentagram:
 * A
 * BC
 * DE  can be represented as the four links:
 *   [[1,2,1], [2,3,4], [2,4,1], [4,5,4]]
 *   and has the view "X \nXX\nXX\n"
 * And the pentagram:
 *    A  
 *   BCD    links: [[1,3,1], [2,3,4], [3,4,4], [3,5,1]]
 *    E
 */
class Ngram {
  int order;                  // the number of blocks of the N-gram
  Matrix<int> matrix;         // Put 1 for X, 0 for ' ' by column, e.g. "XX\n X" is [1,1\n0,1]
  String view;                // the visual representation, e.g. " X \nXXX\n X "
  List<String> views;         // all the 4 string representation of the Ngram, ordered
  int nrow, ncol;             // number of rows, columns of the matrix representation
  

  Ngram(List<int> data, int nrow, int ncol) {
    this.nrow = nrow;
    this.ncol = ncol;
    order = data.fold(0, (a,b) => a + b);  // count the 1's
    
    // construct all the 8 views
    views = [];
    matrix = new Matrix(data, nrow, ncol);
    views.add(matrix.makeView());
    views.add(matrix.transpose().makeView());    
    views.add(matrix.reflect_diagonal().makeView());    
    views.add(matrix.transpose_minor_diagonal().makeView());
    views.add(matrix.reflect_x().makeView());    
    views.add(matrix.reflect_y().makeView());    
    views.add(matrix.rotate90().makeView());    
    views.add(matrix.rotate270().makeView());    
            
    views.sort();
    
    view = views.first;  
  }
  
  Ngram.fromString(String view) {
    this.view = view;
    order = "X".allMatches(view).length;
    List<String> aux = view.split("\n");
    nrow  = aux.length;         
    ncol  = aux.first.length;
  }
 
    
  /*
   *  Return a List with the coordinates [i,j] of the available neighbors.  
   *  For neighbors outside the matrix, one of the indices will be = -1.
   */ 
  List<List<int>> availableNeighbors() {
     List<List<int>> res = [];
     for (int j=0; j<ncol; j++) {
       for (int i=0; i<nrow; i++) {
         if (matrix[[i,j]] == 1) {                    // only if the element is filled
           if ( i==(nrow-1) )  
             res.add([i+1,j]);                   // add the one below           
           else if ( matrix[[i+1,j]] == 0 && !_existsAlready([i+1,j], res)) 
             res.add([i+1,j]);                   // add the one below
           if ( i==0 ) 
             res.add([i-1,j]);
           else if ( matrix[[i-1,j]] == 0 && !_existsAlready([i-1,j], res))   
             res.add([i-1,j]);                   // add the one on top
           if ( j==0 ) 
             res.add([i,j-1]);                
           else if (matrix[[i,j-1]] == 0 && !_existsAlready([i,j-1], res)) 
             res.add([i,j-1]);                   // add the one to the left     
           if ( j==(ncol-1) ) 
             res.add([i,j+1]); 
           else if ( matrix[[i,j+1]] == 0 &&  !_existsAlready([i,j+1], res)) 
             res.add([i,j+1]);                   // add the one to the right 
         }
       }
     }
     
     return res;
  }
  
  // Check if an element already exists in the list 
  bool _existsAlready(List<int> element, List<List<int>> list) => 
    list.any((e) => e[0] == element[0] && e[1] == element[1]);
  
  /*
   * Extend this Ngram and create the next higher order Ngrams.  
   */
  Set<Ngram> extend() {
    Set<Ngram> res = new Set();
    List<List<int>> coords = getCoords();
    
    List<List<int>> neighbors = availableNeighbors();
    neighbors.forEach((List<int> e) {
      var lcoords = coords.map((a) => [a[0], a[1]]).toList();  // the new coords
      lcoords..add([e[0],e[1]]);
      if (e[0] < 0)        // extend rows
        lcoords.forEach((a) => a[0] += 1);
      if (e[1] < 0)        // extend columns
        lcoords.forEach((a) => a[1] += 1);      
      Matrix m = new Matrix.fromCoordinates(lcoords);
      res.add(new Ngram(m.data, m.nrow, m.ncol));
    });
    
    
    return res;
  }
  
  List<List<int>> getCoords() {
    List<List<int>> coords = [];
    for (int i=0; i<nrow; i++) {
      for (int j=0; j<ncol; j++) {
        if (matrix[[i,j]] == 1) 
          coords.add([i,j]);
      }
    }
    return coords;
  }
  
  // construct the string view from a List of integers by column.   
  String viewFromData() {
    StringBuffer aux = new StringBuffer();
    for (int i=0; i<nrow; i++) {
      for (int j=0; j<ncol; j++) {
        if (matrix[[i,j]] == 1) {
          aux.write("X"); 
        } else {
          aux.write(" "); 
        }
        if (j == (ncol-1) && i < (nrow-1)) aux.write("\n");       
      }     
    } 
    
    return aux.toString();
  }
  
  
  /*
   * Represent each block as an X. 
   */
  toString() => view;
  
  bool operator ==(that) {
    return view == that.view;
  }
  
  int get hashCode => view.hashCode;
  
}



/*
 * Generate all the Ngrams of a given order 
 */
Map<int, Set<Ngram>> generate(int order) {
  Map<int, Set<Ngram>> results = { 
    1 : new Set()..add(new Ngram([1], 1, 1)),            // "X"                              
    2 : new Set()..add(new Ngram([1,1], 1, 2)),          // "XX"
    3 : new Set()..addAll([new Ngram([1,1,1], 1, 3),     // "XXX"
                           new Ngram([1,0,1,1], 2, 2)])  // "XX\nX "
  };                             
  
  for (int i=4; i<= order; i++) {
    results[i] = new Set();
    Set<Ngram> prev = results[i-1]; 
    prev.forEach((Ngram g) {
      var aux = g.extend();
      results[i] = results[i].union(aux);
    });
  }
  
  return results;
}



class Matrix<A> {
  int nrow;  
  int ncol;  
  List data; 
  
  Matrix(List data, int nrow, int ncol, {bool byrow: false}) {
    assert(data.length == nrow * ncol);
    this.data = data;
    this.nrow = nrow;
    this.ncol = ncol;
  }
  
  Matrix.fromCoordinates(List<List<int>> coords) {
    // find the dimensions
    int maxR = 0;
    int maxC = 0;
    coords.forEach((List e) {
      if (e[0] > maxR) maxR = e[0];
      if (e[1] > maxC) maxC = e[1];        
    });
    nrow = maxR+1;
    ncol = maxC+1;
    data = new List.filled(nrow*ncol, 0);
    // set the elements
    coords.forEach((e) => data[e[0] + nrow*e[1]] = 1);  
  }
  
  operator []=(List<int> coord, value) {
    data[coord[0] + nrow*coord[1]] = value;
  }
  
  operator [](List<int> coord) => data[coord[0] + nrow*coord[1]];
  
  
   
  // transpose this matrix, there are efficient algorithms for this ...
  Matrix transpose() {
    List dataNew = [];
    for (int i=0; i<nrow; i++) {
      for (int j=0; j<ncol; j++) {
        dataNew.add(data[j*nrow + i]);
      }
    }
    
    return new Matrix(dataNew, ncol, nrow);
  }
  
  Matrix transpose_minor_diagonal() {
    List dataNew = [];
    for (int i=0; i<nrow; i++) {
      for (int j=0; j<ncol; j++) {
        dataNew.add(data[nrow*ncol - j*nrow - i -1]);
      }
    }
        
    return new Matrix(dataNew, ncol, nrow);
  }
  
  Matrix reflect_diagonal() {
    List dataNew = [];
    for (int j=0; j<ncol; j++) {
      for (int i=0; i<nrow; i++) {
        dataNew.add(data[nrow*ncol - j*nrow - i -1]);
      }
    }
        
    return new Matrix(dataNew, nrow, ncol);
  }
  
  Matrix reflect_x() {
    List dataNew = [];
    for (int j=(ncol-1); j>=0; j--) {
      for (int i=0; i<nrow; i++) {
        dataNew.add(data[i+j*nrow]);
      }
    }
        
    return new Matrix(dataNew, nrow, ncol);
  }

  Matrix reflect_y() {
    List dataNew = [];
    for (int j=0; j<ncol; j++) {
      for (int i=(nrow-1); i>=0; i--) {
        dataNew.add(data[i+j*nrow]);
      }
    }
        
    return new Matrix(dataNew, nrow, ncol);
  }

  Matrix rotate90() {
    List dataNew = [];
    for (int i=(nrow-1); i>=0; i--) {
      for (int j=0; j<ncol; j++) {
        dataNew.add(data[i+j*nrow]);
      }
    }
    
    return new Matrix(dataNew, ncol, nrow);
  }
  
  Matrix rotate270() {
    List dataNew = [];
    for (int i=0; i<nrow; i++) {
      for (int j=(ncol-1); j>=0; j--) {
        dataNew.add(data[i+j*nrow]);
      }
    }
    
    return new Matrix(dataNew, ncol, nrow);
  }
  
  
  String makeView() {
    StringBuffer aux = new StringBuffer();
    for (int i=0; i<nrow; i++) {
      for (int j=0; j<ncol; j++) {
        if (data[i + nrow*j] == 1) {
          aux.write("X"); 
        } else {
          aux.write(" "); 
        }
        if (j == (ncol-1) && i < (nrow-1)) aux.write("\n");       
      }     
    } 
    
    return aux.toString();  
  }
  
  toString() {
    List<String> out = [];
    for (int i=0; i<nrow; i++) {
      List<String> row = [];
      for (int j=0; j<ncol; j++) {
         row.add( data[j*nrow + i] );
      }
      out.add(row.join(" "));
    }
    return out.join("\n");  
  }

  bool operator ==(that) {
    if (that.nrow != nrow || that.ncol != ncol)
      return false;
    
    for (int i=0; i<nrow*ncol; i++) {
      if (data[i] != that.data[i])
        return false;
    }
    
    return true;
  }
  
  bool isSimilar(Matrix that) {
    if (this == that || this == that.transpose() || 
        this == that.reflect_diagonal() || this == that.transpose_minor_diagonal()) {
      return true;        
    } else {
      return false;
    }
  }

  
}


main() {
 
  // see the tests
  // http://oeis.org/  found it!
//  order    number of Ngrams
//  1        1
//  2        1
//  3        2
//  4        5
//  5        12
//  6        35
//  7        108
//  8        369
//  9        1285
//  10       4655
//  11       17073
//  12       63600
//  
  
}





