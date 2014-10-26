library test_hashing;

import 'dart:convert';
import 'package:crypto/crypto.dart';

var data = [
 '14003090,"NSTAR_CC","","CARVER","Breaker","762",345,"10/20/2014 08:00:00","10/31/2014 12:00:00","","","Interim Approved","Long Term","N","N","N"',
 '14007480,"CONVEX_CC","","LUDLOW","Breaker","1515-5: 1515",115,"10/21/2014 16:01:00","06/30/2015 23:59:00","","","Interim Approved","Long Term","N","N","N"'
            ];

main() {
  
  data.forEach((String e) {    
    var bytes = UTF8.encode(e);
   
    var hash = new SHA1()..add(bytes);
    var res = hash.close();
    
    print( CryptoUtils.bytesToBase64(res) );  // print the computed hash
  });
  
}