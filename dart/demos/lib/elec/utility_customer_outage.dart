import 'dart:async';
import 'package:html/parser.dart' show parse;
import 'package:http/http.dart' as http;

class EversourceOutages {
  Map<String, String> zoneUrls = {
    'CT': 'https://www.eversource.com/clp/outage/mobile.aspx',
    'Eastern MA': 'https://www.eversource.com/nstar/outage/mobile.aspx',
    'NH': 'https://www.eversource.com/psnh/outage/mobile.aspx',
    'Western MA': 'https://www.eversource.com/wmeco/outage/mobile.aspx'
  };

  /// Get current outages.
  Future<List> getCurrentOutages() async {
    var res = [];
    await Future.forEach(zoneUrls.keys, (zone) async {
      print('Working on zone: $zone');
      res.add(await getOutagesZone(zone));
    });
    DateTime now = new DateTime.now().toUtc();
    return res.expand((e) => e).map((e){
      e['utility'] = 'Eversource';
      e['timestamp'] = now;
      return e;
    }).toList();
  }

  /// Download and parse the text file, return a List of Map
  Future<List<Map>> getOutagesZone(String zone) async {
    String url = zoneUrls[zone];
    var aux = await parseTableFromUrl(url);
    return aux.map((Map e) {
      e['zone'] = zone;
      return e;
    }).toList();
  }

  /// What happens when there are no outages?  It should return
  /// an empty list.
  Future<List<Map>> parseTableFromUrl(String url) async {
    var response = await http.get(Uri.parse(url));
    var document = parse(response.body);
    var body = document.body;
    var table = body.getElementsByClassName('dataTable').first;
    List data = table.getElementsByTagName('tbody').first.nodes;

    /// table has 4 columns, keep only the first 3
    List colNames = ['town', 'totalCustomers', 'customersOut'];
    List res = [];
    for (var row in data) {
      var aux = row.nodes;
      res.add(new Map.fromIterables(colNames,
          [aux[0].text, int.parse(aux[1].text), int.parse(aux[2].text)]));
    }
    return res;
  }
}
