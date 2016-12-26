library finance.security_database;

import 'package:tuple/tuple.dart';
import 'security.dart';


/// A securities database needs to know how to retrieve the price of a security
/// at a give time.
abstract class SecDb {
  num getValue(Security security, DateTime time);
  /// return a List of Tuple2<Security,num>
  List<Tuple2<Security,num>> getDelta(Security security, DateTime time);
}



//class InMemoryDb implements SecDb {
//  List<Map> data;
//  InMemoryDb(this.data);
//  num getValue(Security security, DateTime time) {}
//  num getDelta(Security security, DateTime time) {}
//}