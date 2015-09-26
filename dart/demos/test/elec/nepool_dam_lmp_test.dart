library elec.nepool_dam_lmp_test;

import 'package:test/test.dart';
import 'package:date/date.dart';
import 'package:demos/elec/nepool_da_lmp.dart';
import 'package:intl/intl.dart';


setup() async {
  Archiver arch = new Archiver();
  await arch.setup();


}

test_nepool_dam() async {

}


main() async {
  await test_nepool_dam();
}