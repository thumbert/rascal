library cake_pattern;

abstract class Archive {
  int get(String label);
  void insert(String label, int value);
}

class MapArchive implements Archive {
  Map<String, int> _data = {};
  
  MapArchive();
  
  int get(String label) => _data[label];
  void insert(String label, int value) {
    _data[label] = value;
  }
}

//class FileArchive implements Archive {
//  // TODO
//}


class ArchiveComponent {
  Archive archive;
  
  ArchiveComponent(this.archive);
}

Archive pkgArchive;

/*
 * Explicit wiring.  The implements ArchiveComponent is 
 * heavy handed...
 */
class Calculator implements ArchiveComponent {
    
  Archive archive;  
  
  Calculator(this.archive);
  
  int addThemUp(List<String> labels) {
    int sum = 0;
    labels.forEach((e) => sum += archive.get(e));
    return sum;
  }  
}

/*
 * Implicit wiring.  How risky is it?
 */
class Calculator2 {
  Calculator2();
  
  int addThemUp(List<String> labels) {
    int sum = 0;
    labels.forEach((e) => sum += pkgArchive.get(e));
    return sum;
  }  
}



