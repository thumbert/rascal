library elec.plant;

import 'package:tuple/tuple.dart';

enum State {
  Hi, Low, Off
}

class PowerPlant {

  State state;
  num spark, startupCost;
  bool isStartUp;

  PowerPlant() {

  }

  num quantity() {
    num res = 0;
    if (state == State.Hi) res = 600;
    else if (state == State.Low) res = 100;

    return res;
  }

  num profit() {
    num res = quantity()*spark;
    if (isStartUp)
      res -= startupCost;
    return res;
  }

}

class PlantOptimizer {
  PowerPlant plant;

  PlantOptimizer(this.plant);

  optimize(List<Tuple2<int,num>> spark) {

  }
}

