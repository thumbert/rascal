library plots.layout;

import 'dart:math' as math;

/**
 * Partition the plotting area into equal area panels.  Individual panels 
 * get indexed by an integer between 1 and nRows x nCols in row-major order, 
 * starting from the lower left corner of the plotting area.  You may have 
 * no data to plot in some of the panels, if for example you have only 4 panels 
 * and you choose a Layout(3,2), the last 2 panels will be empty.  
 */
class Layout {
  int nRows; // 1-based indexing
  int nCols; // 1-based indexing

  Layout(this.nRows, this.nCols);

  static Layout defaultLayout(int nPanels) {
    assert(nPanels > 0);
    Layout res;
    switch (nPanels) {
      case 1:
        res = new Layout(1, 1);
        break;
      case 2:
        res = new Layout(1, 2);
        break;
      case 3:
        res = new Layout(1, 3);
        break;
      case 4:
        res = new Layout(2, 2);
        break;
      case 5:
        res = new Layout(2, 3);
        break;
      case 6:
        res = new Layout(2, 3);
        break;
      default:
        {
          var n = math.sqrt(nPanels).round().toInt();
          if (n * n == nPanels) {
            res = new Layout(n, n);
          } else if (n * (n + 1) > nPanels) {
            res = new Layout(n, n + 1);
          } else {
            res = new Layout(n + 1, n + 1);
          }
          break;
        }
    }

    return res;
  }


  /** 
   * Find out which sides of a panel needs to have tick labels.  
   * The default is to use alternating tick labels, with the 
   * lower left panel having tick labels for both 1 and 2 axis.
   * This should be called only if the panel has exterior sides, there 
   * are no labels for the interior panels.
   * 
   */
  Set<int> axesWithTicks(int panelNumber, Set<int> exteriorSides) {
    Set<int> res = new Set<int>();
    if (exteriorSides.isNotEmpty) {
      int i = rowIndex(panelNumber);
      int j = colIndex(panelNumber);

      if (exteriorSides.contains(1) && j % 2 == 0) res.add(1);
      if (exteriorSides.contains(2) && i % 2 == 0) res.add(2);
      if (exteriorSides.contains(3) && j % 2 == 1) res.add(3);
      if (exteriorSides.contains(4) && i % 2 == 1) res.add(4);
    }

    return res;
  }

  /**
   * Find the exterior sides of a panel in a panel layout.
   * Useful for showing tick marks.  By default, 
   * tick marks are showed on exterior sides only. 
   * You may have somebody request a layout that results in some  
   * full empty rows, show axes correctly in this case too.  
   * 
   * @param panelNumber the panel number, an integer between 0 .. (nPanels-1)
   * @param nPanels the number of panels to plot 
   * @return a set with the exterior sides of this panel, which will need to be drawn  
   */
  Set<int> getExteriorSides(int panelNumber, int nPanels) {
    assert(panelNumber <= nPanels);

    var extSides = new Set<int>();
    if (nPanels == 0) {
      extSides.addAll([1, 2, 3, 4]);
    } else {
      int filledRows = (nPanels - 1) ~/ nCols;
      int lastRow = math.min(filledRows, nRows - 1);
      int lastCol = (nPanels - 1) % nCols;
      int i = rowIndex(panelNumber);
      int j = colIndex(panelNumber);

      if (i == 0) extSides.add(1);
      if (j == 0) extSides.add(2);
      if (i == lastRow) extSides.add(3);
      if (j == (nCols - 1)) extSides.add(4);

      // corner cases when the last row is not filled
      // there is an external side 4 on the last panel
      if (i == lastRow && j == lastCol) extSides.add(4);
      // and the second to last row gets sides 3 on the unfilled panels
      if (i == lastRow - 1 && j > lastCol) extSides.add(3);
    }


    return extSides;
  }

  /**
    * Return the row index of the panel, an integer between 0 .. (nRows-1).
    * Where [panelNumber] is an int from 0 .. (nPanels-1). 
    * Panel number 1 has (rowIndex,colIndex) = (0,0), 
    * Panel number 2 has (rowIndex,colIndex) = (0,1),
    * Panel number nCols has (rowIndex,colIndex) = (0,nCols),
    * Panel number nCols+1 has (rowIndex,colIndex) = (1,0), etc. 
    */
  int rowIndex(int panelNumber) => panelNumber ~/ nCols;
  /**
    * Return the col index of the panel, an integer between 0 .. (nCols-1).
    * [panelNumber] is an int from 1 .. (nPanels)
    */
  int colIndex(int panelNumber) => panelNumber % nCols;



}
