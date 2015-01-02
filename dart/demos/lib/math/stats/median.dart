library math.stats.median;

class Quantile {

  List<Comparable> x;
  
  Quantile(this.x);
  
  swap(int i, int j) {
    var t = x[i];
    x[i] = x[j];
    x[j] = t;
  }

  int partition(int lo, int hi) {
    int i = lo,
        j = hi + 1;
    var v = x[lo];
    while (true) {
      while (x[++i].compareTo(v) < 0) if (i == hi) break;
      while (v.compareTo(x[--j]) < 0) if (j == lo) break;
      if (i >= j) break;
      swap(i, j);
    }
    swap(lo, j);
    return j;
  }
  
  value(num probability) {
    
  }

  _sortLoHi(int lo, int hi) {
    if (hi <= lo) return;
    int j = partition(lo, hi);
    _sortLoHi(lo, j-1);
    _sortLoHi(j+1, hi);
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
