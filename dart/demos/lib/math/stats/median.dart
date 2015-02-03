library math.stats.median;
import 'dart:math';

class Quantile {

  List<Comparable> x;
  
  Quantile(List<Comparable> this.x) {
    x.shuffle();    // recommended by Sedgewick
  }
  
  /**
   * Rearange the input vector x[lo] to x[hi] and return an integer j such that 
   * x[lo] to x[j-1] are less than x[j] and x[j+1] to x[hi] are higher than x[j]. 
   * The pivot element x[j] is chosen as the x[lo] of the original array. 
   */
  int _partition(int lo, int hi) {
    int i = lo,
        j = hi + 1;
    var v = x[lo];
    while (true) {
      while (x[++i].compareTo(v) < 0) if (i == hi) break;
      while (v.compareTo(x[--j]) < 0) if (j == lo) break;
      if (i >= j) break;
      _swap(i, j);
    }
    _swap(lo, j);
    return j;
  }
  
  value(num probability) {
    
  }
  
  /**
   * Calculate the minimum value.  One traversal. 
   */
  min() {
    
  }
  
  
  /**
   * Return the k-th smallest element of the array.  The input argument [k] is 
   * between 0 and [x.length]-1.  So if k=0, you return the array minimum.
   */
  minK(int k) {
    x.shuffle();    // recommended by Sedgewick
    int lo = 0,
        hi = x.length - 1;
    while (hi > lo) {
      int j = _partition(lo, hi);
      if (j == k) return x[k];      // done
      else if (j > k) hi = j - 1;
      else if (j < k) lo = j + 1;
    }
    
    return x[k];
  }

  void _sortLoHi(int lo, int hi) {
    if (hi <= lo) return;
    int j = _partition(lo, hi);
    _sortLoHi(lo, j-1);
    _sortLoHi(j+1, hi);
  }
  
  void _swap(int i, int j) {
    var t = x[i];
    x[i] = x[j];
    x[j] = t;
  }
  
  sort() => _sortLoHi(0, x.length-1);
  
  
}




/**
 * Find the n-th smallest element of the numerical List x
 */
num quantile_bad(List<num> x, int n) {
  int low, high;
  int median;
  int middle, ll, hh;

  void swap(int i, int j) {
    num t = x[i];
    x[i] = x[j];
    x[j] = t;
  }

  low = 0;
  high = n - 1;
  while (true) {
    if (high <= low + 1) {
      /// two elements only
      if (high == low + 1 && x[low] > x[high]) swap(low, high);
      return x[n - 1];
    } else {

      // find median of low, middle and high items; swap into position low
      middle = (low + high) ~/ 2;
      // swap low item (now in position middle) into position (low+1)
      swap(middle, low + 1);

      if (x[low] > x[high]) swap(low, high);
      if (x[middle] > x[high]) swap(middle, high);
      if (x[middle] > x[low]) swap(middle, low);


      // nibble from each end towards middle, swapping elements when stuck
      ll = low + 1;
      hh = high;
      while (true) {
        do ll++; while (x[low] > x[ll]);
        do hh--; while (x[hh] > x[low]);

        if (hh < ll) break;

        swap(ll, hh);
      }

      // swap middle item (in position low) back into correct position
      swap(low, hh);

      // reset active partition
      if (hh <= median) low = ll;
      if (hh >= median) high = hh - 1;
    }
  }
}
