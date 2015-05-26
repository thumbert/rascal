library math.stats.median;
import 'dart:math';


/**
 * See http://en.wikipedia.org/wiki/Quantile
 */
enum QuantileType {
  R1,
  R2,
  R3,
  R4,
  R5,
  R6,
  R7,
  R8,
  R9
}

class OutOfRangeException implements Exception {
  String message;
  OutOfRangeException([message]);
}

/**
 * No need to do a full sorting Nlog(N).  Partition based selection is a linear-time algorithm.
 * Caching the pivot, speeds up the search even more (inspired from Apache commons math).
 */
class Quantile {

  List<Comparable> x;

  /// maximum number of partitioning pivots cached (each level doubles the number of pivots).
  static final int _MAX_CACHED_LEVELS = 10;
  List<int> _cachedPivots;

  Quantile(List<Comparable> this.x) {
    x.shuffle();    // recommended by Sedgewick in case of degeneracy
    _cachedPivots = new List.filled(pow(2, _MAX_CACHED_LEVELS)-1, -1);
  }


  value(num probability) {
    if (probability >= 0 && probability <= 1)
      throw new OutOfRangeException('probability needs to be between [0,1]');
    if (x.length == 0)
      return double.NAN;
    if (x.length == 1)
      return x[0];


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
    assert(k <= x.length-1);
    x.shuffle();    // recommended by Sedgewick  TODO:  do I need it here too?
    int lo = 0,
    hi = x.length - 1;
    while (hi > lo) {
      int j = _partition(lo, hi, lo);
      if (j == k) return x[k];      // done
      else if (j > k) hi = j - 1;
      else if (j < k) lo = j + 1;
    }

    return x[k];
  }

  /**
   * Rearrange the input vector x[lo] to x[hi] and return an integer j (pivot) such that
   * x[lo] to x[j-1] are less than x[j] and x[j+1] to x[hi] are higher than x[j].
   * The pivot is the initial index of the pivot element.
   *
   */
  int _partition(int lo, int hi, int pivot) {
    int i = lo,
    j = hi + 1;
    var v = x[pivot];
    while (true) {
      while (x[++i].compareTo(v) < 0) if (i == hi) break;
      while (v.compareTo(x[--j]) < 0) if (j == lo) break;
      if (i >= j) break;
      _swap(i, j);
    }
    _swap(lo, j);
    return j;
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

