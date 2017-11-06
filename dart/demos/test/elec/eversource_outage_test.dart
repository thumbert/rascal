

import 'package:demos/elec/utility_customer_outage.dart';


main() async {
  var outages = new EversourceOutages();
  var res = await outages.getCurrentOutages();
  res.forEach(print);

}