library pentagrams;


/* Calculate the unique number of n-grams and "show" them. 
 * An n-gram is a shape constructed by taking n identical squares 
 * and joining them on sides.  For example, the pentagrams 
 * are the pieces used in Kantamino. 
 * 
 * Written by AAD on 5/26/2014 
 */


/*
 * Represent an Ngram as a series of (N-1) directed connections/links/joins.  
 * For example the 3-gram ABC is represented as the 2 links [[1, 2, 4], [2, 3, 4]] 
 * which specify that the side 4 of block 1 is joined with block 2 (side 2) and 
 * side 4 of block 2 is joined with block 3 (side 2). 
 * The pentagram:
 * A
 * BC
 * DE  can be represented as the (minimal) links: 
 *   [[1,2,1], [2,3,4], [2,4,1], [4,5,4]]
 *   and has the view "X \nXX\nXX\n"
 * And the pentagram:
 *    A  
 *   BCD    links: [[1,3,1], [2,3,4], [3,4,4], [3,5,1]]
 *    E
 * So each element of the links List is a list with 3 elements 
 * [index_block_from, index_block_to, side_of_block_from_connected]
 * By convention the blocks are indexed from top left corner of the Ngram   
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
  
  bool operator ==(Ngram that) {
    return view == that.view;
  }
}


Map<int, Set<Ngram>> results = { 
  1 : new Set()..add(new Ngram([1], 1, 1)),            // "X"                              
  2 : new Set()..add(new Ngram([1,1], 1, 2)),          // "XX"
  3 : new Set()..addAll([new Ngram([1,1,1], 1, 3),     // "XXX"
                         new Ngram([1,0,1,1], 2, 2)])  // "XX\nX "
};                                                            

/*
 * Generate all the Ngrams of a given order 
 */
generate(int order) {
  if (results.keys.contains(order)) {
    return results[order];
  } else {
    // generate previous order and extend it 
    generate(order - 1);
    results[order] = new Set();
    Set<Ngram> prev = results[order-1]; 
    prev.forEach((Ngram g) {
      results[order].union(g.extend());
    });
  }  
}


void show_Ngrams(int order) {
  if (!results.keys.contains(order)) {
    generate(order);
  }
  print("\nThere are ${results[order].length} Ngrams of order $order.\n");
  results[order].forEach((s) {
    print(s.view + "\n");
  });
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

  bool operator ==(Matrix that) {
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
 
  show_Ngrams(3);
  
}






/*
 * Go from a List of links to the coordinate view by traversing the links. 
 * Construct the Map<blockIndex, List<xCoord, yCoord>> that represents 
 * the Ngram in the plane.  
 */
//  fromLinksToCoordinates() {
//    // start from block 1 at (0,0)
//    int block = 1;
//    coords = [0,0]; 
//    List<int> nextBlocks = [];  // blocks that need to be explored
//    
//    while ( true ) {
//      print("Working on block $block");
//      List<List<int>> newLinks = getLinksFromBlock( block )
//          ..retainWhere((link) => !coords.keys.contains(link[1]));
//       
//      newLinks.forEach((List<int> link) {
//        int toBlock = link[1];
//        if (!coords.keys.contains(toBlock)) {
//          print("--Adding block $toBlock");
//          switch (link[2]) {          // depending on connecting side
//            case 1: coords[toBlock] = [coords[block][0]+1, coords[block][1]]; break;
//            case 2: coords[toBlock] = [coords[block][0], coords[block][1]-1]; break;
//            case 3: coords[toBlock] = [coords[block][0]-1, coords[block][1]]; break;
//            case 4: coords[toBlock] = [coords[block][0], coords[block][1]+1]; break;
//          }
//          nextBlocks.add(toBlock);
//        }
//      }); 
//      
//      // pick another block that is not yet mapped
//      Set<int> rest = _allBlocks.difference(coords.keys.toSet());
//      if (rest.isEmpty) 
//        break;
//      block = nextBlocks.first;
//      nextBlocks.removeAt(0);
//      print(coords);
//    }
//    
//    // check if the needs to be shifted, such that min x or y coord is 0!
//    int minX = 0;
//    int minY = 0;
//    maxX = 0;
//    maxY = 0;
//    coords.values.forEach((e) {
//      if (e[0] < minX) minX = e[0];
//      if (e[1] < minY) minY = e[1];
//      if (e[0] > maxX) maxX = e[0];
//      if (e[1] > maxY) maxY = e[1];
//    });
//    if (minX != 0 || minY != 0) {
//      coords.forEach((k,v) {
//        v[0] -= minX;
//        v[1] -= minY;
//      });
//      maxX -= minX;
//      maxY -= minY;
//      //print("$maxX, $maxY");
//    }
//  }

// put an X at coordinates (i,j) of the view
//  List<String> setView(List<String> view, int i, int j) {
//    view[i] = view[i].substring(0,j) + "X" + view[i].substring(j+1);
//    return view;
//  }


//  Ngram (int order, List<List<int>> links) {
//    // check that you have enough links
//    assert(order-1 == links.length);    
//    this.order = order;
//    
//    /* check that all the blocks are connected (each block shows up 
//     * at least once in the links).  
//     */
//    Set<int> blocks = links.expand((e) => [e[0], e[1]]).toSet();
//    Set<int> allBlocks = new List.generate(order, (i) => i+1).toSet();
//    assert(allBlocks.difference(blocks).isEmpty);
//    
//    // check that all connection sides are in [1,2,3,4]
//    assert([1,2,3,4].toSet().containsAll( links.map((e) => e[2]).toSet() ));
//    this.links = links;
//    
//    _allBlocks = new List.generate(order, (i) => i+1).toSet();
//    
//    // make the coordinates
//    //fromLinksToCoordinates();
//  }


/*
 * Get all the links starting from block i.  Can be more than one link. 
 * Return them in the direction from block i as a List of links. 
 */  
//  List<List<int>> getLinksFromBlock(int i) { 
//    List<List<int>> linksFromThisBlock = [];
//    links.forEach((e) {
//      if (e[0] == i) {
//        linksFromThisBlock.add(e);
//      } else if (e[1] == i) {
//        linksFromThisBlock.add([e[1], e[0], reverseSide(e[2])]);      
//      }
//    });
//    
//    return linksFromThisBlock;
//  }

//  // calculate the border and return the list of coordinates
//  List<List<int>> border() {
//    List<List<int>> res = [];
//    coords.forEach((List<int> e) {
//      res.addAll([ [e[0]+1, e[1]],
//                   [e[0],   e[1]-1],
//                   [e[0]-1, e[1],
//                   [e[0],   e[1]+1]] ]);
//    });
//    
//    // need to remove duplicates and the ones in coords
//    return res;
//  }
//      
//  
//  int reverseSide(int side) {
//    int reverseSide;
//    switch (side) {
//      case 1 : reverseSide = 3; break;
//      case 2 : reverseSide = 4; break;
//      case 3 : reverseSide = 1; break;
//      case 4 : reverseSide = 2; break;
//    }
//    return reverseSide;
//  }
//  
//  List<int> reverseLink(List<int> link) => [link[1], link[0], reverseSide(link[2])];

//
//class Square {
//  String name;
//  List<int> sides = [1, 2, 3, 4];    // bottom, left, top, right
//  List<int> freeSides = [1, 2, 3, 4];
//  
//  Square();  
//}
//
//// not used ...
//class Link {
//  int fromBlock;
//  int toBlock;
//  int sideConnected;  // from the point of view of fromBlock
//  
//  Link(int this.fromBlock, int this.toBlock, int this.sideConnected);
//}

//  /*
//   * Costruct the Ngram from a list of coordinates. 
//   * No check is made if the min of one coordinate is 0.   
//   */ 
//  Ngram.fromCoordinates(List<List<int>> coords) {
//    this.coords = coords;
//    order = coords.length;
//    
//    nrow = 0;
//    ncol = 0;
//    coords.forEach((e) {
//      if (e[0] > nrow) nrow = e[0];
//      if (e[1] > ncol) ncol = e[1];
//    });
//    nrow += 1;
//    ncol += 1;
//    
//    view = viewFromCoords();
//  }
// 


//    coords =  [];
//    for (int j=0; j<ncol; j++) {
//      for (int i=0; i<nrow; i++) {
//        if (data[i + nrow*j] == 1) {
//          coords.add([i,j]);
//        }
//      }     
//    }

//  // construct the string view from coords list   
//  String viewFromCoords() {
//    List<String> view = new List.filled(nrow, " " * ncol);
//    coords.forEach((v) {
//      view[v[0]] = view[v[0]].substring(0,v[1]) + "X" + view[v[0]].substring(v[1]+1);
//    });
//    
//    return view.join("\n");
//  }

//_expandCoords_x() => coords.forEach((k,v) => v[0]++);
//_expandCoords_y() => coords.forEach((k,v) => v[1]++);


//List<int> shift_left(List<int> s) =>  s.sublist(1)..add(s[0]);
//
//bool list_equal(List<int> x, List<int> y) {
//  bool res = true;
//  for (int i=0; i<x.length; i++) {
//    if (x[i] != y[i]) { 
//      res = false;
//      break;
//    }
//  }
//  return res;
//}
