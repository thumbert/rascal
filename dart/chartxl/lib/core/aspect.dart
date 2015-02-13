library core.aspect;

/**
 * Aspect controls the physical aspect ratio of the
 * panels, which is usually the same for all the panels. It can
 * be specified as a ratio (vertical size/horizontal size) or as
 * a character string.  In the latter case, legitimate values
 * are ‘"fill"’ (the default) which tries to make the panels as
 * big as possible to fill the available space; ‘"xy"’, which
 * computes the aspect ratio based on the 45 degree banking rule
 * and ‘"iso"’ for isometric scales, where the
 * relation between physical distance on the device and distance
 * in the data scale are forced to be the same for both axes.
 */
abstract class Aspect {
  static Aspect current = new AspectFill();
}

class AspectFill extends Aspect {
  static final AspectFill _singleton = new AspectFill._internal();
  factory AspectFill() => _singleton;
  AspectFill._internal() {}
}