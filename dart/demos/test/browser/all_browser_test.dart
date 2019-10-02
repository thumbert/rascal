@TestOn('chrome')

///  pub run test -p "chrome" test/browser/all_browser_test.dart

import 'package:test/test.dart';
import 'package:timezone/browser.dart';
import 'package:date/date.dart';
import 'package:http/browser_client.dart';
//import 'package:timeseries/timeseries.dart';
//import 'package:elec/elec.dart';
import 'package:elec/src/common_enums.dart';
import 'package:elec_server/client/isoexpress/dalmp.dart';


tests(String rootUrl) async {
  test('Add 2 numbers', () {
    expect(1+2, 3);
  });
  test('LMP stuff', () async {
    var location = getLocation('US/Eastern');
    var client = BrowserClient();
    var api = DaLmp(client, rootUrl: rootUrl);
    var data = await api.getHourlyLmp(
        4000, LmpComponent.lmp, Date(2018, 1, 1), Date(2018, 1, 1));
    print(data.length);
    expect(location.name, 'US/Eastern');

  });


}


void main() async {
  await initializeTimeZone();

  var rootUrl = "http://localhost:8080/"; // testing
  await tests(rootUrl);
}